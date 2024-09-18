//
//  IntroViewController.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit

protocol IntroViewControllerDelegate {
    func introControllerDidFinishLoading(viewController: IntroViewController)
}

class IntroViewController: UIViewController {
    
    var router: MainRouting?
    var introDelegate: IntroViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = AppColors.uniqueYellow
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.introDelegate?.introControllerDidFinishLoading(viewController: self)
        }
    }
}
