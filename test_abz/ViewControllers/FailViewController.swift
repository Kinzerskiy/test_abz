//
//  FailViewController.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit

class FailViewController: UIViewController {
    
    @IBOutlet weak var failButton: UIButton!
    @IBOutlet weak var failLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var router: SignupRouting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        tryAgainButton.titleLabel?.font = UIFont.nunitoSansRegular(ofSize: 18)
        failLabel.font = UIFont.nunitoSansExtraLight(ofSize: 20)
        failButton.layer.cornerRadius = failButton.bounds.height / 2
        failButton.backgroundColor = AppColors.uniqueYellow
    }
    
    @IBAction func failDidTapped(_ sender: Any) {
        self.router?.dissmiss(viewController: self, animated: true, completion: {})
    }
}
