//
//  FSFollowSeePowerCell.swift
//  fitsky
//  关注后查看更多 cell
//  Created by gouyz on 2019/9/4.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFollowSeePowerCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(followLab)
        contentView.addSubview(contentLab)
        contentView.addSubview(lineView)
        
        followLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(20)
            make.size.equalTo(CGSize.init(width: 140, height: 24))
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(followLab.snp.bottom).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(24)
            make.bottom.equalTo(-12)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
    }
    /// 关注
    lazy var followLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kOrangeFontColor
        lab.font = k13Font
        lab.text = "关注作者，阅读全文"
        lab.textAlignment = .center
        lab.cornerRadius = 12
        lab.borderColor = kOrangeFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k12Font
        lab.textAlignment = .center
        lab.text = "还有更多的精彩内容，作者设置为仅对粉丝可见"
        
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
