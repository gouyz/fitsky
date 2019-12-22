//
//  FSFindCourseStudyNumCell.swift
//  fitsky
//  发现课程详情 学习人数 cell
//  Created by gouyz on 2019/10/16.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFindCourseStudyNumCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSFindCourseDetailModel?{
        didSet{
            if let model = dataModel {
                
                for index in 0 ..< model.userList.count + 1{
                    let imgView: UIImageView = UIImageView()
                    imgView.cornerRadius = 16
                    if index == model.userList.count {
                        imgView.image = UIImage.init(named: "app_icon_more_browse")
                    }else{
                        imgView.kf.setImage(with: URL.init(string: model.userList[index].avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                    }
                    imgView.frame = CGRect.init(x: kMargin + CGFloat(index * 24), y: kMargin, width: 32, height: 32)
                    bgView.addSubview(imgView)
                }
                numLab.text = "已有\((model.formData?.member_count)!)人完成学习"
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
        bgView.addSubview(numLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-5)
            make.height.equalTo(52)
        }
        
        numLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(bgView)
            make.width.equalTo(kScreenWidth * 0.5)
        }
        
//        for index in 0 ..< 5{
//            let imgView: UIImageView = UIImageView()
//            imgView.cornerRadius = 16
//            if index == 4 {
//                imgView.image = UIImage.init(named: "app_icon_more_browse")
//            }else{
//                imgView.image = UIImage.init(named: "app_img_avatar_def")
//            }
//            imgView.frame = CGRect.init(x: kMargin + CGFloat(index * 24), y: kMargin, width: 32, height: 32)
//            bgView.addSubview(imgView)
//        }
        
    }
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    ///
    lazy var numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.textAlignment = .right
        lab.text = "已有1000人完成学习"
        
        return lab
    }()

}
