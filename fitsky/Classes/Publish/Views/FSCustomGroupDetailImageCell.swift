//
//  FSCustomGroupDetailImageCell.swift
//  fitsky
//  自定义照片选择样式
//  Created by gouyz on 2019/9/2.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import DKImagePickerController

class FSCustomGroupDetailImageCell: DKAssetGroupDetailBaseCell {
    class override func cellReuseIdentifier() -> String {
        return "FSCustomGroupDetailImageCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.thumbnailImageView.frame = self.bounds
        self.thumbnailImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.thumbnailImageView)
        
        self.checkView.frame = self.bounds
        self.checkView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.checkView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var thumbnailImage: UIImage? {
        didSet {
            self.thumbnailImageView.image = self.thumbnailImage
        }
    }
    
    internal lazy var _thumbnailImageView: UIImageView = {
        let thumbnailImageView = UIImageView()
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        
        return thumbnailImageView
    }()
    
    override var thumbnailImageView: UIImageView {
        get {
            return _thumbnailImageView
        }
    }
    
    fileprivate lazy var checkView: CustomCheckView = CustomCheckView()
    
    override var isSelected: Bool {
        didSet {
            if super.isSelected {
                //                self.thumbnailImageView.alpha = 0.5
                self.checkView.checkImageView.isHighlighted = true
                self.checkView.checkLabel.isHidden = false
            } else {
                //                self.thumbnailImageView.alpha = 1
                self.checkView.checkImageView.isHighlighted = false
                self.checkView.checkLabel.isHidden = true
            }
        }
    }
    override var selectedIndex: Int {
        didSet {
            self.checkView.checkLabel.text =  "\(self.selectedIndex + 1)"
        }
    }
    
}
class CustomCheckView: UIView {
    
    internal lazy var checkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.init(named: "app_icon_choose_photo_ne"))
        imageView.highlightedImage = UIImage.init(named: "app_icon_choose_photo_yes")
        return imageView
    }()
    
    internal lazy var checkLabel: UILabel = {
        let label = UILabel()
        label.font = k12Font
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.cornerRadius = 8
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.checkImageView)
        self.addSubview(self.checkLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.checkImageView.frame = CGRect(x: self.bounds.width - 20, y: 5, width: 16, height: 16)
        self.checkLabel.frame = self.checkImageView.frame
    }
    
}
