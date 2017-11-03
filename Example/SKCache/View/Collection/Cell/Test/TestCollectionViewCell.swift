//
//  TestCollectionViewCell.swift
//  SpaceKit
//
//  Created by Steliyan H. on 25.10.17.
//  Copyright © 2017 DevLabs. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Singleton properties
  
  // MARK: - Static properties
  
  // MARK: - Public properties
  
  internal weak var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }
  
  // MARK: - Public methods
  
  // MARK: - Initialize/Livecycle methods
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setup()
  }
  
  // MARK: - Override methods
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    imageView.frame = bounds
  }
  
  override func prepareForReuse() {
     super.prepareForReuse()
    
    image = nil
    imageView.image = nil
  }
  
  // MARK: - Private properties
  
  private var imageView: UIImageView! {
    didSet {
      imageView.contentMode = .scaleAspectFill
      imageView.backgroundColor = .red
      imageView.clipsToBounds = true
      contentView.addSubview(imageView)
    }
  }
  
  // MARK: - Private methods
  
  private func setup() {
    imageView = UIImageView()
  }
    
}
