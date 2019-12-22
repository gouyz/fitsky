//
//  FSFoodMenuDetailHeaderView.swift
//  fitsky
//  菜谱详情 header
//  Created by gouyz on 2019/10/16.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFoodMenuDetailHeaderView: UIView {
    
    /// 填充数据
    var dataModel : FSCookBookDetailModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.formData?.title
                topImgView.kf.setImage(with: URL.init(string: (model.formData?.thumb)!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
                
                if model.moreModel?.is_collect == "1" {
                    favouriteBtn.isSelected = true
                }else{
                    favouriteBtn.isSelected = false
                }
            }
        }
    }
    
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
        
        addSubview(topImgView)
        topImgView.addSubview(bgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(favouriteBtn)
        
        topImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(topImgView)
            make.height.equalTo(kTitleHeight)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(favouriteBtn.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(bgView)
        }
        favouriteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(kTitleHeight)
        }
    }
    lazy var topImgView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.image = UIImage.init(named: "icon_bg_ads_default")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        if #available(iOS 11.0, *) {
            // iOS11:只需要带用这个系统方法就可以随意设置View的圆角了，是不是很方便，赶快试一下吧
            view.layer.cornerRadius = 10
            view.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.layerMinXMinYCorner.rawValue | CACornerMask.layerMaxXMinYCorner.rawValue)
        }else{
            view.filletedCorner(CGSize(width: 10, height: 10),         UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue |
                UIRectCorner.topRight.rawValue))
        }
        
        return view
    }()
    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k18Font
        lab.text = "蓝莓香蕉吐司"
        
        return lab
    }()
    /// 收藏
    lazy var favouriteBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_favourite"), for: .normal)
        btn.setImage(UIImage.init(named: "app_icon_favourite_selected"), for: .selected)
        return btn
    }()
}
