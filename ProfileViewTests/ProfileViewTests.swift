//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by Ruth Dayter on 11.11.2023.
//

@testable import ImageFeedApp
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    func updateAvatar() {}
    func updateProfile(profile: Profile?) {}
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var loggedOut = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func getAvatarURL() -> URL? {
        return nil
    }
    
    func logOut() {
        loggedOut = true
    }
    
}
