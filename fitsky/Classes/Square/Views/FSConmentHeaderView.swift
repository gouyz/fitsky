//
//  FSConmentHeaderView.swift
//  fitsky
//  评论header
//  Created by gouyz on 2019/8/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSConmentHeaderView: UITableViewHeaderFooterView {
    
    /// 填充数据
    var dataModel : FSDynamicCountModel?{
        didSet{
            if let model = dataModel {
                nameLab.text = "共有\(model.comment_count!)条评论"
                
                desLab.text = "\(model.like_count!)赞"
            }
        }
    }

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(nameLab)
        contentView.addSubview(desLab)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.width.equalTo(desLab)
            make.top.bottom.equalTo(contentView)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.width.equalTo(nameLab)
        }
    }
    /// 分组名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "共有100条评论"
        
        return lab
    }()
    /// 赞
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "230赞"
        
        return lab
    }()
}
