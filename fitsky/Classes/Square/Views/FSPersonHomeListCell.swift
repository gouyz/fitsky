//
//  FSPersonHomeListCell.swift
//  fitsky
//  个人主页 主页cell
//  Created by gouyz on 2019/8/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSPersonHomeListCell: UITableViewCell {
    /// 填充数据
    var dataModel : FSSquareHotModel?{
        didSet{
            if let model = dataModel {
                
                //                if model.type == "3" || model.type == "6"{// 视频
                //                    playImgView.isHidden = false
                //                }else{
                //                    playImgView.isHidden = true
                //                }
                
                dateLab.text = model.display_create_time
                
                if model.topic_id != "0" {
                    
                    let content: String = model.content! + " #\(model.topic_id_text!)#"
                    let attStr = NSMutableAttributedString.init(string: content)
                    attStr.addAttribute(NSAttributedString.Key.font, value: k14Font, range: NSMakeRange(0, content.count))
                    attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeFontColor, range: NSMakeRange(content.count - model.topic_id_text!.count - 2,model.topic_id_text!.count + 2))
                    attStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: NSMakeRange(content.count - model.topic_id_text!.count - 1,model.topic_id_text!.count))
                     
                    contentLab.attributedText = attStr
                    
                }else{
                    let content: String = model.content! + " "
                    let attStr = NSMutableAttributedString.init(string: content)
                    attStr.addAttribute(NSAttributedString.Key.font, value: k14Font, range: NSMakeRange(0, content.count))

                    contentLab.attributedText = attStr
                
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
                    if width > (kScreenWidth - 53) {
                        width = (kScreenWidth - 53)
                        h = imgSize.height * (kScreenWidth - 53) / imgSize.width
                    }
                    imgViews.imgHight = h
                    imgViews.imgWidth = width
                    imgViews.perRowItemCount = 1
                    imgViews.selectImgUrls = [model.video_thumb_url!]
                    let rowIndex = ceil(CGFloat.init((imgViews.selectImgUrls?.count)!) / CGFloat.init(imgViews.perRowItemCount))//向上取整
                    imgViews.snp.updateConstraints { (make) in
                        make.height.equalTo(imgViews.imgHight * rowIndex + kMargin * (rowIndex - 1))
                    }
                    playImgView.snp.remakeConstraints { (make) in
                        make.centerX.equalTo(imgViews.imgWidth * 0.5 + kMargin)
                        make.centerY.equalTo(imgViews)
                        make.size.equalTo(CGSize.init(width: 34, height: 34))
                    }
                }else if model.materialUrlList.count > 0{
                    imgViews.isHidden = false
                    
                    if model.materialUrlList.count == 1 {
                        let imgItem = model.materialList[0]
                        let imgSize = GYZTool.getThumbSize(url: imgItem.material!, thumbUrl: imgItem.thumb!)
                    
                        var width = imgSize.width
                        var h = imgSize.height
                        if width > (kScreenWidth - 53) {
                            width = (kScreenWidth - 53)
                            h = imgSize.height * (kScreenWidth - 53) / imgSize.width
                        }
                        imgViews.imgHight = h
                        imgViews.imgWidth = width
                        
                        imgViews.perRowItemCount = 1
                    }else if model.materialUrlList.count == 2 || model.materialUrlList.count == 4 {
                        imgViews.imgHight = (kScreenWidth - 65)/2.0
                        imgViews.imgWidth = (kScreenWidth - 65)/2.0
                        imgViews.perRowItemCount = 2
                    }else{
                        imgViews.imgHight = kPhotosImgHeight4Processing
                        imgViews.imgWidth = kPhotosImgHeight4Processing
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
        
        contentView.addSubview(topLineView)
        contentView.addSubview(dotView)
        contentView.addSubview(lineView)
        contentView.addSubview(dateLab)
        contentView.addSubview(topImgView)
        
        contentView.addSubview(bgView)
        bgView.addSubview(contentLab)
        bgView.addSubview(downImgView)
        bgView.addSubview(imgViews)
        bgView.addSubview(playImgView)
        bgView.addSubview(addressImgView)
        bgView.addSubview(addressLab)
        bgView.addSubview(favouriteBtn)
        bgView.addSubview(conmentBtn)
        bgView.addSubview(zanBtn)
        
        topLineView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.bottom.equalTo(dotView.snp.top)
            make.centerX.width.equalTo(lineView)
        }
        dotView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(dateLab)
            make.size.equalTo(CGSize.init(width: 8, height: 8))
        }
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.centerX.equalTo(dotView)
            make.width.equalTo(klineDoubleWidth)
            make.top.equalTo(dotView.snp.bottom)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.equalTo(dotView.snp.right).offset(5)
            make.top.equalTo(contentView)
            make.right.equalTo(topImgView.snp.left).offset(-kMargin)
            make.height.equalTo(34)
        }
        topImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(dateLab)
            make.width.equalTo(28)
            make.height.equalTo(16)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(dateLab)
            make.right.equalTo(-kMargin)
            make.top.equalTo(dateLab.snp.bottom)
            make.bottom.equalTo(contentView)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(downImgView.snp.left).offset(-5)
            make.top.equalTo(kMargin)
        }
        downImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        imgViews.snp.makeConstraints { (make) in
            make.top.equalTo(contentLab.snp.bottom).offset(kMargin)
            make.left.equalTo(contentLab)
            make.right.equalTo(downImgView)
            make.height.equalTo(0)
        }
        playImgView.snp.makeConstraints { (make) in
            make.center.equalTo(imgViews)
            make.size.equalTo(CGSize.init(width: 34, height: 34))
        }
        addressImgView.snp.makeConstraints { (make) in
            make.left.equalTo(contentLab)
            make.centerY.equalTo(addressLab)
            make.size.equalTo(CGSize.init(width: 8, height: 14))
        }
        addressLab.snp.makeConstraints { (make) in
            make.left.equalTo(addressImgView.snp.right).offset(3)
            make.right.equalTo(-kMargin)
            make.top.equalTo(imgViews.snp.bottom).offset(kMargin)
            make.height.equalTo(20)
            make.bottom.equalTo(-kMargin)
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
    }
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "06-22 13:00"
        
        return lab
    }()
    /// 置顶
    lazy var topImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_istop"))
    /// 图标上半部分的时间线
    lazy var topLineView: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 圆点
    lazy var dotView: UIView = {
        let view = UIView()
        view.backgroundColor = kOrangeFontColor
        view.cornerRadius = 4
        
        return view
    }()
    /// 竖线
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    lazy var bgView: UIView = {
        let view = UIView()
        view.cornerRadius = 4
        view.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 1
        view.layer.shadowColor = UIColor.UIColorFromRGB(valueRGB: 0xc5c9e5).cgColor
        // true的情况不出阴影效果
        view.layer.masksToBounds = false
        view.backgroundColor = kBackgroundColor
        view.isUserInteractionEnabled = true
        
        return view
    }()
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k14Font
        lab.numberOfLines = 0
        lab.text = "5个瑜伽动作，每天十几分钟，告别大粗腿，以前…5个瑜伽动作，每天十几分钟，告别大粗腿，以前…5个瑜伽动作，每天十几分钟，告别大粗腿。"
        
        return lab
    }()
    /// 向下箭头
    lazy var downImgView : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_down_arrow"), for: .normal)
        return btn
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
}
