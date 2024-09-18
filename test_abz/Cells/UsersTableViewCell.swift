//
//  UsersTableViewCell.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit
import Kingfisher

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        userPhoto.image = UIImage(named: "Logo")
        userPhoto.layer.cornerRadius = userPhoto.frame.size.height / 2
        userPhoto.clipsToBounds = true
        self.selectionStyle = .none
    }
    
    func fill(with user: User) {
        nameLabel.text = user.name
        positionLabel.text = user.position
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        
        if let url = URL(string: user.photo) {
            userPhoto.kf.indicatorType = .activity
            userPhoto.kf.setImage(
                with: url,
                placeholder: UIImage(named: "Logo"),
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        } else {
            userPhoto.image = UIImage(named: "Logo")
        }
    }
    
}
