//
//  ViewController.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit

class UsersViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var usersLogo: UIImageView!
    @IBOutlet weak var usersLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workingWithLabel: UILabel!
    
    var router: UsersRouting?
    var isLoadingIndicatorShown = false
    var refreshControl: UIRefreshControl?
    var viewModel = ViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupViewModel()
    }
    
    
    func setupUI() {
        workingWithLabel.font = UIFont.nunitoSansExtraLight(ofSize: 20)
        backgroundView.backgroundColor = AppColors.uniqueYellow
        tableView.isHidden = true
        backgroundView.isHidden = false
        usersLogo.isHidden = false
        usersLabel.isHidden = false
    }
    
    func setupTableView() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UsersTableViewCell", bundle: nil), forCellReuseIdentifier: "UsersTableViewCell")
    }
    
    @objc func refreshUsers() {
        viewModel.checkInternetConnectionAndFetchUsers(resetData: true) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
                self?.updateUI()
            }
        }
    }
    
    func setupViewModel() {
        viewModel.onNetworkUnavailable = { [weak self] in
            DispatchQueue.main.async {
                self?.presentNoInternetViewController()
            }
        }
        
        viewModel.onNetworkAvailable = { [weak self] in
            DispatchQueue.main.async {
                self?.viewModel.checkInternetConnectionAndFetchUsers(resetData: false) { [weak self] (success, _) in
                    self?.updateUI()
                }
            }
        }
        
        viewModel.onFetchSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateUI()
            }
        }
        
        viewModel.onFetchFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.showErrorMessage()
            }
        }
    }
    
    func showErrorMessage() {
        let alert = UIAlertController(title: "Error", message: "Unable to fetch users. Please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentNoInternetViewController() {
        router?.showNoInternetForm(isNoInternet: true, viewController: self, animated: true)
    }
    
    func updateUI() {
        if viewModel.users.isEmpty {
            tableView.isHidden = true
            backgroundView.isHidden = false
            usersLogo.isHidden = false
            usersLabel.isHidden = false
        } else {
            tableView.isHidden = false
            usersLogo.isHidden = true
            usersLabel.isHidden = true
            tableView.reloadData()
        }
    }
    
    func createLoadingIndicator() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = footerView.center
        spinner.startAnimating()
        footerView.addSubview(spinner)
        return footerView
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.users.count else {
              return UITableViewCell()
          }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as! UsersTableViewCell
        let user = viewModel.users[indexPath.row]
        cell.fill(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        
        if offsetY > contentHeight - height {
            if !self.viewModel.isLoading && self.viewModel.hasMoreUsers {
                
                if self.viewModel.isNetworkAvailable() {
                    self.viewModel.checkInternetConnectionAndFetchUsers(resetData: false) { [weak self] _, _ in
                        self?.tableView.tableFooterView = self?.createLoadingIndicator()
                    }
                } else {
                    self.presentNoInternetViewController()
                    self.tableView.tableFooterView = nil
                }
            } else {
                self.tableView.tableFooterView = nil
            }
        }
    }
}

extension UsersViewController: NoInternetDelegate {
    func didTapTryAgain() {
        viewModel.checkInternetConnectionAndFetchUsers(resetData: false) { [weak self] _,_ in
            self?.viewModel.reset()
        }
    }
}
