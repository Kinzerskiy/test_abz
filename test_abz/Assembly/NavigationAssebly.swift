//
//  NavigationAssebly.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation
import UIKit

protocol CommonNavigationAssemblyProtocol {
    func assemblyTabbarController(with items: Array<UIViewController>) -> UITabBarController
    func assemblyNavigationController(with item: UIViewController) -> UINavigationController
}

protocol MainNavigationAssemblyProtocol {
    func assemblyIntroViewController(with router: MainRouting) -> IntroViewController
    func assemblyNoInternetViewController(with router: MainRouting) -> NoInternetViewController
}

protocol UsersAssemblyProtocol {
    func assemblyUsersViewController(with router: UsersRouting) -> UsersViewController
}

protocol SignupAssemblyProtocol {
    func assemblySignupViewController(with router: SignupRouting) -> SignupViewController
    func assemblySuccessViewController(with router: SignupRouting) -> SuccessViewController
    func assemblyFailViewController(with router: SignupRouting) -> FailViewController
}

protocol NavigationAssemblyProtocol: CommonNavigationAssemblyProtocol,
                                     MainNavigationAssemblyProtocol,
                                     UsersAssemblyProtocol,
                                     SignupAssemblyProtocol
{
    
}

class NavigationAssembly: BaseAssembly, NavigationAssemblyProtocol {
   
    private static let mainStoryboardName = "Main"
    private static let usersStoryboardName = "Users"
    private static let signupStoryboardName = "SignUp"

    // MARK: - Storyboard
    
    func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.mainStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
    }
    
    func usersListStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.usersStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
    }
    
    func signupStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.signupStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
    }
    
    // MARK: Common
    
    func assemblyTabbarController(with items: Array<UIViewController>) -> UITabBarController {
        let controller = mainStoryboard().instantiateViewController(withIdentifier: String(describing: MainTabBarViewController.self)) as! MainTabBarViewController
        controller.viewControllers = items
        
        return controller
    }
    
    func assemblyNavigationController(with item: UIViewController) -> UINavigationController {
        
        return NavigationController(rootViewController: item)
    }
    
    func assemblyAlertController(with title: String, message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    // MARK: Main
    
    func assemblyIntroViewController(with router: MainRouting) -> IntroViewController {
        let vc: IntroViewController = mainStoryboard().instantiateViewController(withIdentifier: String(describing: IntroViewController.self)) as! IntroViewController
        
        return vc
    }
    
    func assemblyNoInternetViewController(with router: MainRouting) -> NoInternetViewController {
        let vc: NoInternetViewController = mainStoryboard().instantiateViewController(withIdentifier: String(describing: NoInternetViewController.self)) as! NoInternetViewController
        vc.router = router
        
        return vc
    }
    
    
    // MARK: Users
    
    func assemblyUsersViewController(with router: any UsersRouting) -> UsersViewController {
        let vc: UsersViewController = usersListStoryboard().instantiateViewController(withIdentifier: String(describing: UsersViewController.self)) as! UsersViewController
        vc.router = router
        
        return vc
    }
    
    // MARK: Signup
    
    func assemblySignupViewController(with router: any SignupRouting) -> SignupViewController {
        let vc: SignupViewController = signupStoryboard().instantiateViewController(withIdentifier: String(describing: SignupViewController.self)) as! SignupViewController
        vc.router = router
        
        return vc
    }
    
    func assemblySuccessViewController(with router: any SignupRouting) -> SuccessViewController {
        let vc: SuccessViewController = signupStoryboard().instantiateViewController(withIdentifier: String(describing: SuccessViewController.self)) as! SuccessViewController
        vc.router = router
        
        return vc
    }
    
    
    func assemblyFailViewController(with router: SignupRouting) -> FailViewController {
        let vc: FailViewController = signupStoryboard().instantiateViewController(withIdentifier: String(describing: FailViewController.self)) as! FailViewController
        vc.router = router
        
        return vc
    }
    
}
