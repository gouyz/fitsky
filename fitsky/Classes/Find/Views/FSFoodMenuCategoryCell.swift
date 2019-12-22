//
//  FSFoodMenuCategoryCell.swift
//  fitsky
//  菜谱分类 cell
//  Created by gouyz on 2019/10/13.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFoodMenuCategoryCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSCookBookModel?{
        didSet{
            if let model = dataModel {
                nameLab.text = model.title
                bgImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
                
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
        contentView.addSubview(nameLab)
        contentView.addSubview(lineView)
        
        bgImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.4)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgImgView)
            make.top.equalTo(bgImgView.snp.bottom)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(contentView)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
    }
    
    /// 图片
    lazy var bgImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_ads_default")
        imgView.cornerRadius = kCornerRadius
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k18Font
        lab.text = "蓝莓香蕉吐司"
        
        return lab
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
