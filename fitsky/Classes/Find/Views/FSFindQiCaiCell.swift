//
//  FSFindQiCaiCell.swift
//  fitsky
//  器材cell
//  Created by gouyz on 2019/10/13.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFindQiCaiCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSFindCourseModel?{
        didSet{
            if let model = dataModel {
                
                bgImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
                nameLab.text = model.name
                desLab.text = model.brief
                numLab.text = "已有\(model.member_count!)人学习"
            }
        }
    }
    
    /// 器材分类填充数据
    var dataCategoryModel : FSFindQiCaiCategoryModel?{
        didSet{
            if let model = dataCategoryModel {
                
                bgImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
                nameLab.text = model.name
                desLab.text = model.desContent
                numLab.isHidden = true
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
        
        contentView.addSubview(bgImgView)
        bgImgView.addSubview(nameLab)
        bgImgView.addSubview(desLab)
        bgImgView.addSubview(numLab)
        
        bgImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.bottom.equalTo(-8)
            make.right.equalTo(-kMargin)
            make.height.equalTo(130)
            make.top.equalTo(5)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
        }
        numLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
            make.left.equalTo(kMargin)
            make.height.equalTo(20)
        }
        
    }
    
    /// 图片
    lazy var bgImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_ads_default")
        imgView.cornerRadius = kCornerRadius
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = UIFont.systemFont(ofSize: 24)
        lab.text = "椭圆机"
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k13Font
        lab.text = "基础动作练习，从0开始！"
        
        return lab
    }()
    
    /// 学习人数
    lazy var numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k12Font
        lab.textAlignment = .right
        lab.text = "已有1000人学习"
        
        return lab
    }()
    
}
