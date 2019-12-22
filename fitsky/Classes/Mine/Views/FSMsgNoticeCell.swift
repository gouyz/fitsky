//
//  FSMsgNoticeCell.swift
//  fitsky
//  消息 通知 cell
//  Created by gouyz on 2019/12/4.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMsgNoticeCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSMsgNoticeModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.title
                contentLab.text = model.content
                dateLab.text = model.display_send_time
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(bgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(tagImgView)
        bgView.addSubview(contentLab)
        bgView.addSubview(dateLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(kMargin)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.top.equalTo(tagImgView)
            make.right.equalTo(dateLab.snp.left).offset(-kMargin)
            make.height.equalTo(30)
        }
        dateLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(nameLab)
            make.width.equalTo(80)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(kMargin)
            make.bottom.equalTo(-kMargin)
            make.right.equalTo(-kMargin)
        }
        
    }
    ///
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 图片
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_icon_message_official")
        imgView.cornerRadius = 18
        
        return imgView
    }()
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        
        return lab
    }()
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        
        return lab
    }()
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        
        return lab
    }()
}
