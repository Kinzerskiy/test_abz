//
//  SignupRouter.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation
import UIKit

protocol SignupRouting: BaseRouting, DismissRouting {
    func showDetailForm(isRegistered: Bool, viewController: UIViewController, animated: Bool)
}

protocol SignupRouterDelegate: AnyObject {
    func signupRouterDidFinish(_ router: SignupRouter)
}

class SignupRouter: BaseRouter, SignupRouting {
    
    var mainRouter: MainRouting?
    
    private var signupViewController: SignupViewController?
    private var navigationController: UINavigationController?
    
    
    weak var delegate: SignupRouterDelegate?

    // MARK: - Memory management
    
    override init(with assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
    }
    
    // MARK: - SignupRouting
    
    override func initialViewController() -> UIViewController {
        
        if navigationController == nil {
            let vc: SignupViewController = assembly.assemblySignupViewController(with: self)
          
            signupViewController = vc
            navigationController = assembly.assemblyNavigationController(with: vc)
            
            mainRouter = instantiateMainRouter()
        }
        return navigationController!
    }
    
    
    func showDetailForm(isRegistered: Bool, viewController: UIViewController, animated: Bool) {
        
        if isRegistered {
            let vc: SuccessViewController = assembly.assemblySuccessViewController(with: self)
            
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            viewController.present(vc, animated: animated, completion: nil)
        } else {
            let vc: FailViewController = assembly.assemblyFailViewController(with: self)
            
            vc.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: animated, completion: nil)
        }
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

extension SignupRouter {
    
    func instantiateMainRouter() -> MainRouter {
        let router = MainRouter.init(with: navigationController, assembly: assembly)
        
        return router
    }
}

extension SignupRouter: SuccessViewControllerDelegate {
    func successViewControllerDidFinish(_ controller: SuccessViewController) {
        self.dissmiss(viewController: controller, animated: true, completion: nil)
        self.delegate?.signupRouterDidFinish(self)
    }
}
