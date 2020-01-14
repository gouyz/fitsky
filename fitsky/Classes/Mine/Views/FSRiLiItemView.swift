//
//  FSRiLiItemView.swift
//  fitsky
//  日历item
//  Created by gouyz on 2020/1/14.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSRiLiItemView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(titleLab)
        addSubview(dateLab)
        addSubview(lineView)
        
        titleLab.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(30)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom)
            make.height.equalTo(20)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(dateLab.snp.bottom)
            make.centerX.equalTo(dateLab)
            make.width.equalTo(20)
            make.height.equalTo(4)
        }
        
    }
    ///
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k12Font
        lab.textAlignment = .center
        lab.text = "日"
        
        return lab
    }()
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k12Font
        lab.textAlignment = .center
        lab.text = "17"
        
        return lab
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.UIColorFromRGB(valueRGB: 0xfdc631)
        return line
    }()
}
