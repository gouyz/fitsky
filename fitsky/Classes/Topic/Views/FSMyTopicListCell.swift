//
//  FSMyTopicListCell.swift
//  fitsky
//  我的话题 cell
//  Created by gouyz on 2019/9/6.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMyTopicListCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSTalkModel?{
        didSet{
            if let model = dataModel {
                
                talkImgView.kf.setImage(with: URL.init(string: model.material!), placeholder: UIImage.init(named: "icon_bg_topic_default"))
                nameLab.text = model.title
                countLab.text = model.dynamic_count_text! + " " + model.read_count_text!
                
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
        
        contentView.addSubview(talkImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(countLab)
        contentView.addSubview(outImgView)
        contentView.addSubview(lineView)
        
        talkImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.width.equalTo(135)
            make.bottom.equalTo(-kMargin)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(talkImgView.snp.right).offset(kMargin)
            make.top.equalTo(talkImgView).offset(kMargin)
            make.right.equalTo(outImgView.snp.left).offset(-kMargin)
            make.height.equalTo(30)
        }
        countLab.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
        }
        outImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        lineView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        
    }
    
    /// 话题图片
    lazy var talkImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 5
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    /// 话题名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k16Font
        lab.text = "#减脂餐#"
        
        return lab
    }()
    /// 讨论数量 阅读数量
    lazy var countLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.text = "1万讨论 5万阅读"
        
        return lab
    }()
    /// 退出
    lazy var outImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_btn_exit"))
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
