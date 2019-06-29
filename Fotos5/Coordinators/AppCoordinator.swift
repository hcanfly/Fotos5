//
//  AppCoordinator.swift
//  Fotos5
//
//  Created by Gary Hanson on 5/17/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit
import Photos


final class AppCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    var _loggedIn = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // initial call from AppDelegate to get things started
    func start() {
        if self.loggedIn() {
            self.showContent()
        } else {
            self.showAuthentication()
        }
    }
    
    // let authCoordinator handle login / sign-in
    
    private func showAuthentication() {
        
        let authCoordinator = AuthCoordinator(navigationController: self.navigationController)
        
        self.childCoordinators.append(authCoordinator)
        authCoordinator.coordinator = self
        authCoordinator.start()
    }
    
    func didAuthenticate(coordinator: AuthCoordinator) {

        self._loggedIn = true       // real world generally requires a bit more effort
        self.childCoordinators.removeAll { $0 === coordinator }
        //self.childCoordinators.removeAll { type(of: $0) === type(of: coordinator) }   // just another way to do this
        self.showContent()
    }
    
    func menuDidSelectContentPage() {
        self.showContent()
    }
    
    func menuDidSelectPhotosPage() {
        self.showPhotosPage()
    }
    
    // show home page and handle callbacks to show different photo screens
    private func showContent() {
        let mainPage = ViewController.instantiate()
        mainPage.coordinator = self
        
        navigationController.viewControllers = [mainPage]
    }
    
    func didSelectDejaVuPhoto(assets: [PHAsset]) {
        self.showPhotosGroupPage(assets: assets)
    }
    
    func didSelectDigestPhoto(assets: [PHAsset]) {
        self.showPhotosGroupPage(assets: assets)
    }
    
    func didSelectCameraRollPhoto(photoIndex: Int) {
        self.showPhotoLibraryPage(photoIndex: photoIndex)
    }
    
    private func showPhotosPage() {
        let photosController = PhotosCollectionViewController.instantiate()
        photosController.coordinator = self

        self.navigationController.delegate = self
        self.navigationController.pushViewController(photosController, animated: true)
    }
    
    private func showPhotosGroupPage(assets: [PHAsset]) {
        let photosController = PhotosGroupCollectionViewController.instantiate()
        photosController.coordinator = self
        photosController.assets = assets
        
        self.navigationController.delegate = self
        self.navigationController.pushViewController(photosController, animated: true)
    }
    
    private func showPhotoLibraryPage(photoIndex: Int) {
        let photoLibraryController = ImagePageViewController.instantiate()
        photoLibraryController.coordinator = self
        photoLibraryController.currentIndex = photoIndex
        
        self.navigationController.delegate = self

        self.navigationController.pushViewController(photoLibraryController, animated: true)
    }
    
    // local functionality
    private func loggedIn() -> Bool {   // probably need something a little better for real work
        return self._loggedIn
    }
    
    // capture back button from nav controller
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // Navigated back from signup page to onboarding page
    }
}

