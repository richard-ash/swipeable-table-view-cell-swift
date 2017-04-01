//
//  SwipeableTableViewCellButton.swift
//  SwipeableTableViewCell
//
//  Created by Richard Ash on 3/31/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit

class SwipeableTableViewCellButton: UIButton {
  
  // MARK: - Private Variables
  
  private var buttonClosure: ((UIButton) -> Void)?
  
  // MARK: - Init
  
  init(title: String, color: UIColor, action: @escaping (UIButton) -> Void) {
    self.buttonClosure = action
    super.init(frame: .zero)
    self.customize(with: title, and: color)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: - Private Functions
  
  @objc private func touchUpInside(sender: UIButton) {
    buttonClosure?(sender)
  }
  
  private func customize(with title: String, and color: UIColor) {
    autoresizingMask = .flexibleHeight
    backgroundColor = color
    frame = CGRect(x: 0, y: 0, width: 80, height: 50)
    setTitle(title, for: .normal)
    setTitleColor(.white, for: .normal)
    addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
  }
}
