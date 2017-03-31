//
//  SwipeableTableViewCell.swift
//  SwipeableTableViewCells
//
//  Created by Richard Ash on 3/20/17.
//  Copyright © 2017 Richard. All rights reserved.
//
// https://medium.com/ios-os-x-development/swipeable-table-view-cells-in-ios-apps-472da0af1935#.1rsztf8kt
// https://github.com/blixt/SwipeableTableViewCell/blob/master/SwipeableTableViewCell/SwipeableTableViewController.m

import UIKit

protocol SwipeableTableViewCellDelegate: class {
  func swipeableTableViewCell(_ swipeableTableViewCell: SwipeableTableViewCell, buttonsForSide side: SwipeableTableViewCell.Side) -> [UIButton]
}

class SwipeableTableViewCell: UITableViewCell {
  
  // MARK: - Objects
  
  enum Side: Int {
    case left, right
  }
  
  // MARK: - Static Variables
  
  static let OpenVelocityThreshold: CGFloat = 0.6
  static let MaxCloseMilliseconds: CGFloat = 300
  
  // MARK: - Variables
  
  weak var delegate: SwipeableTableViewCellDelegate? {
    didSet {
      setUpButtons()
    }
  }
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var scrollViewLabel: UILabel!
  @IBOutlet weak var scrollViewContentView: UIView!
  
  var buttonViews: [UIView]!
  
  // MARK: - Private Variables
  
  fileprivate var leftInset: CGFloat {
    let view = buttonViews[Side.left.rawValue]
    return view.bounds.size.width
  }
  
  fileprivate var containsLeftButtons: Bool {
    return leftInset != 0
  }
  
  fileprivate var rightInset: CGFloat {
    let view = buttonViews[Side.right.rawValue]
    return view.bounds.size.width
  }
  
  fileprivate var containsRightButtons: Bool {
    return rightInset != 0
  }
  
  // MARK: - Overridden Functions
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setUp()
  }
  
  // MARK: - Private Functions
  
  private func setUp() {
    setUpScrollView()
    setUpScrollViewLabel()
    setUpButtonViews()
    setUpButtons()
  }
  
  private func setUpScrollView() {
    scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    scrollView.contentSize = bounds.size
    scrollView.delegate = self
    scrollView.scrollsToTop = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
  }
  
  private func setUpScrollViewLabel() {
    scrollViewLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  private func setUpButtonViews() {
    buttonViews = [createButtonViews(), createButtonViews()]
  }
  
  private func createButtonViews() -> UIView {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: bounds.size.height))
    view.autoresizingMask = .flexibleHeight
    scrollView.insertSubview(view, at: 0)
    return view
  }
  
  private func setUpButtons() {
    let leftButtons = delegate?.swipeableTableViewCell(self, buttonsForSide: .left)
    let rightButtons = delegate?.swipeableTableViewCell(self, buttonsForSide: .right)
    
    leftButtons?.forEach { (button) in
      self.addButton(button, to: .left)
    }
    
    rightButtons?.forEach { (button) in
      self.addButton(button, to: .right)
    }
  }
  
  private func createButton(title: String, backgroundColor: UIColor) -> UIButton {
    let button = UIButton(type: .custom)
    button.autoresizingMask = .flexibleHeight
    button.backgroundColor = backgroundColor
    button.frame = CGRect(x: 0, y: 0, width: 80, height: bounds.size.height)
    button.setTitle(title, for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }
  
  private func addButton(_ button: UIButton, to side: Side) {
    let container = buttonViews[side.rawValue]
    let size = container.bounds.size
    let buttonWidth = button.bounds.width
    
    // Update the button frame
    button.frame = CGRect(x: size.width, y: 0, width: buttonWidth, height: size.height)
    
    // Resize the container to fit the new button.
    let resizedX: CGFloat
    switch side {
    case .left:
      resizedX = -(size.width + buttonWidth)
    case .right:
      resizedX = contentView.bounds.size.width
    }
    container.frame = CGRect(x: resizedX, y: 0, width: size.width + buttonWidth, height: size.height)
    container.addSubview(button)
    
    // Update the scrollable areas outside the scroll view to fit the buttons.
    scrollView.contentInset = UIEdgeInsetsMake(0, leftInset, 0, rightInset);
  }
}

// MARK: - Scroll View Delegate

extension SwipeableTableViewCell: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // If there are no buttons on the left or right side then don't let the user slide to that side
    let isScrollingRight = scrollView.contentOffset.x > 0
    let isScrollingLeft = scrollView.contentOffset.x < 0
    
    if !containsLeftButtons && isScrollingLeft || !containsRightButtons && isScrollingRight {
      scrollView.contentOffset = CGPoint.zero
    }
    
    // Have the buttons appear like they stay in the same place instead of appearing like they are attached to the ends of the cell
    let leftView = buttonViews[Side.left.rawValue]
    let rightView = buttonViews[Side.right.rawValue]
    
    if isScrollingLeft {
      leftView.frame = CGRect(x: scrollView.contentOffset.x, y: 0, width: leftInset, height: leftView.frame.size.height)
      leftView.isHidden = false
      rightView.isHidden = true
    } else if isScrollingRight {
      rightView.frame = CGRect(x: contentView.bounds.size.width - rightInset + scrollView.contentOffset.x, y: 0, width: rightInset, height: rightView.frame.size.height)
      rightView.isHidden = false
      leftView.isHidden = true
    } else {
      leftView.isHidden = true
      rightView.isHidden = true
    }
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let x = scrollView.contentOffset.x
    let isScrollingRight = x > 0
    let isScrollingLeft = x < 0
    
    var newTargetOffset = targetContentOffset.move()
    
    if containsLeftButtons && (x < -leftInset || isScrollingLeft && velocity.x < -SwipeableTableViewCell.OpenVelocityThreshold) {
      newTargetOffset.x = -leftInset
    } else if containsRightButtons && (x > rightInset || isScrollingRight && velocity.x > SwipeableTableViewCell.OpenVelocityThreshold) {
      newTargetOffset.x = rightInset
    } else {
      newTargetOffset = CGPoint.zero
      
      let ms = x / -velocity.x
      if velocity.x == 0 || ms < 0 || ms > SwipeableTableViewCell.MaxCloseMilliseconds {
        DispatchQueue.main.async {
          scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
      }
    }
    
    targetContentOffset.initialize(to: newTargetOffset)
  }
}
