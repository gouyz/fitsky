//
//  FSAccountSafeCell.swift
//  fitsky
//  账号安全 cell
//  Created by gouyz on 2019/10/23.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSAccountSafeCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.backgroundColor = kWhiteColor
        
        contentView.addSubview(titleLab)
        contentView.addSubview(contentLab)
        contentView.addSubview(desLab)
        contentView.addSubview(lineView)
        
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(contentView)
            make.bottom.equalTo(lineView.snp.top)
            make.width.equalTo(100)
        }
        contentLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(titleLab)
            make.left.equalTo(titleLab.snp.right).offset(kMargin)
            make.right.equalTo(desLab.snp.left).offset(-kMargin)
        }
        desLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(titleLab)
            make.width.equalTo(80)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
    }
    
    /// 标题
    var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        
        return lab
    }()
    /// 内容
    var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    ///
    var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        
        return lab
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
