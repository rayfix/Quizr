//
//  CustomButton.swift
//  Quizr
//
//  Created by Ray Fix on 12/8/15.
//  Copyright © 2015 Pelfunc, Inc. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
  
  override func awakeFromNib() {
    rounding = 10
  }
  
  var padding = CGSize(width: 0, height: 0) {
    didSet {
      setNeedsLayout()
    }
  }
  
  var rounding: CGFloat = 0 {
    didSet {
      layer.cornerRadius = rounding
      setNeedsDisplay()
    }
  }
  
  override func intrinsicContentSize() -> CGSize {
    let size = super.intrinsicContentSize()
    return CGSize(width: size.width+padding.width, height: size.height+padding.height)
  }
  
}
