//
//  BaseHeaderView.swift
//  HomeRun
//
//  Created by Aaron Pearce on 12/10/18.
//  Copyright © 2018 Sunya. All rights reserved.
//

import UIKit

class BaseHeaderView: UICollectionReusableView {

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel().usingAutoLayout()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .label
        return titleLabel
    }()
    
    let contentView = UIView().usingAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate(contentView.constraintsToFit(view: self, insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)))
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

class BaseFooterView: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel().usingAutoLayout()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.gray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    let contentView = UIView().usingAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate(contentView.constraintsToFit(view: self, insets: UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)))
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}

