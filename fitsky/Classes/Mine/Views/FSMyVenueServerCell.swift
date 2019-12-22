//
//  FSMyVenueServerCell.swift
//  fitsky
//  我的场馆 服务 cell 
//  Created by gouyz on 2019/11/1.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMyVenueServerCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSVenueServiceModel?{
        didSet{
            if let model = dataModel {
                
                bgImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
                nameLab.text = model.goods_name
                levelNameLab.text = model.difficulty_text
                timeLab.text = "\(model.video_duration_text!)"
                
                priceLab.text = "￥" + String(format: "%.2f", Float(model.price!)!)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(bgImgView)
        bgImgView.addSubview(nameLab)
        bgImgView.addSubview(levelNameLab)
        bgImgView.addSubview(timeLab)
        bgImgView.addSubview(priceLab)
        bgImgView.addSubview(checkImgView)
        
        bgImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(contentView)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        levelNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.bottom.equalTo(-kMargin)
            make.height.equalTo(20)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.equalTo(levelNameLab.snp.right).offset(20)
            make.bottom.height.equalTo(levelNameLab)
            make.width.equalTo(100)
        }
        priceLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(levelNameLab)
            make.size.equalTo(CGSize.init(width: 120, height: 30))
        }
        
        checkImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgImgView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
    }
    
    /// 服务图片
    lazy var bgImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = kCornerRadius
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k18Font
        lab.text = "高效燃脂"
        
        return lab
    }()
    ///
    lazy var levelNameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k13Font
        lab.text = "入门"
        
        return lab
    }()
    /// 时长
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k13Font
        lab.text = "60分钟"
        
        return lab
    }()
    /// 价格
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k18Font
        lab.textAlignment = .right
        lab.text = "￥260"
        
        return lab
    }()
    lazy var checkImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_goods_select_no_white"))
        imgView.highlightedImage = UIImage.init(named: "app_btn_sel_yes")
        
        return imgView
    }()
}
