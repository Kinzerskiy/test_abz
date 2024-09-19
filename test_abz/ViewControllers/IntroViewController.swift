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
    
    // MARK: - Properties
    var router: MainRouting?
    var introDelegate: IntroViewControllerDelegate?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    func setupUI() {
        self.view.backgroundColor = AppColors.uniqueYellow
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.introDelegate?.introControllerDidFinishLoading(viewController: self)
        }
    }
}
