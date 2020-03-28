//
//  FSIMCircleQrcodeVC.swift
//  fitsky
//  社圈二维码
//  Created by iMac on 2020/3/23.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSIMCircleQrcodeVC: GYZWhiteNavBaseVC {
    
    var qrcode:String = ""
    var headerImgUrl: String = ""
    var circleName:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "社圈二维码"
        
        setUpUI()
        qrcode += "202003"
        qrcodeImgView.image = qrcode.toBase64()!.generateQRCodeWithSize(size: 260)
        userImgView.kf.setImage(with: URL.init(string: headerImgUrl), placeholder: UIImage.init(named: "app_img_avatar_def"))
        nameLab.text = circleName
    }
    func setUpUI(){
        self.view.addSubview(bgView)
        bgView.addSubview(userImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(qrcodeImgView)
        bgView.addSubview(desLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kTitleAndStateHeight + 15)
            make.height.equalTo(410)
        }
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
            make.size.equalTo(CGSize.init(width: 72, height: 72))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.centerY.equalTo(userImgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        qrcodeImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.top.equalTo(userImgView.snp.bottom).offset(15)
            make.size.equalTo(CGSize.init(width: 260, height: 260))
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(qrcodeImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(20)
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = kWhiteColor
        bgView.cornerRadius = 10
        
        return bgView
    }()
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_img_avatar_def")
        imgView.cornerRadius = 36
        
        return imgView
    }()
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        lab.text = "湖塘健身一圈"
        
        return lab
    }()
    /// 二维码图片
    lazy var qrcodeImgView : UIImageView = {
        let imgView = UIImageView()
        
        return imgView
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k12Font
        lab.textAlignment = .center
        lab.text = "扫一扫社圈二维码，立刻申请加入"
        
        return lab
    }()
}
