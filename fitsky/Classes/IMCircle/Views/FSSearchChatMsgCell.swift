//
//  FSSearchChatMsgCell.swift
//  fitsky
//  查找聊天记录 cell
//  Created by gouyz on 2020/3/29.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSSearchChatMsgCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSSearchChatMessageModel?{
        didSet{
            if let model = dataModel {
                
                tagImgView.kf.setImage(with: URL.init(string: model.portraitUri!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                
                nameLab.text = model.name
                timeLab.text = RCKitUtility.convertMessageTime(model.sentTime / 1000)
                contentLab.text = model.otherInformation
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(tagImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(contentLab)
        contentView.addSubview(lineView)
        
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 44, height: 44))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.top.equalTo(tagImgView)
            make.right.equalTo(timeLab.snp.left).offset(-kMargin)
            make.height.equalTo(20)
        }
        timeLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(nameLab)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(tagImgView)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(klineWidth)
        }
        
    }
    
    /// 图片tag
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = 22
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
        
        return lab
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
