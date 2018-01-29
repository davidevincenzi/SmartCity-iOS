//
//  SimilarIssueTableViewCell.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/29/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit

class SimilarIssueTableViewCell: IssueTableViewCell {
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    var onCellTapped: ((SimilarIssueTableViewCell) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = UIColor(named: .PrimaryColor)
    }
    
    override func configure(using viewModel: IssueViewModel) {
        super.configure(using: viewModel)
        
        viewModel.onSelectedChange = { selected in
            self.checkmarkImageView?.isHidden = !selected
        }
        
    }
    
    @IBAction func didTapCell(_ sender: UIControl) {
        onCellTapped?(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
}
