//
//  FSPersonHomeListHeaderView.swift
//  fitsky
//  个人主页list header
//  Created by gouyz on 2019/12/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSPersonHomeListHeaderView: UITableViewHeaderFooterView {
    
    /// 填充数据
    var dataModel : FSSquareUserModel?{
        didSet{
            if let model = dataModel {
                
                /// 会员类型（1-普通 2-达人 3-场馆）
                vipImgView.isHidden = false
                if model.formData?.type == "2"{
                    vipImgView.image = UIImage.init(named: "app_icon_daren")
                }else if model.formData?.type == "3"{
                    vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                }else{
                    vipImgView.isHidden = true
                }
                
                
                userHeaderImgView.kf.setImage(with: URL.init(string: (model.formData?.avatar)!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                nameLab.text = model.formData?.nick_name
                
            }
        }
    }
    
    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(lineView)
        contentView.addSubview(userHeaderImgView)
        contentView.addSubview(vipImgView)
        contentView.addSubview(nameLab)
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        userHeaderImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userHeaderImgView)
            make.size.equalTo(CGSize.init(width: 12, height: 12))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userHeaderImgView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(userHeaderImgView)
            make.right.equalTo(-kMargin)
        }
    }
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    ///用户头像
    lazy var userHeaderImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        imgView.cornerRadius = 19
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    ///名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 13)
        lab.textColor = kGaryFontColor
        lab.text = "Alison"
        
        return lab
    }()
}
