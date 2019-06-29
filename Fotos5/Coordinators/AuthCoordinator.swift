//
//  AuthCoordinator.swift
//  Fotos5
//
//  Created by Gary Hanson on 5/17/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit

final class AuthCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var coordinator: AppCoordinator?
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let onBoardingVC = OnboardingViewController.instantiate()
        onBoardingVC.coordinator = self
        
        self.navigationController.delegate = self
        self.navigationController.pushViewController(onBoardingVC, animated: false)
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

    //MARK: controller callbacks
    
    func didTapSignup(onBoardingVC: OnboardingViewController) {
        let signup = SignUpViewController.instantiate()
        signup.coordinator = self
        
        self.navigationController.pushViewController(signup, animated: false)
    }
    
    func didTapSignup(userName: String, password: String, on signup: SignUpViewController) {
        if validSignup(userName: userName, password: password) {
            self.coordinator?.didAuthenticate(coordinator: self)
        } else {
            signup.show(error: SignUpError.alreadyExists)
        }
    }
    
    private func validSignup(userName: String, password: String) -> Bool {
        return true         // don't want to deal with any failures now
    }
    

}

enum SignUpError: Error {
    case alreadyExists
    case invalidUserName
    case invalidPassword
}
