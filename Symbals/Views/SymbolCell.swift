//
//  SymbolCell.swift
//  Symbals
//
//  Created by Aaron Pearce on 19/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

class SymbolCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView().usingAutoLayout()
        imageView.preferredSymbolConfiguration = .init(pointSize: 48)
        imageView.contentMode = .center
        return imageView
    }()
    
    lazy var imageContainerView: UIView = {
        let containerView = UIView().usingAutoLayout()
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 8
        containerView.layer.cornerCurve = .continuous
        containerView.layer.masksToBounds = true
        
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate(imageView.constraintsToFit(view: containerView))
        
        return containerView
    }()
    
    let label: UILabel = {
        let label = UILabel().usingAutoLayout()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        contentView.addSubviews([imageContainerView, label])
        
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 0)
        ])
    }
}
