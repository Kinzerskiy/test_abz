//
//  SignupRouter.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation
import UIKit

protocol SignupRouting: BaseRouting, DismissRouting {
//    func showDetailForm(with id: Int, isMovie: Bool, viewController: UIViewController, animated: Bool)
}

class SignupRouter: BaseRouter, SignupRouting {
    
    var mainRouter: MainRouting?
    
//    private var movieListViewController: MovieListViewController?
    private var navigationController: UINavigationController?
    
    // MARK: - Memory management
    
    override init(with assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
    }
    
    // MARK: - MovieListRouting
    
    override func initialViewController() -> UIViewController {
        
        if navigationController == nil {
//            let vc: MovieListViewController = assembly.assemblyMovieListViewController(with: self)
          
            let symbol = "popcorn.fill"
            let activeImage = UIImage(systemName: symbol)?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            let inactiveImage = UIImage(systemName: symbol)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            
            
//            vc.tabBarItem.title = "Movies"
//            vc.tabBarItem.image = inactiveImage
//            vc.tabBarItem.selectedImage = activeImage
//            vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
            
//            movieListViewController = vc
//            navigationController = assembly.assemblyNavigationController(with: vc)
//            
//            mainRouter = instantiateMainRouter()
        }
        return navigationController!
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
