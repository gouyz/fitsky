//
//  FSVenueConfirmVC.swift
//  fitsky
//  场馆认证
//  Created by gouyz on 2019/10/29.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSVenueConfirmVC: GYZWhiteNavBaseVC {
    
    var venueTypeList:[FSCompainCategoryModel] = [FSCompainCategoryModel]()
    /// 类型id
    var selectTypeId: String = ""
    var typeNameArr:[String] = [String]()
    
    /// 地点
    var currAddress: AMapPOI?
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
    
    /// 选择门店照
    var selectRoomPhotoImg: UIImage?
    /// 选择门店照url
    var selectRoomPhotoImgUrl: String = ""
    /// 选择店内照
    var selectRoomLinePhotoImg: UIImage?
    /// 选择店内照url
    var selectRoomLinePhotoImgUrl: String = ""
    /// 选择手持身份证
    var selectyyzzPhotoImg: UIImage?
    /// 选择手持身份证
    var selectyyzzPhotoImgUrl: String = ""
    let ruleContent: String = "阅读并确定《场馆认证须知》"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "场馆认证"
        self.view.backgroundColor = kWhiteColor
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.titleLabel?.font = k15Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        ruleLab.yb_addAttributeTapAction(with: ["《场馆认证须知》"]) {[unowned self] (label, string, range, index) in
            if index == 0{//《场馆认证须知》
                self.goWebVC(method: "News/Home/storeCertificationInstructions")
            }
        }
        
        requestVenueTypeData()
    }
    ///场馆认证类型
    func requestVenueTypeData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Apply/storeApplyInit", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["store_type"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSCompainCategoryModel.init(dict: itemInfo)
                    
                    weakSelf?.typeNameArr.append(model.name!)
                    weakSelf?.venueTypeList.append(model)
                }
                if weakSelf?.venueTypeList.count > 0 {
                    weakSelf?.areaView.textFiled.text = weakSelf?.typeNameArr[0]
                    weakSelf?.selectTypeId = (weakSelf?.venueTypeList[0].id)!
                }
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func setUpUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(roomDesLab)
        contentView.addSubview(roomPhotoView)
        contentView.addSubview(desLab1)
        contentView.addSubview(lineView0)
        contentView.addSubview(roomNameView)
        contentView.addSubview(lineView)
        contentView.addSubview(roomInLineDesLab)
        contentView.addSubview(roomLinePhotoView)
        contentView.addSubview(lineView1)
        contentView.addSubview(addressView)
        contentView.addSubview(mapTagView)
        contentView.addSubview(lineView2)
        contentView.addSubview(areaView)
        contentView.addSubview(rightIconView)
        contentView.addSubview(lineView3)
        contentView.addSubview(yyzzDesLab)
        contentView.addSubview(yyzzPhotoView)
        contentView.addSubview(desLab3)
        contentView.addSubview(lineView4)
        contentView.addSubview(nameView)
        contentView.addSubview(lineView5)
        contentView.addSubview(cardNoView)
        contentView.addSubview(lineView9)
        contentView.addSubview(shouCardDesLab)
        contentView.addSubview(shouCardPhotoView)
        contentView.addSubview(desLab4)
        contentView.addSubview(lineView6)
        contentView.addSubview(cardDesLab)
        contentView.addSubview(cardPhotoView)
        contentView.addSubview(cardFanPhotoView)
        contentView.addSubview(lineView7)
        contentView.addSubview(phoneView)
        contentView.addSubview(lineView8)
        
        contentView.addSubview(checkImgView)
        contentView.addSubview(ruleLab)
        
        
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
        roomDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.height.equalTo(30)
            make.top.equalTo(kMargin)
            make.width.equalTo(130)
        }
        roomPhotoView.snp.makeConstraints { (make) in
            make.left.equalTo(roomDesLab.snp.right).offset(kMargin)
            make.top.equalTo(roomDesLab)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        desLab1.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.left.equalTo(roomPhotoView)
            make.height.equalTo(30)
            make.top.equalTo(roomPhotoView.snp.bottom)
        }
        lineView0.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(desLab1.snp.bottom).offset(kMargin)
            make.height.equalTo(klineDoubleWidth)
        }
        roomNameView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(lineView0.snp.bottom)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView0)
            make.top.equalTo(roomNameView.snp.bottom)
        }
        roomInLineDesLab.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(roomDesLab)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
        }
        roomLinePhotoView.snp.makeConstraints { (make) in
            make.left.equalTo(roomInLineDesLab.snp.right).offset(kMargin)
            make.top.equalTo(roomInLineDesLab)
            make.size.equalTo(roomPhotoView)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(roomLinePhotoView.snp.bottom).offset(kMargin)
        }
        addressView.snp.makeConstraints { (make) in
            make.left.height.equalTo(roomNameView)
            make.right.equalTo(mapTagView.snp.left)
            make.top.equalTo(lineView1.snp.bottom)
        }
        mapTagView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(addressView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(addressView.snp.bottom)
        }
        areaView.snp.makeConstraints { (make) in
            make.left.height.equalTo(roomNameView)
            make.right.equalTo(rightIconView.snp.left)
            make.top.equalTo(lineView2.snp.bottom)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(areaView)
            make.size.equalTo(rightArrowSize)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(areaView.snp.bottom)
        }
        yyzzDesLab.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(roomDesLab)
            make.top.equalTo(lineView3.snp.bottom).offset(kMargin)
        }
        yyzzPhotoView.snp.makeConstraints { (make) in
            make.left.equalTo(yyzzDesLab.snp.right).offset(kMargin)
            make.top.equalTo(yyzzDesLab)
            make.size.equalTo(roomPhotoView)
        }
        desLab3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab1)
            make.top.equalTo(yyzzPhotoView.snp.bottom)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(desLab3.snp.bottom).offset(kMargin)
        }
        nameView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(roomNameView)
            make.top.equalTo(lineView4.snp.bottom)
        }
        lineView5.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(nameView.snp.bottom)
        }
        cardNoView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(roomNameView)
            make.top.equalTo(lineView5.snp.bottom)
        }
        cardNoView.desLab.snp.updateConstraints { (make) in
            make.width.equalTo(120)
        }
        lineView9.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(cardNoView.snp.bottom)
        }
        shouCardDesLab.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(roomDesLab)
            make.top.equalTo(lineView9.snp.bottom).offset(kMargin)
        }
        shouCardPhotoView.snp.makeConstraints { (make) in
            make.left.equalTo(shouCardDesLab.snp.right).offset(kMargin)
            make.top.equalTo(shouCardDesLab)
            make.size.equalTo(roomPhotoView)
        }
        desLab4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab1)
            make.top.equalTo(shouCardPhotoView.snp.bottom)
        }
        lineView6.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(desLab4.snp.bottom).offset(kMargin)
        }
        cardDesLab.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(roomDesLab)
            make.top.equalTo(lineView6.snp.bottom).offset(kMargin)
        }
        cardPhotoView.snp.makeConstraints { (make) in
            make.left.equalTo(cardDesLab.snp.right).offset(kMargin)
            make.top.equalTo(cardDesLab)
            make.size.equalTo(roomPhotoView)
        }
        cardFanPhotoView.snp.makeConstraints { (make) in
            make.size.top.equalTo(cardPhotoView)
            make.left.equalTo(cardPhotoView.snp.right).offset(kMargin)
        }
        lineView7.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(cardPhotoView.snp.bottom).offset(kMargin)
        }
        
        phoneView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameView)
            make.top.equalTo(lineView7.snp.bottom)
        }
        lineView8.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(phoneView.snp.bottom)
        }
        checkImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(ruleLab)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        ruleLab.snp.makeConstraints { (make) in
            make.left.equalTo(checkImgView.snp.right).offset(kMargin)
            make.top.equalTo(lineView8.snp.bottom).offset(15)
            make.right.equalTo(-20)
            make.height.equalTo(30)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
    }
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    
    /// 门店照
    lazy var roomDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 门店照")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        lab.attributedText = strAttr
        
        return lab
    }()
    /// 门店照
    lazy var roomPhotoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_upload_img"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 104
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectPhoto(sender:)))
        
        return imgView
    }()
    ///
    lazy var desLab1 : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "需拍全，包含完整的店牌"
        
        return lab
    }()
    lazy var lineView0: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    
    lazy var roomNameView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "门店名称", placeHolder: "需与门店照牌面一致，若为品牌分店请注明")
        nView.desLab.textColor = kHeightGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.font = k13Font
        nView.desLab.font = k13Font
        
        return nView
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 店内照
    lazy var roomInLineDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 店内照")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        lab.attributedText = strAttr
        
        return lab
    }()
    /// 店内照
    lazy var roomLinePhotoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_upload_img"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 105
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectPhoto(sender:)))
        
        return imgView
    }()
    lazy var lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    lazy var addressView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "", placeHolder: "请选择详细地址")
        nView.desLab.textColor = kHeightGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
//        nView.textFiled.isEnabled = false
        nView.textFiled.font = k13Font
        nView.desLab.font = k13Font
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 门店地址")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        nView.desLab.attributedText = strAttr
        
        return nView
    }()
    /// 地图图标
    lazy var mapTagView : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_square_location"), for: .normal)
        btn.addTarget(self, action: #selector(onClickedSelectAddress), for: .touchUpInside)
        
        return btn
    }()
    lazy var lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 经营范围
    lazy var areaView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "经营范围", placeHolder: "请选择经营范围")
        nView.desLab.textColor = kHeightGaryFontColor
        nView.textFiled.textColor = kBlueFontColor
        nView.textFiled.text = "健身"
        nView.textFiled.font = k13Font
        nView.textFiled.isEnabled = false
        nView.desLab.font = k13Font
        
        nView.addOnClickListener(target: self, action: #selector(onClickedSelectDaRenType))
        
        return nView
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    lazy var lineView3: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 营业执照
    lazy var yyzzDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 营业执照")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        lab.attributedText = strAttr
        
        return lab
    }()
    /// 营业执照
    lazy var yyzzPhotoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_upload_img"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 106
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectPhoto(sender:)))
        
        return imgView
    }()
    ///
    lazy var desLab3 : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "需提供清晰的照片"
        
        return lab
    }()
    lazy var lineView4: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    lazy var nameView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "", placeHolder: "运营者姓名")
        nView.desLab.textColor = kHeightGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.font = k13Font
        nView.desLab.font = k13Font
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 运营者姓名")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        nView.desLab.attributedText = strAttr
        
        return nView
    }()
    lazy var lineView5: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    lazy var cardNoView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "", placeHolder: "运营者身份证号")
        nView.desLab.textColor = kHeightGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.font = k13Font
        nView.desLab.font = k13Font
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 运营者身份证号")
        strAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kRedFontColor, range: NSMakeRange(0, 1))
        nView.desLab.attributedText = strAttr
        
        return nView
    }()
    lazy var lineView9: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    ///
    lazy var cardDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 运营者身份证正反照")
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
    lazy var lineView6: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 手持身份证
    lazy var shouCardDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 运营者手持身份证")
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
    lazy var desLab4 : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "需提供清晰的照片"
        
        return lab
    }()
    lazy var lineView7: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    lazy var phoneView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "联系方式", placeHolder: "输入联系电话，方便我们更好联系你")
        nView.desLab.textColor = kHeightGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.font = k13Font
        nView.desLab.font = k13Font
        
        return nView
    }()
    lazy var lineView8: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    lazy var checkImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_icon_radio_no"))
        imgView.highlightedImage = UIImage.init(named: "app_icon_radio_yes")
        imgView.addOnClickListener(target: self, action: #selector(clickedCheckRule))
        
        return imgView
    }()
    lazy var ruleLab: UILabel = {
        let lab = UILabel()
        let attStr = NSMutableAttributedString.init(string: ruleContent)
        attStr.addAttribute(NSAttributedString.Key.font, value: k15Font, range: NSMakeRange(0, ruleContent.count))
       attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kBlueFontColor, range: NSMakeRange(0, ruleContent.count))
        attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kBlackFontColor, range: NSMakeRange(0, 5))
        
        lab.attributedText = attStr
        /// 点击效果，关闭
        lab.enabledTapEffect = false
        lab.numberOfLines = 0
        
        return lab
    }()
    /// 同意协议按钮
    @objc func clickedCheckRule(){
        checkImgView.isHighlighted = !checkImgView.isHighlighted
    }
    /// webView
    func goWebVC(method: String){
        let vc = JSMWebViewVC()
        vc.method = method
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 提交
    @objc func onClickRightBtn(){
        if !checkImgView.isHighlighted {
            MBProgressHUD.showAutoDismissHUD(message: "请先同意场馆认证须知")
            return
        }
        if (roomNameView.textFiled.text?.isEmpty)!{
            MBProgressHUD.showAutoDismissHUD(message: "请输入门店名称")
            return
        }
        if selectRoomPhotoImgUrl.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请上传门店照")
            return
        }
        if selectRoomLinePhotoImgUrl.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请上传店内照")
            return
        }
        if selectyyzzPhotoImgUrl.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请上传营业执照")
            return
        }
        if (nameView.textFiled.text?.isEmpty)!{
            MBProgressHUD.showAutoDismissHUD(message: "请输入运营者姓名")
            return
        }
        if (cardNoView.textFiled.text?.isEmpty)!{
            MBProgressHUD.showAutoDismissHUD(message: "请输入运营者身份证号")
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
        if currAddress == nil{
            MBProgressHUD.showAutoDismissHUD(message: "请选择门店地址")
            return
        }
        if (addressView.textFiled.text?.isEmpty)!{
            MBProgressHUD.showAutoDismissHUD(message: "请选择门店地址")
            return
        }
        if selectTypeId.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请选择经营范围")
            return
        }
        
        requestConfirm()
    }
    
    /// 选择认证方式
    @objc func onClickedSelectDaRenType(){
        if typeNameArr.count == 0 {
            return
        }
        UsefulPickerView.showSingleColPicker("选择经营范围", data: typeNameArr, defaultSelectedIndex: 0) {[unowned self] (index, value) in
            
            self.areaView.textFiled.text = self.venueTypeList[index].name
            self.selectTypeId = self.venueTypeList[index].id!
        }
    }
    
    //场馆认证
    func requestConfirm(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Apply/storeApplySubmit", parameters: ["store_name":roomNameView.textFiled.text!,"store_logo":selectRoomPhotoImgUrl,"store_inside":selectRoomLinePhotoImgUrl,"identity_card_front":selectCardPhotoImgUrl,"identity_card_backend":selectCardPhotoFanImgUrl,"identity_card_half":selectShouCardPhotoImgUrl,"business_license":selectyyzzPhotoImgUrl,"address":addressView.textFiled.text!,"lng":(currAddress?.location.longitude)!,"lat":(currAddress?.location.latitude)!,"tel":phoneView.textFiled.text ?? "","store_type":selectTypeId,"operate_real_name": nameView.textFiled.text!,"operate_identity_card_number": cardNoView.textFiled.text!],  success: { (response) in
            
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
    
    /// 选择地址
    @objc func onClickedSelectAddress(){
        let vc = FSSelectAddressVC()
        vc.selectPoi = self.currAddress
        vc.resultBlock = {[unowned self] (address) in
            self.currAddress = address
            if  address != nil {
                self.addressView.textFiled.text = address?.name
            }
        }
        let seeNav = GYZBaseNavigationVC(rootViewController:vc)
        self.present(seeNav, animated: true, completion: nil)
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
            }else if tag == 104{// 门店照
                self.selectRoomPhotoImg = image
                self.roomPhotoView.image = image
            }else if tag == 105{// 店内照
                self.selectRoomLinePhotoImg = image
                self.roomLinePhotoView.image = image
            }else if tag == 106{// 营业执照
                self.selectyyzzPhotoImg = image
                self.yyzzPhotoView.image = image
            }
            self.uploadImgFiles(img: image, tag: tag)
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
                }else if tag == 104{// 门店照
                    weakSelf?.selectRoomPhotoImgUrl = urls
                }else if tag == 105{// 店内照
                    weakSelf?.selectRoomLinePhotoImgUrl = urls
                }else if tag == 106{// 营业执照
                    weakSelf?.selectyyzzPhotoImgUrl = urls
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
