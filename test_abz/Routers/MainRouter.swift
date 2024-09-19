//
//  MainRouter.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation
import UIKit

protocol MainRouting: BaseRouting, DismissRouting, IntroViewControllerDelegate {
    func showNoInternetForm(isNoInternet: Bool, viewController: UIViewController, animated: Bool)
}

protocol MainRouterDelegate {
    func introRouterDidFinishLoading(router: MainRouter)
}

class MainRouter: BaseRouter, MainRouting {
    
    private var introViewController: IntroViewController?
    private var navigationController: UINavigationController?
    
    var mainDelegate: MainRouterDelegate?
    
    // MARK: - Memory management
    
    override init(with assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
    }
    
    init(with navigationController: UINavigationController?, assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
        
        self.navigationController = navigationController
    }
    
    // MARK: - MainRouting
    
    override func initialViewController() -> UIViewController {
        
        if navigationController == nil {
            let vc: IntroViewController = assembly.assemblyIntroViewController(with: self)
            introViewController = vc
            introViewController?.introDelegate = self
            
            navigationController = assembly.assemblyNavigationController(with: vc)
            navigationController?.isNavigationBarHidden = true
            navigationController?.modalPresentationStyle = .overFullScreen
            navigationController?.modalTransitionStyle = .crossDissolve
            
        }
        return navigationController!
    }
    
    func showNoInternetForm(isNoInternet: Bool, viewController: UIViewController, animated: Bool) {
        let vc: NoInternetViewController = assembly.assemblyNoInternetViewController(with: self)
        
        vc.isNoInternet = isNoInternet
        
        if let presentingVC = viewController as? NoInternetDelegate {
            vc.delegate = presentingVC
        }
        
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: animated, completion: nil)
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
    
    // MARK: - IntroViewControllerDelegate
    
    func introControllerDidFinishLoading(viewController: IntroViewController) {
        mainDelegate?.introRouterDidFinishLoading(router: self)
    }
}
