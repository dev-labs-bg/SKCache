//
//  TestTableViewCell.swift
//  SpaceKit
//
//  Created by Steliyan H. on 25.10.17.
//  Copyright © 2017 DevLabs. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {
  
  // MARK: - Singleton properties
  
  // MARK: - Static properties
  
  // MARK: - Public properties
  
  // MARK: - Public methods
  
  // MARK: - Initialize/Livecycle methods
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setupUI()
  }
  
  // MARK: - Override methods
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    collectionView.frame = bounds
  }
  
  // MARK: - Private properties
  
  private var cellCount = 30
  
  private var collectionView: UICollectionView! {
    didSet {
      collectionView.isPrefetchingEnabled = false
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: "Test")
      addSubview(collectionView)
    }
  }
  
  // MARK: - Private methods
  
  private func setupUI() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  }

}

extension TestTableViewCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item == 29 && cellCount < 60 {
      collectionView.performBatchUpdates({
        
        cellCount += 30
        var indexPaths = [IndexPath]()
        for index in 30..<60 {
          indexPaths.append(IndexPath(item: index, section: 0))
        }
        
        collectionView.insertItems(at: indexPaths)
      }, completion: nil)
    }
  }
}

extension TestTableViewCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Test", for: indexPath) as? TestCollectionViewCell {
      SKImageDownloader.shared.loadImage(forUrl: "https://picsum.photos/200/250?image=\(160 + indexPath.item + tag)", completion: { (image, error) in
        DispatchQueue.main.async {
          
          if let cellToUpdate = collectionView.cellForItem(at: indexPath) as? TestCollectionViewCell {
            cellToUpdate.image = image
          }
        }
      })
      
      return cell
    } else {
      return UICollectionViewCell()
    }
  }
}

extension TestTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width / 2 - 15.0, height: collectionView.frame.height - 20.0)
  }
}
