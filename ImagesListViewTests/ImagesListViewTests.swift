//
//  ImagesListViewTests.swift
//  ImagesListViewTests
//
//  Created by Ruth Dayter on 11.11.2023.
//

@testable import ImageFeedApp
import XCTest

final class ImagesListViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func getPhotoURL(photo: ImageFeedApp.Photo) -> URL? {
        return nil
    }
}
