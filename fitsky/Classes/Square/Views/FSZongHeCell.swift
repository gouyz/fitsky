//
//  FSZongHeCell.swift
//  fitsky
//  综合、关注cell
//  Created by gouyz on 2019/8/20.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSZongHeCell: UITableViewCell {

    /// 填充数据
    var dataModel : FSSquareHotModel?{
        didSet{
            if let model = dataModel {

                userImgView.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                /// 会员类型（1-普通 2-达人 3-场馆）
                vipImgView.isHidden = false
                if model.member_type == "2"{
                    vipImgView.image = UIImage.init(named: "app_icon_daren")
                }else if model.member_type == "3"{
                    vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                }else{
                    vipImgView.isHidden = true
                }
                nameLab.text = model.nick_name
                dateLab.text = model.display_create_time
                contentLab.text = model.content
                
                /// 好友关系（0-未关注 1-已关注 2-相互关注 3-自己）
                if model.friend_type == "0"{
                    followLab.isHidden = false
                    followLab.text = "关注"
                    followLab.backgroundColor = kOrangeFontColor
                }
//                else if model.friend_type == "1" || model.friend_type == "2"{
//                    followLab.isHidden = false
//                    followLab.text = "取消关注"
//                    followLab.backgroundColor = kHeightGaryFontColor
//                }
                else{
                    followLab.isHidden = true
                }
                
                if model.is_top == "1" { // 置顶
                    topImgView.isHidden = false
                }else{
                    topImgView.isHidden = true
                }
                
                playImgView.isHidden = true
                
                if !model.video!.isEmpty {
                    imgViews.isHidden = false
                    playImgView.isHidden = false
                    let imgSize = GYZTool.getThumbSize(url: model.video_material_url!, thumbUrl: model.video_thumb_url!)
                    var width = imgSize.width
                    var h = imgSize.height
                    if width > (kScreenWidth - kMargin * 2) {
                        width = (kScreenWidth - kMargin * 2)
                        h = imgSize.height * (kScreenWidth - kMargin * 2) / imgSize.width
                    }
                    imgViews.imgHight = h
                    imgViews.imgWidth = width
//                    if imgSize.width >= imgSize.height {
//                        imgViews.imgHight = imgSize.height * kScreenWidth / imgSize.width
//                        imgViews.imgWidth = kScreenWidth - kMargin * 2
//                    }else{
//                        imgViews.imgHight = imgSize.height
//                        imgViews.imgWidth = imgSize.width
//                    }
                    imgViews.perRowItemCount = 1
                    imgViews.selectImgUrls = [model.video_thumb_url!]
                    let rowIndex = ceil(CGFloat.init((imgViews.selectImgUrls?.count)!) / CGFloat.init(imgViews.perRowItemCount))//向上取整
                    imgViews.snp.updateConstraints { (make) in
                        make.height.equalTo(imgViews.imgHight * rowIndex + kMargin * (rowIndex - 1))
                    }
                    playImgView.snp.remakeConstraints { (make) in
                        make.centerX.equalTo(imgViews.imgWidth * 0.5 + kMargin)
                        make.centerY.equalTo(imgViews)
                        make.size.equalTo(CGSize.init(width: 48, height: 48))
                    }
                }else if model.materialUrlList.count > 0{
                    imgViews.isHidden = false
                    
                    if model.materialUrlList.count == 1 {
                        let imgItem = model.materialList[0]
                        let imgSize = GYZTool.getThumbSize(url: imgItem.material!, thumbUrl: imgItem.thumb!)
                        var width = imgSize.width
                        var h = imgSize.height
                        if width > (kScreenWidth - kMargin * 2) {
                            width = (kScreenWidth - kMargin * 2)
                            h = imgSize.height * (kScreenWidth - kMargin * 2) / imgSize.width
                        }
                        imgViews.imgHight = h
                        imgViews.imgWidth = width
                        imgViews.perRowItemCount = 1
                    }else if model.materialUrlList.count == 2 || model.materialUrlList.count == 4 {
                        imgViews.imgHight = kPhotosImgHeight2
                        imgViews.imgWidth = kPhotosImgHeight2
                        imgViews.perRowItemCount = 2
                    }else{
                        imgViews.imgHight = kPhotosImgHeight3
                        imgViews.imgWidth = kPhotosImgHeight3
                        imgViews.perRowItemCount = 3
                    }

                    imgViews.selectImgUrls = model.materialUrlList
                    let rowIndex = ceil(CGFloat.init((imgViews.selectImgUrls?.count)!) / CGFloat.init(imgViews.perRowItemCount))//向上取整
                    imgViews.snp.updateConstraints { (make) in
                        make.height.equalTo(imgViews.imgHight * rowIndex + kMargin * (rowIndex - 1))
                    }
                }else{
                    imgViews.isHidden = true
                    imgViews.snp.updateConstraints({ (make) in

                        make.height.equalTo(0)
                    })
                }
                if model.position!.isEmpty{
                    addressImgView.isHidden = true
                }else{
                    addressImgView.isHidden = false
                }
                addressLab.text = model.position
                var zanCount: String = model.like_count!
                if zanCount.isEmpty || zanCount == "0"{
                    zanCount = ""
                }
                var conmentCount: String = model.comment_count!
                if conmentCount.isEmpty || conmentCount == "0"{
                    conmentCount = ""
                }
                var collectCount: String = model.collect_count!
                if collectCount.isEmpty || collectCount == "0"{
                    collectCount = ""
                }
                
                if model.moreModel?.is_like == "1"{// 已点赞
                    zanBtn.set(image: UIImage.init(named: "icon_zan_selected"), title: zanCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                    zanBtn.setTitleColor(kOrangeFontColor, for: .normal)
                }else{
                    zanBtn.set(image: UIImage.init(named: "icon_zan"), title: zanCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                    zanBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
                }
                if model.moreModel?.is_collect == "1"{// 已收藏
                    favouriteBtn.set(image: UIImage.init(named: "app_icon_favourite_selected"), title: collectCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                    favouriteBtn.setTitleColor(kOrangeFontColor, for: .normal)
                }else{
                    favouriteBtn.set(image: UIImage.init(named: "app_icon_favourite"), title: collectCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                    favouriteBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
                }
                if model.moreModel?.is_comment == "1"{// 已评论
                    conmentBtn.set(image: UIImage.init(named: "app_icon_comment_selected"), title: conmentCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                    conmentBtn.setTitleColor(kOrangeFontColor, for: .normal)
                }else{
                    conmentBtn.set(image: UIImage.init(named: "app_icon_comment_no"), title: conmentCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                    conmentBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
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
        
        contentView.addSubview(userImgView)
        contentView.addSubview(vipImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(topImgView)
        contentView.addSubview(dateLab)
        contentView.addSubview(followLab)
        contentView.addSubview(downImgView)
        contentView.addSubview(contentLab)
        
        contentView.addSubview(imgViews)
        contentView.addSubview(playImgView)
        contentView.addSubview(addressImgView)
        contentView.addSubview(addressLab)
        contentView.addSubview(favouriteBtn)
        contentView.addSubview(conmentBtn)
        contentView.addSubview(zanBtn)
        contentView.addSubview(lineView)
        
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 14, height: 14))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.top.equalTo(userImgView)
//            make.right.equalTo(topImgView.snp.left).offset(-kMargin)
            make.height.equalTo(20)
        }
        topImgView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
            make.centerY.equalTo(nameLab)
            make.width.equalTo(24)
            make.height.equalTo(12)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.bottom.equalTo(userImgView)
            make.width.equalTo(80)
        }
        followLab.snp.makeConstraints { (make) in
            make.left.equalTo(dateLab.snp.right).offset(kMargin)
            make.bottom.equalTo(dateLab)
            make.size.equalTo(CGSize.init(width: 60, height: 24))
        }
        downImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(userImgView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(userImgView.snp.bottom).offset(kMargin)
        }
        imgViews.snp.makeConstraints { (make) in
            make.top.equalTo(contentLab.snp.bottom).offset(kMargin)
            make.left.right.equalTo(contentLab)
            make.height.equalTo(0)
        }
        playImgView.snp.makeConstraints { (make) in
            make.center.equalTo(imgViews)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        addressImgView.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView)
            make.centerY.equalTo(addressLab)
            make.size.equalTo(CGSize.init(width: 8, height: 14))
        }
        addressLab.snp.makeConstraints { (make) in
            make.left.equalTo(addressImgView.snp.right).offset(3)
            make.right.equalTo(favouriteBtn.snp.left).offset(-kMargin)
            make.top.equalTo(imgViews.snp.bottom).offset(kMargin)
            make.height.equalTo(20)
        }
        favouriteBtn.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(zanBtn)
            make.right.equalTo(conmentBtn.snp.left).offset(-3)
        }
        conmentBtn.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(zanBtn)
            make.right.equalTo(zanBtn.snp.left).offset(-3)
        }
        zanBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(addressLab)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
            make.top.equalTo(addressLab.snp.bottom).offset(kMargin)
        }
        
    }
    
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 24
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "Alison"
        
        return lab
    }()
    /// 置顶
    lazy var topImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_istop"))
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "06-22 13:00"
        
        return lab
    }()
    /// 关注
    lazy var followLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k12Font
        lab.textAlignment = .center
        lab.cornerRadius = 12
        lab.backgroundColor = kOrangeFontColor
        lab.text = "关注"
        
        return lab
    }()
    /// 向下箭头
    lazy var downImgView : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_down_arrow"), for: .normal)
        return btn
    }()
//    lazy var downImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_down_arrow"))
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        lab.text = "5个瑜伽动作，每天十几分钟，告别大粗腿，以前…5个瑜伽动作，每天十几分钟，告别大粗腿，以前…5个瑜伽动作，每天十几分钟，告别大粗腿。"
        
        return lab
    }()
    /// 九宫格图片显示
    lazy var imgViews: GYZPhotoView = GYZPhotoView()
    /// 播放
    lazy var playImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_square_play"))
    /// 定位tag
    lazy var addressImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_location_display"))
    /// 地址
    lazy var addressLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k12Font
        lab.text = "星河公寓"
        
        return lab
    }()
    /// 收藏
    lazy var favouriteBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        return btn
    }()
    /// 评论
    lazy var conmentBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        return btn
    }()
    /// 点赞
    lazy var zanBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        return btn
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor

        return view
    }()
}
