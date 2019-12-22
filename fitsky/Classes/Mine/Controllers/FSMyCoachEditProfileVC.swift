//
//  FSMyCoachEditProfileVC.swift
//  fitsky
//  教练资料编辑
//  Created by gouyz on 2019/11/1.
//  Copyright © 2019 gyz. All rights reserved.
//  8469737 1517 3227982 68586 89829

import UIKit
import MBProgressHUD

class FSMyCoachEditProfileVC: GYZWhiteNavBaseVC {
    
    ///txtView 提示文字
    let placeHolder = "简单的介绍一下自己吧！选填"
    var dataModel: FSVenueCocahDetailModel?
    var coachId: String = ""
    
    /// 职称类型id
    var selectTypeId: String = ""
    
    /// 选择身份证正面
    var selectCardPhotoImg: UIImage?
    /// 选择身份证正面url
    var selectCardPhotoImgUrl: String = ""
    /// 选择身份证反面
    var selectCardPhotoFanImg: UIImage?
    /// 选择身份证反面url
    var selectCardPhotoFanImgUrl: String = ""
    /// 选择手持身份证
    var selectShouCardPhotoImg: UIImage?
    /// 选择手持身份证
    var selectShouCardPhotoImgUrl: String = ""
    
    /// 选择资格证
    var selectWorkPhotoImg: UIImage?
    /// 选择资格证url
    var selectWorkPhotoImgUrl: String = ""
    /// 选择头像
    var selectHeaderImg: UIImage?
    /// 选择头像
    var selectHeaderImgUrl: String = ""
    /// 选择照片
    var selectPhotoImg: UIImage?
    /// 选择照片
    var selectPhotoImgUrl: String = ""
    /// 选择视频
    var selectVideoImg: UIImage?
    /// 选择视频
    var selectVideoImgUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "编辑教练"
        self.view.backgroundColor = kWhiteColor
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.titleLabel?.font = k15Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        
        requestCoachInfo()
    }
    func setUpUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameView)
        contentView.addSubview(lineView)
        contentView.addSubview(cardNumView)
        contentView.addSubview(lineView1)
        contentView.addSubview(cardDesLab)
        contentView.addSubview(cardPhotoView)
        contentView.addSubview(cardFanPhotoView)
        contentView.addSubview(lineView2)
        contentView.addSubview(shouCardDesLab)
        contentView.addSubview(shouCardPhotoView)
        contentView.addSubview(desLab1)
        contentView.addSubview(lineView3)
        contentView.addSubview(zhiChengView)
        contentView.addSubview(lineView4)
        
        contentView.addSubview(zgzDesLab)
        contentView.addSubview(zgzPhotoView)
        contentView.addSubview(desLab2)
        contentView.addSubview(lineView6)
        contentView.addSubview(headerDesLab)
        contentView.addSubview(headerPhotoView)
        contentView.addSubview(desLab3)
        contentView.addSubview(lineView7)
        
        contentView.addSubview(photoDesLab)
        contentView.addSubview(photoView)
        contentView.addSubview(desLab4)
        contentView.addSubview(lineView8)
        
        contentView.addSubview(videoDesLab)
        contentView.addSubview(videoPhotoView)
        contentView.addSubview(desLab6)
        contentView.addSubview(lineView9)
        
        contentView.addSubview(accessView)
        contentView.addSubview(lineView5)
        contentView.addSubview(bgView)
        bgView.addSubview(desLab5)
        bgView.addSubview(contentTxtView)
        
        scrollView.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalTo(view)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        nameView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(nameView.snp.bottom)
            make.height.equalTo(klineDoubleWidth)
        }
        cardNumView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameView)
            make.top.equalTo(lineView.snp.bottom)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(cardNumView.snp.bottom)
        }
        cardDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(lineView1.snp.bottom).offset(kMargin)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        cardPhotoView.snp.makeConstraints { (make) in
            make.left.equalTo(cardDesLab.snp.right).offset(kMargin)
            make.top.equalTo(cardDesLab)
            make.size.equalTo(CGSize.init(width: 100, height: 100))
        }
        cardFanPhotoView.snp.makeConstraints { (make) in
            make.size.top.equalTo(cardPhotoView)
            make.left.equalTo(cardPhotoView.snp.right).offset(15)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(cardPhotoView.snp.bottom).offset(kMargin)
        }
        shouCardDesLab.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(cardDesLab)
            make.top.equalTo(lineView2.snp.bottom).offset(kMargin)
        }
        shouCardPhotoView.snp.makeConstraints { (make) in
            make.left.equalTo(shouCardDesLab.snp.right).offset(kMargin)
            make.top.equalTo(shouCardDesLab)
            make.size.equalTo(cardPhotoView)
        }
        desLab1.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.left.equalTo(shouCardPhotoView)
            make.height.equalTo(30)
            make.top.equalTo(shouCardPhotoView.snp.bottom)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(desLab1.snp.bottom).offset(kMargin)
        }
        zhiChengView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameView)
            make.top.equalTo(lineView3.snp.bottom)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(zhiChengView.snp.bottom).offset(kMargin)
        }
        zgzDesLab.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(cardDesLab)
            make.top.equalTo(lineView4.snp.bottom).offset(kMargin)
        }
        zgzPhotoView.snp.makeConstraints { (make) in
            make.left.equalTo(zgzDesLab.snp.right).offset(kMargin)
            make.top.equalTo(zgzDesLab)
            make.size.equalTo(cardPhotoView)
        }
        desLab2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab1)
            make.top.equalTo(zgzPhotoView.snp.bottom)
        }
        lineView6.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(desLab2.snp.bottom).offset(kMargin)
        }
        headerDesLab.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(cardDesLab)
            make.top.equalTo(lineView6.snp.bottom).offset(kMargin)
        }
        headerPhotoView.snp.makeConstraints { (make) in
            make.left.equalTo(headerDesLab.snp.right).offset(kMargin)
            make.top.equalTo(headerDesLab)
            make.size.equalTo(cardPhotoView)
        }
        desLab3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab1)
            make.top.equalTo(headerPhotoView.snp.bottom)
        }
        lineView7.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(desLab3.snp.bottom).offset(kMargin)
        }
        photoDesLab.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(cardDesLab)
            make.top.equalTo(lineView7.snp.bottom).offset(kMargin)
        }
        photoView.snp.makeConstraints { (make) in
            make.left.equalTo(photoDesLab.snp.right).offset(kMargin)
            make.top.equalTo(photoDesLab)
            make.size.equalTo(cardPhotoView)
        }
        desLab4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab1)
            make.top.equalTo(photoView.snp.bottom)
        }
        lineView8.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(desLab4.snp.bottom).offset(kMargin)
        }
        videoDesLab.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(cardDesLab)
            make.top.equalTo(lineView8.snp.bottom).offset(kMargin)
        }
        videoPhotoView.snp.makeConstraints { (make) in
            make.left.equalTo(videoDesLab.snp.right).offset(kMargin)
            make.top.equalTo(videoDesLab)
            make.size.equalTo(cardPhotoView)
        }
        desLab6.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab1)
            make.top.equalTo(videoPhotoView.snp.bottom)
        }
        lineView9.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(desLab6.snp.bottom).offset(kMargin)
        }
        accessView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameView)
            make.top.equalTo(lineView9.snp.bottom)
        }
        lineView5.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(accessView.snp.bottom)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(100)
            make.top.equalTo(lineView5.snp.bottom).offset(kMargin)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        desLab5.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab5.snp.right)
            make.top.equalTo(desLab5)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
        }
        
    }
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    
    lazy var nameView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "", placeHolder: "需与身份证姓名一致")
        nView.desLab.textColor = kHeightGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.font = k13Font
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 姓名")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        nView.desLab.attributedText = strAttr
        
        return nView
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    lazy var cardNumView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "", placeHolder: "请输入身份证证件号")
        nView.desLab.textColor = kHeightGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.font = k13Font
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 证件号")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        nView.desLab.attributedText = strAttr
        
        return nView
    }()
    lazy var lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    ///
    lazy var cardDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 身份证正反照")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        lab.attributedText = strAttr
        
        return lab
    }()
    /// 身份证正照
    lazy var cardPhotoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_upload_img"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 101
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectPhoto(sender:)))
        
        return imgView
    }()
    /// 身份证反照
    lazy var cardFanPhotoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_upload_img"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 102
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectPhoto(sender:)))
        
        return imgView
    }()
    lazy var lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 手持身份证
    lazy var shouCardDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 手持身份证")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        lab.attributedText = strAttr
        
        return lab
    }()
    /// 手持身份证
    lazy var shouCardPhotoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_upload_img"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 103
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectPhoto(sender:)))
        
        return imgView
    }()
    /// 需提供清晰的照片
    lazy var desLab1 : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "需提供清晰的照片"
        
        return lab
    }()
    lazy var lineView3: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 职称
    lazy var zhiChengView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "", placeHolder: "请选择职称")
        nView.desLab.textColor = kHeightGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.font = k13Font
        nView.textFiled.isEnabled = false
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 职称")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        nView.desLab.attributedText = strAttr
        
        nView.addOnClickListener(target: self, action: #selector(onClickedSelectRatingType))
        
        return nView
    }()
    lazy var lineView4: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 资格证
    lazy var zgzDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 资格证")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        lab.attributedText = strAttr
        
        return lab
    }()
    /// 资格证
    lazy var zgzPhotoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_upload_img"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 104
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectPhoto(sender:)))
        
        return imgView
    }()
    /// 需提供清晰的照片
    lazy var desLab2 : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "需提供清晰的照片"
        
        return lab
    }()
    lazy var lineView6: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 头像
    lazy var headerDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 头像")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        lab.attributedText = strAttr
        
        return lab
    }()
    /// 头像
    lazy var headerPhotoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_upload_img"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 105
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectPhoto(sender:)))
        
        return imgView
    }()
    /// 需提供清晰的照片
    lazy var desLab3 : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "需提供清晰的照片"
        
        return lab
    }()
    lazy var lineView7: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 照片
    lazy var photoDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 照片")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        lab.attributedText = strAttr
        
        return lab
    }()
    /// 照片
    lazy var photoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_upload_img"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        imgView.tag = 106
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectPhoto(sender:)))
        return imgView
    }()
    /// 需提供清晰的照片
    lazy var desLab4 : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "需提供清晰的照片"
        
        return lab
    }()
    lazy var lineView8: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 视频
    lazy var videoDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "视频"
        
        return lab
    }()
    /// 视频
    lazy var videoPhotoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_upload_img"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 107
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectPhoto(sender:)))
        
        return imgView
    }()
    /// 需提供清晰的照片
    lazy var desLab6 : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "需提供清晰的视频"
        
        return lab
    }()
    lazy var lineView9: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    lazy var accessView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "授权主页", placeHolder: "请输入教练个人账户ID")
        nView.desLab.textColor = kHeightGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.font = k13Font
        
        return nView
    }()
    lazy var lineView5: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    
    lazy var bgView: UIView = {
        let bgview = UIView()
        bgview.borderColor = kBlackFontColor
        bgview.borderWidth = klineWidth
        
        return bgview
        
    }()
    ///
    lazy var desLab5 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "自我介绍"
        
        return lab
    }()
    /// 描述
    lazy var contentTxtView: UITextView = {
        
        let txtView = UITextView()
        txtView.font = k13Font
        txtView.textColor = kHeightGaryFontColor
        txtView.text = placeHolder
        
        return txtView
    }()
    
    //教练详情
    func requestCoachInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Admin/StoreCoach/info", parameters: ["id":coachId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSVenueCocahDetailModel.init(dict: data)
                
                weakSelf?.dealData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func dealData(){
        if let model = dataModel {
            nameView.textFiled.text = model.coachData?.name
            cardNumView.textFiled.text = model.coachData?.identity_card_id
            selectCardPhotoImgUrl = (model.coachData?.identity_card_front_thumb_url)!
            cardPhotoView.kf.setImage(with: URL.init(string: selectCardPhotoImgUrl), placeholder: UIImage.init(named: "icon_upload_img"))
            
            selectCardPhotoFanImgUrl = (model.coachData?.identity_card_backend_thumb_url)!
            cardFanPhotoView.kf.setImage(with: URL.init(string: selectCardPhotoFanImgUrl), placeholder: UIImage.init(named: "icon_upload_img"))
            
            selectShouCardPhotoImgUrl = (model.coachData?.identity_card_half_thumb_url)!
            shouCardPhotoView.kf.setImage(with: URL.init(string: selectShouCardPhotoImgUrl), placeholder: UIImage.init(named: "icon_upload_img"))
            
            selectWorkPhotoImgUrl = (model.coachData?.qualification_certificate_thumb_url)!
            zgzPhotoView.kf.setImage(with: URL.init(string: selectWorkPhotoImgUrl), placeholder: UIImage.init(named: "icon_upload_img"))
            
            selectHeaderImgUrl = (model.coachData?.material_url)!
            headerPhotoView.kf.setImage(with: URL.init(string: selectHeaderImgUrl), placeholder: UIImage.init(named: "icon_upload_img"))
            
            selectPhotoImgUrl = (model.coachData?.photo_thumb_url)!
            photoView.kf.setImage(with: URL.init(string: selectPhotoImgUrl), placeholder: UIImage.init(named: "icon_upload_img"))
            
            selectVideoImgUrl = (model.coachData?.video_url)!
            videoPhotoView.kf.setImage(with: URL.init(string: selectVideoImgUrl), placeholder: UIImage.init(named: "icon_upload_img"))
            
            zhiChengView.textFiled.text = model.coachData?.coach_rank_text
            selectTypeId = (model.coachData?.coach_rank)!
            
            accessView.textFiled.text = model.coachData?.unique_id
            contentTxtView.text = model.coachData?.self_introduction
        }
    }
    /// 完成
    @objc func onClickRightBtn(){
        if (nameView.textFiled.text?.isEmpty)!{
            MBProgressHUD.showAutoDismissHUD(message: "请输入姓名")
            return
        }
        if (cardNumView.textFiled.text?.isEmpty)!{
            MBProgressHUD.showAutoDismissHUD(message: "请输入身份证号码")
            return
        }
        if selectCardPhotoImgUrl.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请上传身份证正面照")
            return
        }
        if selectCardPhotoFanImgUrl.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请上传身份证反面")
            return
        }
        if selectShouCardPhotoImgUrl.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请上传手持身份证")
            return
        }
        if selectWorkPhotoImgUrl.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请上传资格证")
            return
        }
        if selectTypeId.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请选择职称")
            return
        }
        if selectHeaderImgUrl.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请上传头像")
            return
        }
        if selectPhotoImgUrl.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请上传照片")
            return
        }
        
        requestModifyProfile()
    }
    
    //编辑资料
    func requestModifyProfile(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Admin/StoreCoach/edit", parameters: ["id":dataModel?.coachData?.id ?? "","name":nameView.textFiled.text!,"material":selectHeaderImgUrl,"identity_card_id":cardNumView.textFiled.text!,"photo":selectPhotoImgUrl,"identity_card_front":selectCardPhotoImgUrl,"video":selectVideoImgUrl,"identity_card_backend":selectCardPhotoFanImgUrl,"identity_card_half":selectShouCardPhotoImgUrl,"qualification_certificate":selectWorkPhotoImgUrl,"unique_id":accessView.textFiled.text ?? "","coach_rank":selectTypeId,"self_introduction": contentTxtView.text ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                _ = weakSelf?.navigationController?.popToRootViewController(animated: true)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 选择职称
    @objc func onClickedSelectRatingType(){
        if dataModel == nil || dataModel?.coachRankList.count == 0 {
            return
        }
        UsefulPickerView.showSingleColPicker("选择职称", data: dataModel!.coachRankNameList, defaultSelectedIndex: 0) {[unowned self] (index, value) in
            
            self.zhiChengView.textFiled.text = value
            self.selectTypeId = (self.dataModel?.coachRankList[index].value)!
        }
    }
    @objc func onClickedSelectPhoto(sender:UITapGestureRecognizer){
        let tag = sender.view?.tag
        selectPhotoImg(tag: tag!)
    }
    
    /// 选择图片
    func selectPhotoImg(tag: Int){
        
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: true, finished: { [unowned self] (image) in
            
            if tag == 101{// 身份证正面
                self.selectCardPhotoImg = image
                self.cardPhotoView.image = image
            }else if tag == 102{// 身份证反面
                self.selectCardPhotoFanImg = image
                self.cardFanPhotoView.image = image
            }else if tag == 103{// 手持身份证
                self.selectShouCardPhotoImg = image
                self.shouCardPhotoView.image = image
            }else if tag == 104{// 资格证
                self.selectWorkPhotoImg = image
                self.zgzPhotoView.image = image
            }else if tag == 105{// 头像
                self.selectHeaderImg = image
                self.headerPhotoView.image = image
            }else if tag == 106{// 照片
                self.selectPhotoImg = image
                self.photoView.image = image
            }else if tag == 107{// 视频
                self.selectVideoImg = image
                self.videoPhotoView.image = image
            }
            if tag != 107{
                self.uploadImgFiles(img: image, tag: tag)
            }
        })
    }
    /// 上传图片
    ///
    /// - Parameter params: 参数
    func uploadImgFiles(img: UIImage,tag: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        //        createHUD(message: "加载中...")
        weak var weakSelf = self
        
        var imgsParam: [ImageFileUploadParam] = [ImageFileUploadParam]()
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "files[]"
        imgParam.fileName = "dynamic0.jpg"
        imgParam.mimeType = "image/jpg"
        imgParam.data = UIImage.jpegData(img)(compressionQuality: 0.5)!
        
        imgsParam.append(imgParam)
        
        GYZNetWork.uploadImageRequest("Dynamic/Publish/addMaterial", parameters: nil, uploadParam: imgsParam, success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["files"].array else { return }
                var urls: String = ""
                for item in data{
                    urls += item["material"].stringValue + ","
                }
                if urls.count > 0{
                    urls = urls.subString(start: 0, length: urls.count - 1)
                }
                if tag == 101{// 身份证正面
                    weakSelf?.selectCardPhotoImgUrl = urls
                }else if tag == 102{// 身份证反面
                    weakSelf?.selectCardPhotoFanImgUrl = urls
                }else if tag == 103{// 手持身份证
                    weakSelf?.selectShouCardPhotoImgUrl = urls
                }else if tag == 104{// 资格证
                    weakSelf?.selectWorkPhotoImgUrl = urls
                }else if tag == 105{// 头像
                    weakSelf?.selectHeaderImgUrl = urls
                }else if tag == 106{// 照片
                    weakSelf?.selectPhotoImgUrl = urls
                }
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSMyCoachEditProfileVC : UITextViewDelegate
{
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == placeHolder {
            textView.text = ""
            textView.textColor = kGaryFontColor
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = kHeightGaryFontColor
        }
    }
    //    func textViewDidChange(_ textView: UITextView) {
    //
    //        if textView.text.count > contentMaxCount - 20 {
    //
    //            //获得已输出字数与正输入字母数
    //            let selectRange = textView.markedTextRange
    //
    //            //获取高亮部分 － 如果有联想词则解包成功
    //            if let selectRange =   selectRange {
    //                let position =  textView.position(from: (selectRange.start), offset: 0)
    //                if (position != nil) {
    //                    return
    //                }
    //            }
    //
    //            let textContent = textView.text
    //            let textNum = textContent?.count
    //
    //            //截取500个字
    //            if textNum! > contentMaxCount {
    //                //                let index = textContent?.index((textContent?.startIndex)!, offsetBy: contentMaxCount)
    //                let str = textContent?.subString(start: 0, length: contentMaxCount)
    //                textView.text = str
    //            }
    //        }
    //
    //        self.fontCountLab.text =  "\(textView.text.count)/\(contentMaxCount)"
    //    }
}
