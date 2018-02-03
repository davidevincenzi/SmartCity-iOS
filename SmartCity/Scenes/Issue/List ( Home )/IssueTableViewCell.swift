//
//  IssueTableViewCell.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit
import FaveButton

class IssueTableViewCell: UITableViewCell, IssueViewInput, FaveButtonDelegate, UIScrollViewDelegate {

    var viewModel: IssueViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            configure(using: viewModel)
        }
    }
    
    // MARK: Views
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var confirmsLabel: UILabel!
    @IBOutlet weak var confirmButton: FaveButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: Output
    
    var didTriggerLongPress: ((IssueTableViewCell) -> ())?
    var didToggleConfirmButton: ((IssueTableViewCell) -> ())?
    
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        confirmButton.addTarget(self, action: #selector(toggleConfirmButton), for: .touchUpInside)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        addGestureRecognizer(longPressGesture)
    }
    
    @objc private func longPress(gesture: UILongPressGestureRecognizer) {
        didTriggerLongPress?(self)
    }
    
    @objc private func toggleConfirmButton() {
        didToggleConfirmButton?(self)
    }
    
    // MARK: -
    
    func configure(using viewModel: IssueViewModel) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumIntegerDigits = 2
        numberFormatter.minimumIntegerDigits = 2
        numberFormatter.maximumFractionDigits = 0
        
        let views = viewModel.model.samples.map { sample -> IssueSampleView in
            let view = IssueSampleView.instantiate()
            view.configure(using: sample)
            return view
        }
        
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        views.forEach({ [unowned self] in
            self.stackView.addArrangedSubview($0)
            self.setup(view: $0)
        })
        
        viewModel.onConfirmedChange = { [unowned self] confirmed in
            self.confirmButton.isSelected = confirmed
        }
        
        viewModel.onConfirmsCountChange = { [unowned self] confirms in
            self.confirmsLabel.text = numberFormatter.string(from: NSNumber(value: confirms))
        }
        
        pageControl?.numberOfPages = viewModel.model.samples.count
        pageControl?.isHidden = viewModel.model.samples.count <= 1
        
    }
    
    // MARK: -
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / bounds.width)
        pageControl.currentPage = page
    }

    // MARK: -
    
    private func setup(view: IssueSampleView) {
        let width = view.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1)
        let height = view.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1)
        NSLayoutConstraint.activate([width, height])
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        didToggleConfirmButton?(self)
    }
    
}

// MARK: -

protocol IssueViewInput: class {
    
    var viewModel: IssueViewModel? { get set }
    
}
