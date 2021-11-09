//
//  ItemListPresenterTests.swift
//  ItemListTests
//
//  Created by Zoeb on 09/11/21.
//

@testable import ItemList
import XCTest

class ItemListPresenterTests: XCTestCase {
    class MockItemListPresenter: ItemListPresenter {
        override func presentItems(response: ItemList.Get.Response) {
            self.viewController?.displayItems(viewModel: ItemList.Get.ViewModel())
            self.viewController?.stopAnimation()
        }
    }
    // MARK: Subject under test
    
    var sut: MockItemListPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupItemListPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupItemListPresenter() {
        sut = MockItemListPresenter()
    }
    
    // MARK: Test doubles
    
    class ItemListDisplayLogicSpy: ItemListDisplayLogic {
        var displayItemsCalled = false
        func displayItems(viewModel: ItemList.Get.ViewModel) {
            displayItemsCalled = true
        }
        
        var stopAnimationCalled = false
        func stopAnimation() {
            stopAnimationCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentItems() {
        // Given
        let spy = ItemListDisplayLogicSpy()
        sut.viewController = spy
        let response = ItemList.Get.Response(data: nil)
        
        // When
        sut.presentItems(response: response)
        
        // Then
        XCTAssertTrue(spy.displayItemsCalled, "presentItems(response:) should ask the view controller to display the result")
    }
    
    func testStopAnimations() {
        // Given
        let spy = ItemListDisplayLogicSpy()
        sut.viewController = spy
        let response = ItemList.Get.Response(data: nil)
        
        // When
        sut.presentItems(response: response)
        
        // Then
        XCTAssertTrue(spy.stopAnimationCalled, "presentItems(response:) should ask the view controller to stop the animation")
    }
}
