//
//  FSFindCourseDetailDesCell.swift
//  fitsky
//  发现 课程详情 课程简介cell
//  Created by gouyz on 2019/10/16.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFindCourseDetailDesCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(nameLab)
        contentView.addSubview(dotView)
        contentView.addSubview(desLab)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(dotView.snp.right).offset(5)
            make.top.equalTo(5)
            make.height.equalTo(30)
            make.right.equalTo(-kMargin)
        }
        dotView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 8, height: 8))
            make.centerY.equalTo(nameLab)
        }
        
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(kMargin)
            make.bottom.equalTo(-kMargin)
        }
        
    }
    lazy var dotView: UIView = {
        let view = UIView()
        view.backgroundColor = kBlueFontColor
        view.cornerRadius = 4
        
        return view
    }()
    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.text = "课程介绍"
        
        return lab
    }()
    /// 课程简介
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        lab.text = "最基础的训练，为——零基础经验的人打开健身之门。本套课用于常年疏于运动或者久坐、久站甚至久卧需要舒展身体的人群，运动轻易掌握，练完后也不太容易出现肌肉酸痛感。"
        
        return lab
    }()
    
}
