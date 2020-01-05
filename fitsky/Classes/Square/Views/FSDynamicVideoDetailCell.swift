//
//  FSDynamicVideoDetailCell.swift
//  fitsky
//  视频动态详情 cell
//  Created by gouyz on 2019/12/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import ZFPlayer

class FSDynamicVideoDetailCell: UITableViewCell {
    
    /// 点击操作
    var onClickedOperatorBlock: ((_ index: Int) -> Void)?
    
    /// 填充数据
    var dataModel : FSDynamicDetailModel?{
        didSet{
            if let model = dataModel {
                
                if let infoModel = model.formData{
                    userImgView.kf.setImage(with: URL.init(string: infoModel.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                    // 会员类型（1-普通 2-达人 3-场馆）
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
                    
                    /// 好友关系（0-未关注 1-已关注 2-相互关注 3-自己）
                    if infoModel.friend_type == "0"{
                        followLab.isHidden = false
                        followLab.text = "关注"
                        followLab.backgroundColor = kOrangeFontColor
                    }
//                    else if infoModel.friend_type == "1" || infoModel.friend_type == "2"{
//                        followLab.isHidden = false
//                        followLab.text = "取消关注"
//                        followLab.backgroundColor = kHeightGaryFontColor
//                    }
                    else{
                        followLab.isHidden = true
                    }
                    addressLab.text = infoModel.position
                    if infoModel.position!.isEmpty{
                        addressImgView.isHidden = true
                    }else{
                        addressImgView.isHidden = false
                    }
                    
                    var zanCount: String = (model.countModel?.like_count)!
                    if zanCount.isEmpty || zanCount == "0"{
                        zanCount = ""
                    }
                    var conmentCount: String = (model.countModel?.comment_count)!
                    if conmentCount.isEmpty || conmentCount == "0"{
                        conmentCount = ""
                    }
                    var collectCount: String = (model.countModel?.collect_count)!
                    if collectCount.isEmpty || collectCount == "0"{
                        collectCount = ""
                    }
                    
                    if model.moreModel?.is_like == "1"{// 已点赞
                        zanBtn.set(image: UIImage.init(named: "icon_zan_selected"), title: zanCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                        zanBtn.setTitleColor(kOrangeFontColor, for: .normal)
                    }else{
                        zanBtn.set(image: UIImage.init(named: "app_icon_d_video_like"), title: zanCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                        zanBtn.setTitleColor(kWhiteColor, for: .normal)
                    }
                    if model.moreModel?.is_collect == "1"{// 已收藏
                        favouriteBtn.set(image: UIImage.init(named: "app_icon_favourite_selected"), title: collectCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                        favouriteBtn.setTitleColor(kOrangeFontColor, for: .normal)
                    }else{
                        favouriteBtn.set(image: UIImage.init(named: "app_icon_d_video_collect"), title: collectCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                        favouriteBtn.setTitleColor(kWhiteColor, for: .normal)
                    }
                    if model.moreModel?.is_comment == "1"{// 已评论
                        conmentBtn.set(image: UIImage.init(named: "app_icon_comment_selected"), title: conmentCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                        conmentBtn.setTitleColor(kOrangeFontColor, for: .normal)
                    }else{
                        conmentBtn.set(image: UIImage.init(named: "app_icon_d_video_comment"), title: conmentCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                        conmentBtn.setTitleColor(kWhiteColor, for: .normal)
                    }
                    
                    if !infoModel.video!.isEmpty {
                        
                        let imgSize = GYZTool.getThumbSize(url: infoModel.video_material_url!, thumbUrl: infoModel.video_thumb_url!)
                        if imgSize.width >= imgSize.height {
                            coverImageView.contentMode = .scaleAspectFit
                            coverImageView.clipsToBounds = false
                        }else{
                            coverImageView.contentMode = .scaleAspectFill
                            coverImageView.clipsToBounds = true
                        }
                        
                        coverImageView.kf.setImage(with: URL.init(string: infoModel.video_thumb_url!), placeholder: UIImage.init(named: "icon_bg_square_default"))
                    }
                }
                
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(userImgView)
        contentView.addSubview(vipImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(dateLab)
        contentView.addSubview(followLab)
        
        contentView.addSubview(bgView)
        bgView.addSubview(desLab)
        
        contentView.addSubview(favouriteBtn)
        contentView.addSubview(conmentBtn)
        contentView.addSubview(zanBtn)
        
        contentView.addSubview(addressImgView)
        contentView.addSubview(addressLab)
        contentView.addSubview(shouqiLab)
        
        contentView.addSubview(contentLab)
        
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(favouriteBtn.snp.left).offset(-15)
            if kStateHeight > 20.0{
                make.bottom.equalTo(-20)
            }else{
                make.bottom.equalTo(-kMargin)
            }
            make.height.equalTo(30)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.right.equalTo(bgView)
        }
        
        favouriteBtn.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(zanBtn)
            make.right.equalTo(conmentBtn.snp.left).offset(-5)
        }
        conmentBtn.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(zanBtn)
            make.right.equalTo(zanBtn.snp.left).offset(-5)
        }
        zanBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(bgView)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        
        addressImgView.snp.makeConstraints { (make) in
            make.left.equalTo(bgView)
            make.centerY.equalTo(addressLab)
            make.size.equalTo(CGSize.init(width: 8, height: 14))
        }
        addressLab.snp.makeConstraints { (make) in
            make.left.equalTo(addressImgView.snp.right).offset(3)
            make.right.equalTo(shouqiLab.snp.left).offset(-kMargin)
            make.bottom.equalTo(bgView.snp.top).offset(-30)
            make.height.equalTo(20)
        }
        shouqiLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(addressLab)
            make.width.equalTo(kTitleHeight)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(bgView)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(addressLab.snp.top).offset(-kMargin)
        }
        userImgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentLab.snp.top).offset(-kMargin)
            make.left.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 14, height: 14))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.right.equalTo(followLab.snp.left).offset(-kMargin)
            make.top.equalTo(userImgView)
            make.height.equalTo(20)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(20)
        }
        followLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(userImgView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 60, height: 24))
        }
        
    }
    ///
    lazy var coverImageView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.setImageWithURLString("", placeholder: ZFUtilities.image(with: UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1), size: CGSize.init(width: 1, height: 1)))
        
        imgView.isUserInteractionEnabled = true
        imgView.tag = 100
        
        return imgView
    }()
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 20
        imgView.tag = 101
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = UIFont.boldSystemFont(ofSize: 13)
        lab.text = "Alison"
        
        return lab
    }()
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k12Font
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
        lab.tag = 102
        lab.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return lab
    }()
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k13Font
        lab.numberOfLines = 0
        lab.text = "我们在运动前，不用补充太多的水分。因为当我们水分补充过多了，随后还进行大量运动的话，就会影响我我们在运动前，不用补充太多的水分。因为当我们水分补充过多了，随后还进行大量运动的话，就会影响我们…"
        
        return lab
    }()
    /// 定位tag
    lazy var addressImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_location_display"))
    /// 地址
    lazy var addressLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k12Font
        lab.text = "星河公寓"
        
        return lab
    }()
    /// 收起
    lazy var shouqiLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k12Font
        lab.textAlignment = .right
        lab.text = "收起"
        lab.tag = 103
        lab.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return lab
    }()
    ///背景view
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = 15
        view.tag = 107
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    ///
    lazy var desLab: UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kGaryFontColor
        lab.text = "写点什么吧..."
        
        return lab
    }()
    /// 收藏
    lazy var favouriteBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.tag = 104
        btn.addTarget(self, action: #selector(onClickedBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    /// 评论
    lazy var conmentBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.tag = 105
        btn.addTarget(self, action: #selector(onClickedBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    /// 点赞
    lazy var zanBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.tag = 106
        btn.addTarget(self, action: #selector(onClickedBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    /// 操作
    @objc func onClickedOperator(sender:UITapGestureRecognizer){
        goOperator(index: (sender.view?.tag)!)
    }
    /// 操作
    @objc func onClickedBtn(sender:UIButton){
        goOperator(index: sender.tag)
    }
    
    func goOperator(index: Int){
        if onClickedOperatorBlock != nil {
            onClickedOperatorBlock!(index)
        }
    }
}
