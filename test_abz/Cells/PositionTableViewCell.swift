//
//  PositionTableViewCell.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit

class PositionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var positionLabel: UILabel!
    
    var selectionAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionButton.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
        self.selectionStyle = .none
    }
    
    func fill(with position: String, isSelected: Bool) {
        positionLabel.text = position
        updateButtonSelection(isSelected)
    }

    private func updateButtonSelection(_ isSelected: Bool) {
        let imageName = isSelected ? "Radiobutton-fill" : "Radiobutton"
        selectionButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    
    @objc private func toggleSelection() {
        let currentState = selectionButton.image(for: .normal) == UIImage(named: "Radiobutton-fill")
        selectionAction?()
        updateButtonSelection(!currentState)
    }
}
