//
//  FSMessageCell.swift
//  fitsky
//  消息cell
//  Created by gouyz on 2019/12/2.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMessageCell: UIView {

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
        
        addSubview(tagImgView)
        addSubview(nameLab)
        addSubview(numLab)
        addSubview(lineView)
        
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(tagImgView)
        }
        numLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(nameLab)
            make.width.greaterThanOrEqualTo(16)
            make.height.equalTo(16)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.bottom.equalTo(self)
            make.right.equalTo(numLab)
            make.height.equalTo(klineWidth)
        }
        
    }
    
    /// 图片tag
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        
        return lab
    }()
    ///
    lazy var numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.backgroundColor = kBtnNoClickBGColor
        lab.font = k12Font
        lab.cornerRadius = 8
        lab.textAlignment = .center
        
        return lab
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
