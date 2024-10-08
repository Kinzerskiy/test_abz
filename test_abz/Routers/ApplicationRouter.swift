//
//  ApplicationRouter.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation
import UIKit

enum ApplicationStoryType {
    case main
    case users
    case signup
}

protocol ApplicationRouting: BaseRouting {
    func showIntroForm(from viewController: UIViewController?, animated: Bool, completion: RoutingCompletionBlock?)
}

class ApplicationRouter: ApplicationRouting, MainRouterDelegate {
    
    private var applicationAssembly: ApplicationAssemblyProtocol
    
    private var rootContentController: UITabBarController?
    
    private var activeStoryType: ApplicationStoryType?
    private var previousStoryType: ApplicationStoryType?
    
    private var mainRouter: MainRouter?
    private var usersRouter: UsersRouter?
    private var signupRouter: SignupRouter?

    private var usersViewController: UIViewController?
    private var signupViewController: UIViewController?
    
    // MARK: - Memory management
    
    required init(with assembly: ApplicationAssemblyProtocol) {
        applicationAssembly = assembly
        setupRouters()
        signupRouter?.delegate = self
    }
    
    private func setupRouters() {
        mainRouter = assemblyMainRouter()
        usersRouter = assemblyUsersRouter()
        signupRouter = assemblySignupRouter()
    }
    
    // MARK: - BaseRouting

    func initialViewController() -> UIViewController? {
        usersViewController = intialialViewControllerForItem(with: .users)
        signupViewController = intialialViewControllerForItem(with: .signup)

        let rootItems = [usersViewController!, signupViewController!]
        rootContentController = navigationAssembly().assemblyTabbarController(with: rootItems)
        return rootContentController
    }

    
    // MARK: - ApplicationRouting
    
    func showIntroForm(from viewController: UIViewController?, animated: Bool, completion: RoutingCompletionBlock?) {
        rootContentController?.present((mainRouter?.initialViewController())!, animated: animated, completion: completion)
    }
    
    // MARK: - AuthRouterDelegate
    
    func introRouterDidFinishLoading(router: MainRouter) {
        Defaults.firstInitialization = false
        router.initialViewController().dismiss(animated: false)
        
        switchToStory(with: .users)
    }

    // MARK: - Assembly
    
    func navigationAssembly() -> NavigationAssemblyProtocol {
        return applicationAssembly.sharedNavigationAssembly
    }
    
    func assemblyMainRouter() -> MainRouter {
        let router = MainRouter(with: navigationAssembly())
        router.mainDelegate = self
        
        return router
    }
    
    func assemblyUsersRouter() -> UsersRouter {
        let router = UsersRouter(with: navigationAssembly())
        
        return router
    }
    
    func assemblySignupRouter() -> SignupRouter {
        let router = SignupRouter(with: navigationAssembly())
        
        return router
    }
    
    // MARK: - Private
    private func indexForStoryType(_ type: ApplicationStoryType) -> Int? {
        switch type {
        case .users:
            return 0
        case .signup:
            return 1
        default:
            return nil
        }
    }

    private func switchToStory(with type: ApplicationStoryType) {
        if let index = indexForStoryType(type) {
            rootContentController?.selectedIndex = index
        }
        
        if activeStoryType != type {
            previousStoryType = activeStoryType
        }
        
        activeStoryType = type
    }

    
    private func intialialViewControllerForItem(with type: ApplicationStoryType) -> UIViewController {
        switch type {
        case .users:
            return (usersRouter?.initialViewController())!
        case .signup:
            return (signupRouter?.initialViewController())!
        case .main:
            return (mainRouter?.initialViewController())!
        }
    }
    
}

extension ApplicationRouter: SignupRouterDelegate {
    func signupRouterDidFinish(_ router: SignupRouter) {
        switchToStory(with: .users)
    }
}
