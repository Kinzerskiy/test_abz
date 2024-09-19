//
//  MainTabBarViewController.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    // Override the selectedIndex property
    override var selectedIndex: Int {
        didSet {
            setupCustomTabBarItems()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCustomTabBarItems()
    }
    
    // MARK: - Custom Tab Bar Item Setup
    private func setupCustomTabBarItems() {
        guard tabBar.items != nil else { return }
        let tabBarButtons = tabBar.subviews.filter { $0.isUserInteractionEnabled }
        
        let titles = ["Users", "SignUp"]
        let images = ["person.3.sequence", "person.crop.circle.fill.badge.plus"]
        
        for (index, button) in tabBarButtons.enumerated() {
            button.subviews.forEach { subview in
                if subview.tag == 1001 {
                    subview.removeFromSuperview()
                }
            }
            
            let isSelected = (index == self.selectedIndex)
            
            let customView = createCustomTabBarItem(title: titles[index], imageName: images[index], isSelected: isSelected)
            customView.frame = button.bounds
            customView.tag = 1001
            button.addSubview(customView)
        }
    }
    
    private func createCustomTabBarItem(title: String, imageName: String, isSelected: Bool) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        
        let label = UILabel()
        label.text = title
        label.textColor = isSelected ? UIColor(hex: "00BDD3") : .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.isUserInteractionEnabled = false
        
        let imageView = UIImageView(image: UIImage(systemName: imageName))
        imageView.tintColor = isSelected ? UIColor(hex: "00BDD3") : .gray
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }
    
    // MARK: - UITabBarControllerDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        setupCustomTabBarItems()
    }
}
