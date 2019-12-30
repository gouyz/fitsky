//
//  FSCameraBottomView.swift
//  fitsky
//  相机 bottom view
//  Created by gouyz on 2019/12/15.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSCameraBottomView: UIView {
    
    /// 点击操作
    var onClickedOperatorBlock: ((_ index: Int) -> Void)?
    
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(photoImgView)
        addSubview(startImgView)
        addSubview(deleteImgView)
        addSubview(finishImgView)
        addSubview(photoView)
        photoView.addSubview(photoLab)
        photoView.addSubview(photoDotView)
        addSubview(videoView)
        videoView.addSubview(videoLab)
        videoView.addSubview(videoDotView)
        
        startImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(15)
            make.size.equalTo(CGSize.init(width: 72, height: 72))
        }
        photoImgView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.centerY.equalTo(startImgView)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        finishImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(startImgView)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        deleteImgView.snp.makeConstraints { (make) in
            make.right.equalTo(finishImgView.snp.left).offset(-30)
            make.centerY.equalTo(startImgView)
            make.size.equalTo(CGSize.init(width: 22, height: 15))
        }
        photoView.snp.makeConstraints { (make) in
            make.right.equalTo(startImgView.snp.left)
            make.top.equalTo(startImgView.snp.bottom)
            make.width.equalTo(80)
            make.height.equalTo(kTitleHeight)
        }
        photoLab.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(photoView)
            make.height.equalTo(30)
        }
        photoDotView.snp.makeConstraints { (make) in
            make.centerX.equalTo(photoView)
            make.top.equalTo(photoLab.snp.bottom)
            make.size.equalTo(CGSize.init(width: 8, height: 8))
        }
        
        videoView.snp.makeConstraints { (make) in
            make.left.equalTo(startImgView.snp.right)
            make.top.width.height.equalTo(photoView)
        }
        videoLab.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(videoView)
            make.height.equalTo(30)
        }
        videoDotView.snp.makeConstraints { (make) in
            make.centerX.equalTo(videoView)
            make.top.equalTo(videoLab.snp.bottom)
            make.size.equalTo(photoDotView)
        }
    }
    ///选择照片
    lazy var photoImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_camera_photo"))
    
    /// 拍摄
    lazy var startImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_icon_take_video_btn_no"))
        imgView.highlightedImage = UIImage.init(named: "app_icon_take_video_btn_yes")
        imgView.tag = 102
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    /// 删除
    lazy var deleteImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_icon_video_delete_btn"))
        imgView.tag = 103
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    
    /// 完成
    lazy var finishImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_icon_take_photo_ok"))
        imgView.tag = 103
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    ///拍照
    lazy var photoView: UIView = {
        let view = UIView()
        view.tag = 101
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 拍照
    lazy var photoLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "拍照"
        
        return lab
    }()
    ///拍照 圆点
    lazy var photoDotView: UIView = {
        let view = UIView()
        view.backgroundColor = kOrangeFontColor
        view.cornerRadius = 4
        
        return view
    }()
    ///拍视频
    lazy var videoView: UIView = {
        let view = UIView()
        view.tag = 101
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 拍视频
    lazy var videoLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "拍视频"
        
        return lab
    }()
    ///拍视频 圆点
    lazy var videoDotView: UIView = {
        let view = UIView()
        view.backgroundColor = kOrangeFontColor
        view.cornerRadius = 4
        
        return view
    }()
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        if onClickedOperatorBlock != nil {
            onClickedOperatorBlock!(sender.view!.tag)
        }
    }
}
