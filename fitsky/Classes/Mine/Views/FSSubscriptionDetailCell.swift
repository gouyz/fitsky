//
//  FSSubscriptionDetailCell.swift
//  fitsky
//  单个订阅号 cell
//  Created by gouyz on 2019/12/4.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSSubscriptionDetailCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSSubscriptionModel?{
        didSet{
            if let model = dataModel {
                
                storeImgView.kf.setImage(with: URL.init(string: model.store_logo_thumb!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                tagImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_square_default"))
                nameLab.text = model.store_name
                contentLab.text = model.content
                timeLab.text = model.display_send_time
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(bgView)
        bgView.addSubview(storeImgView)
        bgView.addSubview(tagImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(timeLab)
        bgView.addSubview(contentLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(kMargin)
        }
        
        storeImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        tagImgView.snp.makeConstraints { (make) in
            make.top.right.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 110, height: 110))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(storeImgView.snp.right).offset(kMargin)
            make.top.equalTo(storeImgView)
            make.right.equalTo(tagImgView.snp.left).offset(-kMargin)
            make.height.equalTo(30)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(contentLab.snp.bottom).offset(kMargin)
            make.height.equalTo(20)
            make.bottom.equalTo(-kMargin)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(kMargin)
        }
        
    }
    ///
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 图片tag
    lazy var storeImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = 18
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 图片tag
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        
        return lab
    }()
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.numberOfLines = 0
        
        return lab
    }()
    /// 时间
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        
        return lab
    }()
    
}

