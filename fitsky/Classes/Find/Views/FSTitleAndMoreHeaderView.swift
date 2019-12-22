//
//  FSTitleAndMoreHeaderView.swift
//  fitsky
//  查看更多 header
//  Created by gouyz on 2019/10/14.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSTitleAndMoreHeaderView: UITableViewHeaderFooterView {

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
        contentView.addSubview(moreLab)
        contentView.addSubview(lineView)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(moreLab.snp.left).offset(-kMargin)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.bottom.equalTo(-kMargin)
        }
        moreLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(90)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
    }
    /// 分组名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kBlackFontColor
        lab.text = "资讯"
        
        return lab
    }()
    /// 查看更多
    lazy var moreLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.text = "查看更多 >>"
        
        return lab
    }()
    /// 底部线
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()

}
