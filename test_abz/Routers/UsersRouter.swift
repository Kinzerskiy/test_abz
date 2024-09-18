//
//  UsersRouter.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation
import UIKit

protocol UsersRouting: BaseRouting, DismissRouting {
    func showNoInternetForm(isNoInternet: Bool, viewController: UIViewController, animated: Bool)
}

class UsersRouter: BaseRouter, UsersRouting {
    
    var mainRouter: MainRouting?
    
    private var usersViewController: UsersViewController?
    private var navigationController: UINavigationController?
    
    // MARK: - Memory management
    
    override init(with assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
    }
    
    // MARK: - UsersRouting
    
    override func initialViewController() -> UIViewController {
        
        if navigationController == nil {
            let vc: UsersViewController = assembly.assemblyUsersViewController(with: self)
            
            usersViewController = vc
            navigationController = assembly.assemblyNavigationController(with: vc)
            
            mainRouter = instantiateMainRouter()
        }
        return navigationController!
    }
    
    func showNoInternetForm(isNoInternet: Bool, viewController: UIViewController, animated: Bool) {
        mainRouter?.showNoInternetForm(isNoInternet: isNoInternet, viewController: viewController, animated: animated)
    }
    
    func dissmiss(viewController: UIViewController, animated: Bool, completion: (() -> ())?) {
        let CompletionBlock: () -> Void = { () -> () in
            if let completion = completion {
                completion()
            }
        }
        
        if let insertedInNavigationStack = navigationController?.viewControllers.contains(viewController), !insertedInNavigationStack {
            viewController.dismiss(animated: animated, completion: completion)
            return
        }
        
        let isActiveInStack = self.navigationController?.viewControllers.last == viewController
        if !isActiveInStack {
            CompletionBlock()
            return
        }
        
        navigationController?.popViewController(animated: animated)
        
        return
    }
}

extension UsersRouter {
    
    func instantiateMainRouter() -> MainRouter {
        let router = MainRouter.init(with: navigationController, assembly: assembly)
        
        return router
    }
}
