//
//  FSSearchTalkCell.swift
//  fitsky
//  搜索话题 cell
//  Created by gouyz on 2019/8/20.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSSearchTalkCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSTalkModel?{
        didSet{
            if let model = dataModel {
                
                talkImgView.kf.setImage(with: URL.init(string: model.material!), placeholder: UIImage.init(named: "icon_bg_topic_default"))
                nameLab.text = model.title
                countLab.text = model.dynamic_count_text! + " " + model.read_count_text!
                
                /// 推荐（0-否 1-是）
                if model.is_recommend == "1"{
                    tagImgView.isHidden = false
                    tagImgView.snp.updateConstraints { (make) in
                        make.size.equalTo(CGSize.init(width: 16, height: 16))
                    }
                }else{
                    tagImgView.isHidden = true
                    tagImgView.snp.updateConstraints { (make) in
                        make.size.equalTo(CGSize.zero)
                    }
                }
                /// 很火（0-否 1-是）
                hotImgView.isHidden = true
                if model.is_hot == "1"{
                    hotImgView.isHidden = false
                }
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
        contentView.addSubview(hotImgView)
        contentView.addSubview(tagImgView)
        contentView.addSubview(lineView)
        
        talkImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.width.equalTo(135)
            make.bottom.equalTo(contentView)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(talkImgView.snp.right).offset(kMargin)
            make.top.equalTo(talkImgView).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        countLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.right.equalTo(hotImgView.snp.left).offset(-kMargin)
        }
        hotImgView.snp.makeConstraints { (make) in
            make.right.equalTo(tagImgView.snp.left).offset(-5)
            make.centerY.equalTo(countLab)
            make.size.equalTo(CGSize.init(width: 14, height: 16))
        }
        tagImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(countLab)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.bottom.right.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        
    }
    
    /// 话题图片
    lazy var talkImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.cornerRadius = 5
        
        return imgView
    }()
    /// 话题名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k16Font
        
        return lab
    }()
    /// 讨论数量 阅读数量
    lazy var countLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
//        lab.text = "1万讨论 5万阅读"
        
        return lab
    }()
    /// 火
    lazy var hotImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_talk_hot"))
    /// 推荐
    lazy var tagImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_recommend_tag"))
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
