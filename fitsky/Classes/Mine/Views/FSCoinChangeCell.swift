//
//  FSCoinChangeCell.swift
//  fitsky
//  我的积分cell
//  Created by gouyz on 2019/10/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSCoinChangeCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSCoinGoodsModel?{
        didSet{
            if let model = dataModel {
                
                bgImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
                nameLab.text = model.goods_name
                coinNumLab.text = model.point! + "积分"
                totalNumLab.text = "限\(model.limit_exchange_number!)份"
                
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
        bgImgView.addSubview(coinNumLab)
        bgImgView.addSubview(totalNumLab)
        bgImgView.addSubview(changeBtn)
        
        bgImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(contentView)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(coinNumLab.snp.left).offset(-kMargin)
            make.height.equalTo(30)
        }
        coinNumLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(nameLab)
            make.width.equalTo(120)
            make.height.equalTo(nameLab)
        }
        totalNumLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameLab)
            make.bottom.equalTo(-kMargin)
            make.right.equalTo(changeBtn.snp.left).offset(-kMargin)
        }
        changeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.height.equalTo(totalNumLab)
            make.width.equalTo(70)
        }
        
    }
    
    /// 服务图片
    lazy var bgImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_ads_default")
        imgView.cornerRadius = kCornerRadius
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k18Font
        lab.text = "阻力带"
        
        return lab
    }()
    ///
    lazy var coinNumLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k15Font
        lab.textAlignment = .right
        lab.text = "300积分"
        
        return lab
    }()
    ///
    lazy var totalNumLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k13Font
        lab.text = "限1000份"
        
        return lab
    }()
    /// 立即兑换
    lazy var changeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kGaryFontColor, for: .normal)
        btn.backgroundColor = kWhiteColor
        btn.setTitle("立即兑换", for: .normal)
        btn.cornerRadius = kCornerRadius
        return btn
    }()

}
