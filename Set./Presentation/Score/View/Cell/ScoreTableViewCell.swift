//
//  ScoreTableViewCell.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 07.03.22.
//

import UIKit

final class ScoreTableViewCell: UITableViewCell {

    private var constraintsForTableCell: [NSLayoutConstraint] = []

    private var scoreTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dateTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(scoreTitle)
        contentView.addSubview(dateTitle)
        
        constraintsForTableCell.append(contentsOf: [
            
        scoreTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
        scoreTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        scoreTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.safeAreaInsets.top),
        scoreTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: contentView.safeAreaInsets.bottom),

        dateTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
        dateTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        dateTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.safeAreaInsets.top),
        dateTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: contentView.safeAreaInsets.bottom),
        
        ])
        
        NSLayoutConstraint.activate(constraintsForTableCell)

    }

    func configure(scoreTitle: String, dateTitle: String, index: Int) {
        self.scoreTitle.text = scoreTitle
        self.dateTitle.text = dateTitle
    }
}
