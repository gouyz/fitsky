//
//  FSMyActivityListCell.swift
//  fitsky
//  我的活动 cell
//  Created by gouyz on 2019/10/28.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMyActivityListCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSNearActivityModel?{
        didSet{
            if let model = dataModel {
                
                talkImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_square_default"))
                nameLab.text = model.name
                timeLab.text = "活动时间：\(model.display_activity_stime!)-\(model.display_activity_etime!)"
                numLab.text = "\(model.apply_count!)人已报名"
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
        bgView.addSubview(talkImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(timeLab)
        bgView.addSubview(numLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(contentView)
        }
        talkImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.width.equalTo(155)
            make.bottom.equalTo(-kMargin)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(talkImgView.snp.right).offset(kMargin)
            make.top.equalTo(talkImgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(30)
        }
        numLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(timeLab)
            make.top.equalTo(timeLab.snp.bottom)
        }
        
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = kCornerRadius
        
        return view
    }()
    
    /// 活动图片
    lazy var talkImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_topic_default")
        imgView.cornerRadius = 5
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    /// 活动名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "常州第六次马拉松比赛"
        
        return lab
    }()
    /// 活动时间
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlueFontColor
        lab.font = k13Font
        lab.text = "活动时间：07.01-08.22"
        
        return lab
    }()
    /// 报名人数
    lazy var numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "1200人已报名"
        
        return lab
    }()
}
