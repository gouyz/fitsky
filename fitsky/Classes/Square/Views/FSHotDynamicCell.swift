//
//  FSHotDynamicCell.swift
//  fitsky
//  图片动态详情cell
//  Created by gouyz on 2019/8/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import ZFPlayer

class FSHotDynamicCell: UITableViewCell {
    ///
    var onClickedVideoBlock: ((_ indexPath: IndexPath) -> Void)?
    var currIndexPath: IndexPath?
    /// 填充数据
    var dataModel : FSDynamicDetailModel?{
        didSet{
            if let model = dataModel {
                
                if let infoModel = model.formData{
                    userImgView.kf.setImage(with: URL.init(string: infoModel.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                    /// 会员类型（1-普通 2-达人 3-场馆）
                    vipImgView.isHidden = false
                    if infoModel.member_type == "2"{
                        vipImgView.image = UIImage.init(named: "app_icon_daren")
                    }else if infoModel.member_type == "3"{
                        vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                    }else{
                        vipImgView.isHidden = true
                    }
                    nameLab.text = infoModel.nick_name
                    dateLab.text = infoModel.display_create_time
                    contentLab.text = infoModel.content
                    
                    /// 好友关系（0-未关注 1-已关注 2-相互关注 3-自己）
                    if infoModel.friend_type == "0"{
                        followLab.isHidden = false
                        followLab.text = "关注"
                        followLab.backgroundColor = kOrangeFontColor
                    }else if infoModel.friend_type == "1" || infoModel.friend_type == "2"{
                        followLab.isHidden = false
                        followLab.text = "取消关注"
                        followLab.backgroundColor = kHeightGaryFontColor
                    }else{
                        followLab.isHidden = true
                    }
                    addressLab.text = infoModel.position
                    if infoModel.position!.isEmpty{
                        addressImgView.isHidden = true
                    }else{
                        addressImgView.isHidden = false
                    }
                    
                    if !infoModel.video!.isEmpty {
                        videoImgView.isHidden = false
                        let imgSize = GYZTool.getThumbSize(url: infoModel.video_material_url!, thumbUrl: infoModel.video_thumb_url!)
                        videoImgView.snp.updateConstraints { (make) in
                            if imgSize.width >= imgSize.height{
                                make.height.equalTo(kScreenWidth * imgSize.height / imgSize.width)
                                make.width.equalTo(kScreenWidth - kMargin * 2)
                            }else{
                                make.height.equalTo(imgSize.height)
                                make.width.equalTo(imgSize.width)
                            }
                        }
                        addressLab.snp.remakeConstraints { (make) in
                            make.left.equalTo(addressImgView.snp.right).offset(3)
                            make.right.equalTo(-kMargin)
                            make.top.equalTo(videoImgView.snp.bottom).offset(kMargin)
                            make.height.equalTo(20)
                        }
                        videoImgView.kf.setImage(with: URL.init(string: infoModel.video_thumb_url!), placeholder: UIImage.init(named: "icon_bg_square_default"))
                    }else{
                        videoImgView.isHidden = true
                        videoImgView.snp.updateConstraints { (make) in
                            make.height.equalTo(0)
                        }
                        addressLab.snp.remakeConstraints { (make) in
                            make.left.equalTo(addressImgView.snp.right).offset(3)
                            make.right.equalTo(-kMargin)
                            make.top.equalTo(imgViews.snp.bottom).offset(kMargin)
                            make.height.equalTo(20)
                        }
                    }
                }
                
                if model.materialUrlList.count > 0{
                    imgViews.isHidden = false
                    
                    if model.materialUrlList.count == 1 {
                        let imgItem = model.materialList[0]
                        let imgSize = GYZTool.getThumbSize(url: imgItem.material!, thumbUrl: imgItem.thumb!)
                        imgViews.imgHight = (kScreenWidth - kMargin * 2) * imgSize.height / imgSize.width
                        imgViews.imgWidth = kScreenWidth - kMargin * 2
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
        contentView.addSubview(dateLab)
        contentView.addSubview(followLab)
        contentView.addSubview(contentLab)
        
        contentView.addSubview(imgViews)
        contentView.addSubview(videoImgView)
        videoImgView.addSubview(playBtn)
        contentView.addSubview(addressImgView)
        contentView.addSubview(addressLab)
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
            make.right.equalTo(followLab.snp.left).offset(-kMargin)
            make.height.equalTo(20)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.bottom.equalTo(userImgView)
        }
        followLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 60, height: 24))
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(userImgView.snp.bottom).offset(kMargin)
        }
        videoImgView.snp.makeConstraints { (make) in
            make.left.equalTo(contentLab)
            make.top.equalTo(contentLab.snp.bottom).offset(kMargin)
            make.height.equalTo(kScreenWidth * 200.0 / 375.0)
            make.width.equalTo(kScreenWidth - kMargin * 2)
        }
        playBtn.snp.makeConstraints { (make) in
            make.center.equalTo(videoImgView)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        imgViews.snp.makeConstraints { (make) in
            make.top.equalTo(contentLab.snp.bottom).offset(kMargin)
            make.left.right.equalTo(contentLab)
            make.height.equalTo(0)
        }
        addressImgView.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView)
            make.centerY.equalTo(addressLab)
            make.size.equalTo(CGSize.init(width: 8, height: 14))
        }
        addressLab.snp.makeConstraints { (make) in
            make.left.equalTo(addressImgView.snp.right).offset(3)
            make.right.equalTo(-kMargin)
            make.top.equalTo(imgViews.snp.bottom).offset(kMargin)
            make.height.equalTo(20)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(2)
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
    
    lazy var videoImgView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.tag = 100
        imgView.setImageWithURLString("", placeholder: ZFUtilities.image(with: UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1), size: CGSize.init(width: 1, height: 1)))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 开始
    lazy var playBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_square_play"), for: .normal)
        btn.addTarget(self, action: #selector(onClickedPlay), for: .touchUpInside)

        return btn
    }()
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
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 播放
    @objc func onClickedPlay(){
        if onClickedVideoBlock != nil {
            onClickedVideoBlock!(currIndexPath!)
        }
    }
}
