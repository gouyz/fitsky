//
//  FSSubscriptionCell.swift
//  fitsky
//  订阅号列表cell
//  Created by gouyz on 2019/12/4.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSSubscriptionCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSSubscriptionModel?{
        didSet{
            if let model = dataModel {
                
                tagImgView.kf.setImage(with: URL.init(string: model.store_logo_thumb!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                nameLab.text = model.store_name
                contentLab.text = model.content
                timeLab.text = model.display_send_time
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
        
        contentView.addSubview(tagImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(contentLab)
        contentView.addSubview(lineView)
        
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.top.equalTo(tagImgView)
            make.right.equalTo(timeLab.snp.left).offset(-kMargin)
            make.height.equalTo(30)
        }
        timeLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(nameLab)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.right.equalTo(-kMargin)
            make.top.equalTo(nameLab.snp.bottom).offset(kMargin)
            make.bottom.equalTo(lineView.snp.top).offset(-kMargin)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        
    }
    
    /// 图片tag
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = 18
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
        lab.numberOfLines = 0
        
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
