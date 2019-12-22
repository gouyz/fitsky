//
//  FSSheZhangConfirmVC.swift
//  fitsky
//  社长认证
//  Created by gouyz on 2019/10/29.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSSheZhangConfirmVC: GYZWhiteNavBaseVC {
    
    ///txtView 提示文字
    let placeHolder = "简单的介绍一下自己吧！选填"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "社长认证"
        self.view.backgroundColor = kWhiteColor
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.titleLabel?.font = k15Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
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
        contentView.addSubview(addressView)
        contentView.addSubview(mapTagView)
        contentView.addSubview(lineView4)
        contentView.addSubview(phoneView)
        contentView.addSubview(lineView5)
        contentView.addSubview(bgView)
        bgView.addSubview(desLab2)
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
        addressView.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameView)
            make.top.equalTo(lineView3.snp.bottom)
            make.right.equalTo(mapTagView.snp.left)
        }
        mapTagView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(addressView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(addressView.snp.bottom).offset(kMargin)
        }
        phoneView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameView)
            make.top.equalTo(lineView4.snp.bottom)
        }
        lineView5.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(phoneView.snp.bottom)
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
        desLab2.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab2.snp.right)
            make.top.equalTo(desLab2)
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
    /// 所在小区
    lazy var addressView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "", placeHolder: "请填写所在小区")
        nView.desLab.textColor = kHeightGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.font = k13Font
        let strAttr : NSMutableAttributedString = NSMutableAttributedString(string: "* 所在小区")
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
    lazy var lineView4: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    lazy var phoneView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "联系方式", placeHolder: "输入联系电话，方便我们更好联系你")
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
    lazy var desLab2 : UILabel = {
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
    /// 提交
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
        if currAddress == nil{
            MBProgressHUD.showAutoDismissHUD(message: "请选择所在小区")
            return
        }
        if (addressView.textFiled.text?.isEmpty)!{
            MBProgressHUD.showAutoDismissHUD(message: "请选择所在小区")
            return
        }
        
        requestConfirm()
    }
    
    //社长认证
    func requestConfirm(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Apply/szApplySubmit", parameters: ["real_name":nameView.textFiled.text!,"identity_card_id":cardNumView.textFiled.text!,"identity_card_front":selectCardPhotoImgUrl,"identity_card_backend":selectCardPhotoFanImgUrl,"identity_card_half":selectShouCardPhotoImgUrl,"community":addressView.textFiled.text!,"address":(currAddress?.address)!,"lng":(currAddress?.location.longitude)!,"lat":(currAddress?.location.latitude)!,"tel":phoneView.textFiled.text ?? "","brief":contentTxtView.text ?? ""],  success: { (response) in
            
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
extension FSSheZhangConfirmVC : UITextViewDelegate
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
