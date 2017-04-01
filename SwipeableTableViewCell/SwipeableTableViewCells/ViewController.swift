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
  func swipeableTableViewCell(_ swipeableTableViewCell: SwipeableTableViewCell, buttonsForSide side: SwipeableTableViewCell.Side) -> [SwipeableTableViewCellButton] {
    switch side {
    case .left:
      let yesButton = SwipeableTableViewCellButton(title: "Yes", color: .green) { (_) in
        print("yes!")
      }
      return [yesButton]
    case .right:
      let noButton = SwipeableTableViewCellButton(title: "No", color: .red) { (_) in
        print("no!")
      }
      
      let maybeButton = SwipeableTableViewCellButton(title: "Maybe", color: .blue) { (_) in
        print("maybe??")
      }
      
      return [noButton, maybeButton]
    }
  }
}
