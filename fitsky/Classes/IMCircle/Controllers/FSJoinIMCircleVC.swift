//
//  FSJoinIMCircleVC.swift
//  fitsky
//  申请加入社圈
//  Created by gouyz on 2020/3/1.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSJoinIMCircleVC: GYZWhiteNavBaseVC {
    
    var circleId:String = ""
    var dataModel: FSIMCircleInitModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor
        
        setUpUI()
        requestInitInfo()
    }
    
    func setUpUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(categoryLab)
        contentView.addSubview(addressLab)
        contentView.addSubview(lineView)
        contentView.addSubview(desContentLab)
        contentView.addSubview(lineView1)
        contentView.addSubview(desLab)
        contentView.addSubview(admin1ImgView)
        contentView.addSubview(admin2ImgView)
        contentView.addSubview(admin3ImgView)
        contentView.addSubview(applyBtn)
        
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
        headerImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 72, height: 72))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(headerImgView.snp.right).offset(kMargin)
            make.top.equalTo(headerImgView.snp.top).offset(20)
            make.height.equalTo(30)
            make.right.equalTo(-kMargin)
        }
        categoryLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.bottom.equalTo(headerImgView)
        }
        addressLab.snp.makeConstraints { (make) in
            make.left.equalTo(categoryLab.snp.right).offset(kMargin)
            make.top.bottom.equalTo(categoryLab)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(headerImgView.snp.bottom).offset(20)
            make.height.equalTo(klineDoubleWidth)
        }
        desContentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.right.equalTo(-kMargin)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(desContentLab.snp.bottom).offset(kMargin)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(desContentLab)
            make.height.equalTo(kTitleHeight)
            make.top.equalTo(lineView1.snp.bottom)
        }
        admin1ImgView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(desLab.snp.bottom).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        admin2ImgView.snp.makeConstraints { (make) in
            make.top.size.equalTo(admin1ImgView)
            make.left.equalTo(admin1ImgView.snp.right).offset(20)
        }
        admin3ImgView.snp.makeConstraints { (make) in
            make.top.size.equalTo(admin1ImgView)
            make.left.equalTo(admin2ImgView.snp.right).offset(20)
        }
        applyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(admin1ImgView.snp.bottom).offset(20)
            make.right.equalTo(-kMargin)
            make.height.equalTo(40)
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
    
    lazy var headerImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_img_avatar_def"))
        imgView.cornerRadius = 36
        
        return imgView
        
    }()
    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        lab.textColor = kGaryFontColor
        lab.text = "湖塘健身一圈"
        
        return lab
    }()
    ///
    lazy var categoryLab : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 12)
        lab.textColor = kHeightGaryFontColor
        lab.text = "社区"
        
        return lab
    }()
    ///
    lazy var addressLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "江苏常州"
        
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    ///
    lazy var desContentLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kGaryFontColor
        lab.numberOfLines = 0
        lab.text = "简介：为期200天的拉力赛，我们互相加油，大家一起来！"
        
        return lab
    }()
    
    lazy var lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        lab.textColor = kBlackFontColor
        lab.text = "管理员"
        
        return lab
    }()
    lazy var admin1ImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_img_avatar_def"))
        imgView.cornerRadius = 24
        
        return imgView
        
    }()
    lazy var admin2ImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_img_avatar_def"))
        imgView.cornerRadius = 24
        
        return imgView
        
    }()
    lazy var admin3ImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_img_avatar_def"))
        imgView.cornerRadius = 24
        
        return imgView
        
    }()
    
    lazy var applyBtn: UIButton = {
       let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("申请加入", for: .normal)
        rightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        rightBtn.setTitleColor(kWhiteColor, for: .normal)
        rightBtn.backgroundColor = kBlueFontColor
        rightBtn.addTarget(self, action: #selector(onClickApplyBtn), for: .touchUpInside)
        rightBtn.cornerRadius = 20
        
        return rightBtn
    }()
    
    ///信息
    func requestInitInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Circle/Circle/joinInit", parameters: ["id":circleId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSIMCircleInitModel.init(dict: data)
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
            headerImgView.kf.setImage(with: URL.init(string: (model.circleModel?.thumb)!), placeholder: UIImage.init(named: "app_img_avatar_def"))
            nameLab.text = model.circleModel?.name
            categoryLab.text = model.circleModel?.category_id_text
            addressLab.text = (model.circleModel?.province)! + (model.circleModel?.city)!
            desContentLab.text = "简介：" + (model.circleModel?.brief)!
            
            if model.memberList.count == 1 {
                admin1ImgView.kf.setImage(with: URL.init(string: model.memberList[0].avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                admin2ImgView.isHidden = true
                admin3ImgView.isHidden = true
            }else if model.memberList.count == 2{
                admin1ImgView.kf.setImage(with: URL.init(string: model.memberList[0].avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                admin2ImgView.isHidden = false
                admin2ImgView.kf.setImage(with: URL.init(string: model.memberList[1].avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                admin3ImgView.isHidden = true
            }else if model.memberList.count == 3{
                admin1ImgView.kf.setImage(with: URL.init(string: model.memberList[0].avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                admin2ImgView.isHidden = false
                admin2ImgView.kf.setImage(with: URL.init(string: model.memberList[1].avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                admin3ImgView.isHidden = false
                admin3ImgView.kf.setImage(with: URL.init(string: model.memberList[2].avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
            }
        }
    }
    /// 申请
    @objc func onClickApplyBtn(){
        requestApply()
    }
    
//    func goChatVC(){
//        let vc = FSChatVC()
//        vc.targetId = circleId
//        vc.conversationType = .ConversationType_GROUP
//        vc.userName = (dataModel?.circleModel?.name)!
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    func requestApply(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Circle/Circle/join", parameters: ["circle_id":circleId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.clickedBackBtn()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
