//
//  FSVenueVideoView.swift
//  fitsky
//  场馆宣传视频
//  Created by gouyz on 2019/11/29.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import ZFPlayer

class FSVenueVideoView: UIView {
    
    var player:ZFPlayerController?
    var dataModel: FSSquareUserModel?
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(model: FSSquareUserModel){
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.init(frame: rect)
        
        self.backgroundColor = UIColor.clear
        
        backgroundView.frame = rect
        backgroundView.backgroundColor = kBlackColor
        addSubview(backgroundView)
        backgroundView.addOnClickListener(target: self, action: #selector(onCancleTap))
        self.dataModel = model
        
        setupUI()
        /// 超出部分裁剪
        containerView.clipsToBounds = true
        showVideo()
        
        setData()
    }
    convenience init(isLand: Bool,url: URL,img:UIImage){
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.init(frame: rect)
        
        self.backgroundColor = UIColor.clear
        
        backgroundView.frame = rect
        backgroundView.backgroundColor = kBlackColor
        addSubview(backgroundView)
        backgroundView.addOnClickListener(target: self, action: #selector(onCancleTap))
        
        
        setupUI()
        /// 超出部分裁剪
        containerView.clipsToBounds = true
        showVideo()
        
        
        containerView.image = img
        
        self.player?.assetURL = url
        if !isLand {
            self.controlView.showTitle("", cover: img, fullScreenMode: .portrait)
        }else{
            self.controlView.showTitle("", cover: img, fullScreenMode: .landscape)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        
        addSubview(bgView)
        bgView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(containerView)
//        containerView.addSubview(playBtn)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(251)
        }
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        contentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        containerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(250)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-1)
        }
//        playBtn.snp.makeConstraints { (make) in
//            make.left.equalTo(15)
//            make.bottom.equalTo(-15)
//            make.size.equalTo(CGSize.init(width: 24, height: 24))
//        }
        
        
    }
    ///整体背景
    lazy var backgroundView: UIView = UIView()
    
    lazy var bgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = kWhiteColor
        bgview.addOnClickListener(target: self, action: #selector(onBgViewClicked))
        
        return bgview
    }()
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    
    lazy var containerView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.setImageWithURLString("", placeholder: ZFUtilities.image(with: UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1), size: CGSize.init(width: 1, height: 1)))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 开始
//    lazy var playBtn : UIButton = {
//        let btn = UIButton.init(type: .custom)
//        btn.setImage(UIImage.init(named: "icon_video_play_white"), for: .normal)
//        btn.addTarget(self, action: #selector(onClickedPlay), for: .touchUpInside)
//
//        return btn
//    }()
    lazy var controlView: ZFPlayerControlView = {
        let playerView = ZFPlayerControlView.init()
        playerView.fastViewAnimated = true
        playerView.autoHiddenTimeInterval = 5
        playerView.autoFadeTimeInterval = 0.5
        playerView.prepareShowLoading = true
        playerView.prepareShowControlView = true
        
        return playerView
    }()
    
    func showVideo(){
        
        let playerManager = ZFAVPlayerManager.init()
        self.player = ZFPlayerController.init(scrollView: scrollView, playerManager: playerManager, containerView: containerView)
        self.player?.shouldAutoPlay = true
        /// 1.0是完全消失的时候
        self.player?.playerDisapperaPercent = 1.0
        /// 0.0是刚开始显示的时候
        self.player?.playerApperaPercent = 0.0
        /// 移动网络依然自动播放
        //        self.player?.isWWANAutoPlay = true
        /// 设置退到后台继续播放
        self.player?.pauseWhenAppResignActive = false
        self.player?.controlView = self.controlView
        //        self.player?.orientationWillChange = {[unowned self] (player,isFullScreen) in
        //            self.setNeedsStatusBarAppearanceUpdate()
        //            UIViewController.attemptRotationToDeviceOrientation()
        //            self.tableView.scrollsToTop = !isFullScreen
        //        }
        
    }
    
    /// 点击背景取消
    @objc func onCancleTap(){
        hide()
    }
    
    @objc func onBgViewClicked(){
        
    }
    
    func show(){
        self.player?.isViewControllerDisappear = false
        UIApplication.shared.keyWindow?.addSubview(self)
        
        showBackground()
        showAlertAnimation()
    }
    func hide(){
        self.player?.isViewControllerDisappear = true
        bgView.isHidden = true
        hideAlertAnimation()
        self.removeFromSuperview()
    }
    
    fileprivate func showBackground(){
        backgroundView.alpha = 0.0
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backgroundView.alpha = 0.6
        UIView.commitAnimations()
    }
    
    fileprivate func showAlertAnimation(){
        let popAnimation = CAKeyframeAnimation(keyPath: "transform")
        popAnimation.duration = 0.3
        popAnimation.values   = [
            NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
            NSValue.init(caTransform3D: CATransform3DIdentity)
        ]
        
        popAnimation.isRemovedOnCompletion = true
        popAnimation.fillMode = CAMediaTimingFillMode.forwards
        bgView.layer.add(popAnimation, forKey: nil)
    }
    
    fileprivate func hideAlertAnimation(){
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backgroundView.alpha = 0.0
        UIView.commitAnimations()
    }
    
    func setData(){
        if  let model = dataModel {
            containerView.kf.setImage(with: URL.init(string: (model.storeData?.video_thumb_url)!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
            
            if !(model.storeData?.video)!.isEmpty{
                self.player?.assetURL = URL.init(string: (model.storeData?.video)!)!
                let imgSize = GYZTool.getThumbSize(url: (model.storeData?.video_material_url)!, thumbUrl: (model.storeData?.video_thumb_url)!)
                if imgSize.height > imgSize.width {
                    self.controlView.showTitle("", coverURLString: model.storeData?.video_thumb_url, fullScreenMode: .portrait)
                }else{
                    self.controlView.showTitle("", coverURLString: model.storeData?.video_thumb_url, fullScreenMode: .landscape)
                }
            }
        }
    }
    
    /// 播放、暂停
//    @objc func onClickedPlay(){
//        if let model = dataModel {
//            if !model.video!.isEmpty{
//                self.player?.assetURL = URL.init(string: (model.video)!)!
//                self.controlView.showTitle("", coverURLString: model.thumb, fullScreenMode: .landscape)
//            }
//        }
//    }
    
}
