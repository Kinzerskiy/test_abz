//
//  NoInternetViewController.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit

// MARK: - Protocols
protocol NoInternetDelegate: AnyObject {
    func didTapTryAgain()
}

class NoInternetViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var noInternetLabel: UILabel!
    
    // MARK: - Properties
    var router: MainRouting?
    weak var delegate: NoInternetDelegate?
    var isNoInternet: Bool = false
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup Methods
    func setupUI() {
        noInternetLabel.font = UIFont.nunitoSansExtraLight(ofSize: 20)
        tryAgainButton.titleLabel?.font = UIFont.nunitoSansRegular(ofSize: 18)
        tryAgainButton.layer.cornerRadius = tryAgainButton.bounds.height / 2
        tryAgainButton.backgroundColor = AppColors.uniqueYellow
    }
    
    // MARK: - Actions
    @IBAction func tryAgainDidTap(_ sender: Any) {
        router?.dissmiss(viewController: self, animated: true, completion: {
            self.delegate?.didTapTryAgain()
        })
    }
    
}
