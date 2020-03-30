//
//  FSMessageChatCell.swift
//  fitsky
//  消息 chat cell
//  Created by gouyz on 2019/12/2.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMessageChatCell: UIView {

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
        addSubview(timeLab)
        addSubview(contentLab)
        addSubview(numLab)
        addSubview(lineView)
        
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.top.equalTo(tagImgView)
            make.right.equalTo(timeLab.snp.left).offset(-kMargin)
            make.height.equalTo(24)
        }
        timeLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(nameLab)
            make.width.equalTo(120)
            make.height.equalTo(20)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.bottom.equalTo(tagImgView)
        }
        numLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(contentLab)
            make.width.greaterThanOrEqualTo(16)
            make.height.equalTo(16)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(klineWidth)
        }
        
    }
    
    /// 图片tag
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = 24
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        
        return lab
    }()
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        
        return lab
    }()
    /// 时间
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.textAlignment = .right
        
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
        lab.text = "3000"
        
        return lab
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()

}
