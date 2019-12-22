//
//  FSVenueInfoCell.swift
//  fitsky
//  场馆信息 cell
//  Created by gouyz on 2019/9/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSVenueInfoCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSStoreInfoModel?{
        didSet{
            if let model = dataModel {
                
                openTimeLab.text = model.business_stime! + "-" + model.business_etime!
                linkPhoneLab.text = model.tel
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
        
        contentView.addSubview(openLab)
        contentView.addSubview(openTimeLab)
        contentView.addSubview(linkLab)
        contentView.addSubview(linkPhoneLab)
        contentView.addSubview(lineView)
        
        openLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        openTimeLab.snp.makeConstraints { (make) in
            make.left.equalTo(openLab.snp.right)
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(openLab)
        }
        linkLab.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(openLab)
            make.top.equalTo(openLab.snp.bottom)
            make.bottom.equalTo(lineView.snp.top).offset(-kMargin)
        }
        linkPhoneLab.snp.makeConstraints { (make) in
            make.left.equalTo(linkLab.snp.right)
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(linkLab)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.height.equalTo(klineWidth)
            make.bottom.equalTo(contentView)
        }
        
    }
    
    ///
    lazy var openLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "营业时间"
        
        return lab
    }()
    ///
    lazy var openTimeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "09：00-22：30"
        
        return lab
    }()
    ///
    lazy var linkLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "联系电话"
        
        return lab
    }()
    /// 联系电话
    lazy var linkPhoneLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlueFontColor
        lab.font = k15Font
        lab.text = "0563-12345678"
        
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
