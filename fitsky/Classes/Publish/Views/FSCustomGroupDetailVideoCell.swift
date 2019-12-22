//
//  FSCustomGroupDetailVideoCell.swift
//  fitsky
//  自定义视频选择样式
//  Created by gouyz on 2019/9/5.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import DKImagePickerController

class FSCustomGroupDetailVideoCell: FSCustomGroupDetailImageCell {
    
    class override func cellReuseIdentifier() -> String {
        return "CustomVideoAssetIdentifier"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.videoInfoView)
        self.contentView.accessibilityIdentifier = "CustomVideoAssetAccessibilityIdentifier"
        self.contentView.isAccessibilityElement = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height: CGFloat = 30
        self.videoInfoView.frame = CGRect(x: 0, y: self.contentView.bounds.height - height,
                                          width: self.contentView.bounds.width, height: height)
    }
    
    override weak var asset: DKAsset? {
        didSet {
            if let asset = asset {
                let videoDurationLabel = self.videoInfoView.viewWithTag(-1) as! UILabel
                let minutes: Int = Int(asset.duration) / 60
                let seconds: Int = Int(round(asset.duration)) % 60
                videoDurationLabel.text = String(format: "\(minutes):%02d", seconds)
            }
        }
    }
    
    fileprivate lazy var videoInfoView: UIView = {
        let videoInfoView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 0))
        videoInfoView.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        let videoImageView = UIImageView(image: DKImagePickerControllerResource.videoCameraIcon())
        videoInfoView.addSubview(videoImageView)
        videoImageView.center = CGPoint(x: videoImageView.bounds.width / 2 + 7, y: videoInfoView.bounds.height / 2)
        videoImageView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin]
        
        let videoDurationLabel = UILabel()
        videoDurationLabel.tag = -1
        videoDurationLabel.textAlignment = .right
        videoDurationLabel.font = UIFont.systemFont(ofSize: 12)
        videoDurationLabel.textColor = UIColor.white
        videoInfoView.addSubview(videoDurationLabel)
        videoDurationLabel.frame = CGRect(x: 0, y: 0, width: videoInfoView.bounds.width - 7, height: videoInfoView.bounds.height)
        videoDurationLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return videoInfoView
    }()
}
