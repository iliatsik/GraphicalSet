//
//  CollectionViewCell.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 16.02.22.
//

import UIKit
import Combine

protocol CollectionViewCellDelegate: AnyObject {
    func onCardButton(index: Int)
}

final class CollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    
    var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.titleLabel?.font = .boldSystemFont(ofSize: 31)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = contentView.bounds
    }
    
    func configure(delegate: CollectionViewCellDelegate, cardInfo: CardInfo, isSet: Bool, isSelected: Bool) {        
        self.delegate = delegate
        guard let index = cardInfo.index else { return }
        guard let isHidden = cardInfo.isHidden else { return }
        guard let isEnabled = cardInfo.isEnabled else { return }

        button.tag = index
        button.isHidden = isHidden
        button.isEnabled = isEnabled
        button.setAttributedTitle(cardInfo.title, for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(onCardButton(sender:)), for: .touchUpInside)
        
        if isSelected {
             button.layer.borderWidth = 3.0
             button.layer.borderColor = UIColor.gray.cgColor
             button.backgroundColor = .clear
 
             if isSet {
                     self.button.setAttributedTitle(nil, for: .normal)
                     self.button.backgroundColor = .black
                     self.button.layer.borderColor = UIColor.clear.cgColor
                     self.button.layer.borderWidth = 0.0
 
             } else {
                 self.button.backgroundColor = .clear
             }
         } else {
             self.button.backgroundColor = .gray
         }
    }
    
    @objc private func onCardButton(sender: UIButton) {
        delegate?.onCardButton(index: sender.tag)
    }
}
