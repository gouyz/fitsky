//
//  FSIMCircleCell.swift
//  fitsky
//  社圈 cell
//  Created by gouyz on 2020/3/3.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSIMCircleCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSIMCircleModel?{
        didSet{
            if let model = dataModel {
                
                tagImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                nameLab.text = model.name
                
                if model.memberModel?.is_message_free == "1" {
                    rightIconView.isHidden = false
                }else{
                    rightIconView.isHidden = true
                }
                
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
        
        contentView.addSubview(tagImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(rightIconView)
        contentView.addSubview(lineView)
        
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 64, height: 64))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.centerY.equalTo(tagImgView)
            make.height.equalTo(kTitleHeight)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 12, height: 15))
            make.centerY.equalTo(tagImgView)
            make.right.equalTo(-kMargin)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        
    }
    
    /// 社圈图片
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 32
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "湖塘健身一圈1"
        
        return lab
    }()
    /// 右侧图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_message_disturb_no"))
    
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()

}
