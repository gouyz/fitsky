//
//  GYZEmptyFooterView.swift
//  fitsky
//  尾部空视图
//  Created by gouyz on 2019/8/23.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class GYZEmptyFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        contentView.addSubview(contentLab)
        contentView.addSubview(iconImgView)
        
        iconImgView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 37, height: 29))
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(iconImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(20)
        }
    }
    
    lazy var iconImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_conment_empty"))
    /// 内容显示
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "暂无评论，快来认识吧"
        
        return lab
    }()
    
}
