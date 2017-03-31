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
    
    cell.scrollViewLabel.text = "\(numbers[indexPath.row])"
    return cell
  }
}

