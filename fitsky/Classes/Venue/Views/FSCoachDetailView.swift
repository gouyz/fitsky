//
//  FSCoachDetailView.swift
//  fitsky
//  教练详情
//  Created by gouyz on 2019/9/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import ZFPlayer
import TTGTagCollectionView

class FSCoachDetailView: UIView {
    
    var player:ZFPlayerController?
    var dataModel: FSCoachModel?

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(model: FSCoachModel){
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        
        addSubview(bgView)
        bgView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(containerView)
        containerView.addSubview(playBtn)
        contentView.addSubview(nameLab)
        contentView.addSubview(sexImgView)
        contentView.addSubview(levelLab)
        contentView.addSubview(tagsView)
        contentView.addSubview(desLab)
        contentView.addSubview(contentLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(400)
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
        }
        playBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-15)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.height.equalTo(30)
            make.top.equalTo(containerView.snp.bottom).offset(5)
        }
        sexImgView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
            make.centerY.equalTo(nameLab)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        levelLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameLab)
            make.right.equalTo(-kMargin)
            make.top.equalTo(nameLab.snp.bottom)
        }
        tagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(levelLab)
            make.top.equalTo(levelLab.snp.bottom)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(levelLab)
            make.height.equalTo(20)
            make.top.equalTo(tagsView.snp.bottom).offset(5)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(levelLab)
            make.top.equalTo(desLab.snp.bottom).offset(5)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
        
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
    lazy var playBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_video_play_white"), for: .normal)
        btn.addTarget(self, action: #selector(onClickedPlay), for: .touchUpInside)
        
        return btn
    }()
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
        self.player?.shouldAutoPlay = false
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
    ///
    lazy var sexImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_sex_man"))
    /// 姓名
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        
        return lab
    }()
    /// 等级
    lazy var levelLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        
        return lab
    }()
    /// 所有标签
    lazy var tagsView: TTGTextTagCollectionView = {
        
        let view = TTGTextTagCollectionView()
        let config = view.defaultConfig
        config?.textFont = k12Font
        config?.textColor = kBlueFontColor
        config?.selectedTextColor = kBlueFontColor
        config?.borderColor = kBlueFontColor
        config?.selectedBorderColor = kBlueFontColor
        config?.backgroundColor = kWhiteColor
        config?.selectedBackgroundColor = kWhiteColor
        config?.cornerRadius = kCornerRadius
        config?.shadowOffset = CGSize.init(width: 0, height: 0)
        config?.shadowOpacity = 0
        config?.shadowRadius = 0
        config?.extraSpace = CGSize.init(width: 12, height: 8)
        view.enableTagSelection = false
        //        view.numberOfLines = 2
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.horizontalSpacing = kMargin
        view.backgroundColor = kWhiteColor
        //        view.alignment = .fillByExpandingWidth
        view.manualCalculateHeight = true
        
        return view
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.text = "自我介绍"
        
        return lab
    }()
    /// 自我介绍内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.numberOfLines = 0
        
        return lab
    }()
    
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
            containerView.kf.setImage(with: URL.init(string: (model.thumb)!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
            nameLab.text = model.name
            if model.sex == "1"{
                sexImgView.image = UIImage.init(named: "app_icon_sex_man")
            }else{
                sexImgView.image = UIImage.init(named: "app_icon_sex_woman")
            }
            
            levelLab.text = (model.coach_rank_text)! + " | 从业" + (model.working_life)! + "年"
            
            tagsView.removeAllTags()
            tagsView.addTags(model.tags)
            
            tagsView.preferredMaxLayoutWidth = kScreenWidth - kMargin * 2
            
            //必须调用,不然高度计算不准确
            tagsView.reload()
            
            contentLab.text = model.self_introduction
        }
    }
    
    /// 播放、暂停
    @objc func onClickedPlay(){
        if let model = dataModel {
            if !model.video!.isEmpty{
                self.player?.assetURL = URL.init(string: (model.video)!)!
                self.controlView.showTitle("", coverURLString: model.thumb, fullScreenMode: .landscape)
            }
        }
    }
    
}

