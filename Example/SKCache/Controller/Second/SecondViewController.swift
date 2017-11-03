//
//  SecondViewController.swift
//  SpaceKit
//
//  Created by Steliyan H. on 25.10.17.
//  Copyright © 2017 DevLabs. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
  
  // MARK: - Singleton properties
  
  // MARK: - Static properties
  
  // MARK: - Public properties
  
  // MARK: - Public methods
  
  // MARK: - Initialize/Livecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  // MARK: - Override methods
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView.frame = view.bounds
  }
  
  // MARK: - Private properties
  
  private var tableView: UITableView! {
    didSet {
      tableView.register(TestTableViewCell.self, forCellReuseIdentifier: "Test")
      tableView.delegate = self
      tableView.dataSource = self
      view.addSubview(tableView)
    }
  }
  
  // MARK: - Private methods

  private func setupUI() {
    tableView = UITableView(frame: .zero, style: .plain)
  }
  
}

extension SecondViewController: UITableViewDelegate {}

extension SecondViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "Test") as? TestTableViewCell {
      cell.tag = 100 * indexPath.row
      return cell
    } else {
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.frame.height / 3
  }
}
