//
//  FSTopicDetailMsgHeaderView.swift
//  fitsky
//  话题简介header
//  Created by gouyz on 2019/9/5.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSTopicDetailMsgHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(tagImgView)
        contentView.addSubview(contentLab)
        contentView.addSubview(lineView)
        
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 15, height: 15))
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(5)
            make.right.equalTo(-kMargin)
            make.top.equalTo(contentView)
            make.bottom.equalTo(lineView.snp.top)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
    }
    ///图片
    lazy var tagImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_lead_msg"))
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k12Font
        
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
