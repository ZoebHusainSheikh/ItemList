//
//  ItemListViewControllerTests.swift
//  ItemListTests
//
//  Created by Zoeb on 09/11/21.
//

@testable import ItemList
import XCTest

class ItemListViewControllerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: ItemListViewController!
    var window: UIWindow!
    var mockItems: [Item] {
        let item = Item()
        item.name = "Test1"
        item.price = "AED 100"
        item.uid = "12345"
        item.createdAt = "2021-01-24 04:04:17.566515"
        item.imageURLs = ["www.google.com"]
        
        return [item]
    }
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupItemListViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupItemListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateInitialViewController()
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test ItemListBusinessLogicSpy
    
    class ItemListBusinessLogicSpy: ItemListBusinessLogic {
        var fetchItemsCalled = false
        
        func fetchItems(request: ItemList.Get.Request) {
            fetchItemsCalled = true
        }
        
        var item: Item?
    }
    
    // MARK: Tests
    
    func testShouldFetchItemsWhenViewIsLoaded() {
        // Given
        let spy = ItemListBusinessLogicSpy()
        
        // When
        loadView()
        sut.interactor = spy
        sut.fetchItems()
        
        // Then
        XCTAssertTrue(spy.fetchItemsCalled, "viewDidLoad() should ask the interactor to fetch items")
    }
    
    func testDisplayItems() {
        // Given
        let spy = ItemListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = ItemList.Get.ViewModel(items: mockItems)
        
        // When
        loadView()
        sut.displayItems(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.items.count, 1, "displayItems(viewModel:) should update the items count with 1 item")
    }
    
    func testDisplayItemName() {
        // Given
        let spy = ItemListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = ItemList.Get.ViewModel(items: mockItems)
        
        // When
        loadView()
        sut.displayItems(viewModel: viewModel)
        guard let item = sut.items.first as Item? else {
            XCTFail("displayItems(viewModel:) don't have any item")
            return
        }
        
        // Then
        XCTAssertEqual(item.name, "Test1", "displayItems(viewModel:) should have name 'Test1'")
    }
    
    func testDisplayItemPrice() {
        // Given
        let spy = ItemListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = ItemList.Get.ViewModel(items: mockItems)
        
        // When
        loadView()
        sut.displayItems(viewModel: viewModel)
        guard let item = sut.items.first as Item? else {
            XCTFail("displayItems(viewModel:) don't have any item")
            return
        }
        
        // Then
        XCTAssertEqual(item.price, "AED 100", "displayItems(viewModel:) should have price 'AED 100'")
    }
    
    func testCreatedDate() {
        // Given
        let spy = ItemListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = ItemList.Get.ViewModel(items: mockItems)
        
        // When
        loadView()
        sut.displayItems(viewModel: viewModel)
        guard let item = sut.items.first as Item? else {
            XCTFail("displayItems(viewModel:) don't have any item")
            return
        }
        
        // Then
        XCTAssertEqual(item.createdAt?.formattedDate, "24-Jan-2021", "displayItems(viewModel:) should have createdDate '24-Jan-2021'")
    }
    
    func testDisplayImage() {
        // Given
        let spy = ItemListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = ItemList.Get.ViewModel(items: mockItems)
        
        // When
        loadView()
        sut.displayItems(viewModel: viewModel)
        guard let item = sut.items.first as Item? else {
            XCTFail("displayItems(viewModel:) don't have any item")
            return
        }
        
        // Then
        let targetURL = URL(string: "www.google.com")
        XCTAssertEqual(item.imageURL, targetURL, "displayItems(viewModel:) should have image url 'www.google.com'")
    }
}
