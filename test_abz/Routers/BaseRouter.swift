//
//  BaseRouter.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation
import UIKit

typealias RoutingCompletionBlock = () -> Void

protocol BaseRouting {
    func initialViewController() -> UIViewController?
}

protocol DismissRouting {
    func dissmiss(viewController: UIViewController, animated: Bool, completion: (()->())?)
}

class BaseRouter: BaseRouting {
    
    internal var applicationRouter: ApplicationRouting?
    internal var assembly: NavigationAssemblyProtocol
    
    // MARK: - Memory management
    
    init(with assembly: NavigationAssemblyProtocol) {
        self.assembly = assembly
    }
    
    func initialViewController() -> UIViewController? {
        return nil
    }
}
