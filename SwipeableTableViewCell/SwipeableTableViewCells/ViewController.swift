//
//  ViewController.swift
//  SwipeableTableViewCells
//
//  Created by Richard Ash on 3/20/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // MARK: - Variables
  
  @IBOutlet weak var tableView: UITableView!
  
  let numbers = [1, 3, 5, 7, 2, 7, 2, 8, 2, 5, 1, 3]
  
  // MARK: - Overridden Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK: - Table View Data Source

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numbers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SwipeableTableViewCell else { return UITableViewCell() }
    
    cell.delegate = self
    
    cell.scrollViewLabel.text = "\(numbers[indexPath.row])"
    return cell
  }
}

// MARK: - Swipeable Table View Cell Delegate 

extension ViewController: SwipeableTableViewCellDelegate {
  func swipeableTableViewCell(_ swipeableTableViewCell: SwipeableTableViewCell, buttonsForSide side: SwipeableTableViewCell.Side) -> [UIButton] {
    switch side {
    case .left:
      let yesButton = createButton(title: "Yes", backgroundColor: .green)
      return [yesButton]
    case .right:
      let noButton = createButton(title: "No", backgroundColor: .red)
      let maybeButton = createButton(title: "Maybe", backgroundColor: .blue)
      return [noButton, maybeButton]
    }
  }
  
  private func createButton(title: String, backgroundColor: UIColor) -> UIButton {
    let button = UIButton(type: .custom)
    button.autoresizingMask = .flexibleHeight
    button.backgroundColor = backgroundColor
    button.frame = CGRect(x: 0, y: 0, width: 80, height: 50)
    button.setTitle(title, for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }
}
