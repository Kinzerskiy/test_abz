//
//  SuccessViewController.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit

protocol SuccessViewControllerDelegate: AnyObject {
    func successViewControllerDidFinish(_ controller: SuccessViewController)
}

class SuccessViewController: UIViewController {
    
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var succsessLabel: UILabel!
    @IBOutlet weak var gotItButton: UIButton!
    
    var router: SignupRouting?
    weak var delegate: SuccessViewControllerDelegate?
    
    var viewModel = ViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        gotItButton.titleLabel?.font = UIFont.nunitoSansRegular(ofSize: 18)
        succsessLabel.font = UIFont.nunitoSansExtraLight(ofSize: 20)
        successButton.layer.cornerRadius = successButton.bounds.height / 2
        successButton.backgroundColor = AppColors.uniqueYellow
    }
    
    @IBAction func successDidTapped(_ sender: Any) {
        self.router?.dissmiss(viewController: self, animated: true, completion: {
            self.viewModel.resetUserData()
            self.delegate?.successViewControllerDidFinish(self)
        })
    }
    
}
