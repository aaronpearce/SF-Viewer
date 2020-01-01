//
//  DetailCell.swift
//  Symbals
//
//  Created by Aaron Pearce on 19/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
      self.layoutIfNeeded()
      var size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
      if let textLabel = self.textLabel, let detailTextLabel = self.detailTextLabel {
        let detailHeight = detailTextLabel.frame.size.height
        if detailTextLabel.frame.origin.x > textLabel.frame.origin.x { // style = Value1 or Value2
          let textHeight = textLabel.frame.size.height
          if (detailHeight > textHeight) {
            size.height += detailHeight - textHeight
          }
        } else { // style = Subtitle, so always add subtitle height
          size.height += detailHeight
        }
      }
      return size
    }
}

