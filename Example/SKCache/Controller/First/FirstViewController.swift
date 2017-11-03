//
//  ViewController.swift
//  SpaceKit
//
//  Created by Steliyan H. on 10.10.17.
//  Copyright © 2017 DevLabs. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageViewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    imageViewCollectionView.frame = view.bounds
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private var cellCount = 30
  
  private var imageViewCollectionView: UICollectionView! {
    didSet {
      imageViewCollectionView.isPrefetchingEnabled = false
      imageViewCollectionView.dataSource = self
      imageViewCollectionView.delegate = self
      imageViewCollectionView.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: "Test")
      view.addSubview(imageViewCollectionView)
    }
  }
}

extension FirstViewController: UICollectionViewDelegate {
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

extension FirstViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Test", for: indexPath) as? TestCollectionViewCell {
      SKImageDownloader.shared.loadImage(forUrl: "https://picsum.photos/300/300?image=\(160 + indexPath.item)", completion: { (image, error) in
        if let cellToUpdate = collectionView.cellForItem(at: indexPath) as? TestCollectionViewCell {
          cellToUpdate.image = image
        }
      })
      
      return cell
    } else {
      return UICollectionViewCell()
    }
  }
}

extension FirstViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width / 2 - 15.0, height: collectionView.frame.height / 3)
  }
}

