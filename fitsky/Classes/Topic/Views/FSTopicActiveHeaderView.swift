//
//  FSTopicActiveHeaderView.swift
//  fitsky
//  活跃度排名 header
//  Created by gouyz on 2019/9/6.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSTopicActiveHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
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
            make.size.equalTo(CGSize.init(width: 16, height: 16))
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
    lazy var tagImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_active_laba"))
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
