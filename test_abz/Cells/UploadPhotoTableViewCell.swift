//
//  UploadPhotoTableViewCell.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit

class UploadPhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundUploadView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    var selectedImage: UIImage?
    
    var uploadTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        self.selectionStyle = .none
    }
    
    func setupUI() {
        infoLabel.isHidden = true
        backgroundUploadView.layer.borderWidth = 1.0
        backgroundUploadView.layer.cornerRadius = 4
        backgroundUploadView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
    }
    
    @IBAction func uploadPhotoDidTap(_ sender: Any) {
        uploadTapped?()
    }
    
}
