//
//  ItemListInteractorTests.swift
//  ItemListTests
//
//  Created by Zoeb on 09/11/21.
//

@testable import ItemList
import XCTest

class ItemListInteractorTests: XCTestCase {
    class MockItemListInteractor: ItemListInteractor {
        override func fetchItems(request: ItemList.Get.Request) {
            let response = ItemList.Get.Response(data: nil)
            self.presenter?.presentItems(response: response)
        }
    }
    
    // MARK: Subject under test
    
    var sut: MockItemListInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupItemListInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupItemListInteractor() {
        sut = MockItemListInteractor()
    }
    
    // MARK: Test doubles
    
    class ItemListPresentationLogicSpy: ItemListPresentationLogic {
        var presentItemsCalled = false
        
        func presentItems(response: ItemList.Get.Response) {
            presentItemsCalled = true
        }
    }
    
    // MARK: Tests
    
    func testFetchItem() {
        // Given
        let spy = ItemListPresentationLogicSpy()
        sut.presenter = spy
        let request = ItemList.Get.Request(url: String.empty)
        
        // When
        sut.fetchItems(request: request)
        
        // Then
        XCTAssertTrue(spy.presentItemsCalled, "fetchItems(request:) should ask the presenter to format the result")
    }
}
