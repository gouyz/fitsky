//
//  FSIMCircleQrcodeVC.swift
//  fitsky
//  社圈二维码
//  Created by iMac on 2020/3/23.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSIMCircleQrcodeVC: GYZWhiteNavBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "社圈二维码"
        
        
        setUpUI()
    }
    func setUpUI(){
        self.view.addSubview(bgView)
        bgView.addSubview(userImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(qrcodeImgView)
        bgView.addSubview(desLab)
        
        
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
