//
//  FSVenueContentCell.swift
//  fitsky
//  场馆简介 cell
//  Created by gouyz on 2019/9/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSVenueContentCell: UITableViewCell {

    /// 填充数据
    var dataModel : FSStoreInfoModel?{
        didSet{
            if let model = dataModel {
                
                /// lab加载富文本
                let desStr = try? NSAttributedString.init(data: model.content!.dealLabelFuTextImgSize().data(using: String.Encoding.unicode)!, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                contentLab.attributedText = desStr
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
        
        contentView.addSubview(contentLab)
        
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
        }
        
    }
    
    /// 场馆简介
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        
        return lab
    }()
}
