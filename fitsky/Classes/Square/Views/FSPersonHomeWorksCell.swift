//
//  FSPersonHomeWorksCell.swift
//  fitsky
//  个人主页 作品cell
//  Created by gouyz on 2019/8/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSPersonHomeWorksCell: UICollectionViewCell {
    
    /// 填充数据
    var dataModel : FSWorksCategoryModel?{
        didSet{
            if let model = dataModel {
                
                iconView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                seeNumLab.text = model.read_count
                titleLab.text = model.name
                numLab.text = "\(model.opus_count!)个作品"
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        iconView.addSubview(bgView)
        bgView.addSubview(seeImgView)
        bgView.addSubview(seeNumLab)
        addSubview(titleLab)
        addSubview(numLab)
        
        iconView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(floor((kScreenWidth - kMargin * 3)/2))
        }
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.bottom.equalTo(-4)
            make.height.equalTo(20)
            make.width.equalTo(kTitleHeight)
        }
        seeImgView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 12, height: 9))
        }
        seeNumLab.snp.makeConstraints { (make) in
            make.left.equalTo(seeImgView.snp.right).offset(3)
            make.right.equalTo(-3)
            make.height.equalTo(15)
            make.centerY.equalTo(seeImgView)
        }
        titleLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(kMargin)
            make.height.equalTo(20)
        }
        numLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///
    lazy var iconView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        imgView.cornerRadius = kCornerRadius
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayBackGroundColor
        view.alpha = 0.6
        view.cornerRadius = 10
        
        return view
    }()
    /// tag
    lazy var seeImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_read"))
    /// 读数量
    lazy var seeNumLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k10Font
        lab.text = "1.5k"
        
        return lab
    }()
    /// 名称
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "高效减脂"
        
        return lab
    }()
    /// 数量
    lazy var numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "7个作品"
        
        return lab
    }()
}
