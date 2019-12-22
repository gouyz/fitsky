//
//  FSPingBiListCell.swift
//  fitsky
//  屏蔽名单 cell
//  Created by gouyz on 2019/10/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSPingBiListCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSMemberBlackModel?{
        didSet{
            if let model = dataModel {
                
                headerImgView.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                nameLab.text = model.nick_name
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
        
        contentView.addSubview(headerImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(lineView)
        
        headerImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        nameLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.left.equalTo(headerImgView.snp.right).offset(kMargin)
            make.bottom.equalTo(lineView.snp.top)
            make.top.equalTo(contentView)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
    }
    ///
    lazy var headerImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_img_avatar_def")
        imgView.cornerRadius = 24
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "跑跑更健康"
        
        return lab
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
