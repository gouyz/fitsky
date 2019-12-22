//
//  FSFindQiCaiDetailCell.swift
//  fitsky
//  发现 器材详情 器材信息cell
//  Created by gouyz on 2019/10/15.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFindQiCaiDetailCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSQiCaiDetailModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.formData?.name
                desLab.text = model.formData?.desContent
                
                if model.moreModel?.is_collect == "1" {
                    favouriteBtn.isSelected = true
                }else{
                    favouriteBtn.isSelected = false
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
        
        contentView.addSubview(lineView)
        contentView.addSubview(nameLab)
        contentView.addSubview(desLab)
        contentView.addSubview(favouriteBtn)
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(lineView.snp.bottom).offset(5)
            make.right.equalTo(favouriteBtn.snp.left).offset(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        favouriteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(nameLab)
            make.width.equalTo(kTitleHeight)
        }
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(5)
            make.bottom.equalTo(-kMargin)
            make.right.equalTo(-kMargin)
        }
    }
    
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k18Font
        lab.text = "椭圆机"
        
        return lab
    }()
    /// 收藏
    lazy var favouriteBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_favourite"), for: .normal)
        btn.setImage(UIImage.init(named: "app_icon_favourite_selected"), for: .selected)
        return btn
    }()
    ///  描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        lab.text = "科学、健康的有氧运动机械之一，心肺适能运动训练工具，还可以有效地减少脂肪。可以在下肢关节不受太多损 伤影响的前提下，长时间地大幅度运动。适合膝踝关节不好的人。"
        
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
