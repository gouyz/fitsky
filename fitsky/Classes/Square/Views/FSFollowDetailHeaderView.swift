//
//  FSFollowDetailHeaderView.swift
//  fitsky
//  关注详情 header
//  Created by gouyz on 2019/9/4.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import ZFPlayer

class FSFollowDetailHeaderView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(bgView)
        bgView.addSubview(bgImgView)
        bgImgView.addSubview(playBtn)
        bgView.addSubview(userImgView)
        bgView.addSubview(vipImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(dateLab)
        bgView.addSubview(followLab)
        bgView.addSubview(numLab)
        bgView.addSubview(titleLab)
        
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(-5)
        }
        bgImgView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(bgView)
            make.height.equalTo(kScreenWidth * 200.0 / 375.0)
        }
        playBtn.snp.makeConstraints { (make) in
            make.center.equalTo(bgImgView)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        userImgView.snp.makeConstraints { (make) in
            make.top.equalTo(bgImgView.snp.bottom).offset(kMargin)
            make.left.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 72, height: 72))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.right.equalTo(followLab.snp.left).offset(-kMargin)
            make.bottom.equalTo(userImgView.snp.centerY)
            make.height.equalTo(24)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(20)
        }
        followLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(userImgView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 60, height: 24))
        }
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView)
            make.top.equalTo(userImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(30)
            make.right.equalTo(-kMargin)
        }
        numLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom)
            make.height.equalTo(20)
        }
        
    }
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    ///
//    lazy var bgImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_bg_homepage"))
    lazy var bgImgView: UIImageView = {
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

        return btn
    }()
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 36
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.text = "Alison"
        
        return lab
    }()
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "06-22 13:00"
        
        return lab
    }()
    /// 关注
    lazy var followLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k12Font
        lab.textAlignment = .center
        lab.cornerRadius = 12
        lab.backgroundColor = kOrangeFontColor
        lab.text = "关注"
        
        return lab
    }()
    ///数量
    lazy var numLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        lab.text = "1000次浏览"
        
        return lab
    }()
    ///title
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        lab.textColor = kBlackFontColor
        lab.text = "瑜伽练习的最佳时间"
        
        return lab
    }()
}
