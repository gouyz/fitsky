//
//  FSActivityDetailVC.swift
//  fitsky
//  活动详情
//  Created by gouyz on 2019/9/21.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSActivityDetailVC: GYZWhiteNavBaseVC {
    
    var activityId: String = ""
    var dataModel: FSActivityDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "活动详情"
        self.view.backgroundColor = kWhiteColor
//        let rightBtn = UIButton(type: .custom)
//        rightBtn.setTitle("分享", for: .normal)
//        rightBtn.titleLabel?.font = k15Font
//        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
//        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
//        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        requestActivityInfo()
    }
    func setUpUI(){
        view.addSubview(scrollView)
        view.addSubview(applyBtn)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(topImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(dotView1)
        contentView.addSubview(desLab1)
        contentView.addSubview(timeLab1)
        contentView.addSubview(dotView2)
        contentView.addSubview(desLab2)
        contentView.addSubview(timeLab2)
        contentView.addSubview(dotView3)
        contentView.addSubview(desLab3)
        contentView.addSubview(timeLab3)
        contentView.addSubview(contentLab)
        
        applyBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(applyBtn.snp.top)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        topImgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(kScreenWidth * 0.36)
        }
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(topImgView.snp.bottom).offset(5)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        dotView1.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.size.equalTo(CGSize.init(width: 8, height: 8))
            make.centerY.equalTo(desLab1)
        }
        
        desLab1.snp.makeConstraints { (make) in
            make.right.equalTo(nameLab)
            make.left.equalTo(dotView1.snp.right).offset(kMargin)
            make.top.equalTo(nameLab.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
        timeLab1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab1)
            make.top.equalTo(desLab1.snp.bottom)
        }
        dotView2.snp.makeConstraints { (make) in
            make.left.size.equalTo(dotView1)
            make.centerY.equalTo(desLab2)
        }
        desLab2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab1)
            make.top.equalTo(timeLab1.snp.bottom).offset(kMargin)
        }
        timeLab2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(timeLab1)
            make.top.equalTo(desLab2.snp.bottom)
        }
        dotView3.snp.makeConstraints { (make) in
            make.left.size.equalTo(dotView1)
            make.centerY.equalTo(desLab3)
        }
        desLab3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab1)
            make.top.equalTo(timeLab2.snp.bottom).offset(kMargin)
        }
        timeLab3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(timeLab1)
            make.top.equalTo(desLab3.snp.bottom)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(topImgView)
            make.top.equalTo(timeLab3.snp.bottom).offset(kMargin)
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
    /// 图片
    lazy var topImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "常州第六次马拉松比赛"
        
        return lab
    }()
    lazy var dotView1: UIView = {
        let view = UIView()
        view.backgroundColor = kBlueFontColor
        view.cornerRadius = 4
        
        return view
    }()
    ///
    lazy var desLab1 : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "报名时间"
        
        return lab
    }()
    ///
    lazy var timeLab1 : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "07.25  08：00 —08.11  23：59"
        
        return lab
    }()
    lazy var dotView2: UIView = {
        let view = UIView()
        view.backgroundColor = kBlueFontColor
        view.cornerRadius = 4
        
        return view
    }()
    ///
    lazy var desLab2 : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "活动时间"
        
        return lab
    }()
    ///
    lazy var timeLab2 : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "07.25  08：00 —08.11  23：59"
        
        return lab
    }()
    lazy var dotView3: UIView = {
        let view = UIView()
        view.backgroundColor = kBlueFontColor
        view.cornerRadius = 4
        
        return view
    }()
    ///
    lazy var desLab3 : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "参与人数"
        
        return lab
    }()
    ///
    lazy var timeLab3 : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "11238人参与"
        
        return lab
    }()
    /// 活动内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.numberOfLines = 0
        
        return lab
    }()
    /// 马上报名
    lazy var applyBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("马上报名", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.backgroundColor = kBlueFontColor
        
        btn.addTarget(self, action: #selector(clickedApplyBtn), for: .touchUpInside)
        
        return btn
    }()
    
    ///获取活动信息
    func requestActivityInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Store/Activity/info", parameters: ["id":activityId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSActivityDetailModel.init(dict: data)
                
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
            let height = kScreenWidth * CGFloat(GYZTool.getThumbScale(url: (model.formData?.material)!, thumbUrl: (model.formData?.thumb)!))
            topImgView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
                
            }
            
            topImgView.kf.setImage(with: URL.init(string: (model.formData?.thumb)!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
            nameLab.text = model.formData?.name
            timeLab1.text = (model.formData?.display_apply_stime)! + "—" + (model.formData?.display_apply_etime)!
            timeLab2.text = (model.formData?.display_activity_stime)! + "—" + (model.formData?.display_activity_etime)!
            timeLab3.text = "\((model.formData?.apply_count)!)人参与"
            /// lab加载富文本
            let desStr = try? NSAttributedString.init(data: (model.formData?.content)!.data(using: String.Encoding.unicode)!, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            contentLab.attributedText = desStr
            
            applyBtn.setTitle(model.formData?.apply_btn_text, for: .normal)
            if model.formData?.apply_status == "1"{//当apply_status = 1时可以报名
                applyBtn.isUserInteractionEnabled = true
                applyBtn.backgroundColor = kBlueFontColor
            }else{
                applyBtn.isUserInteractionEnabled = false
                applyBtn.backgroundColor = kHeightGaryFontColor
            }
            
        }
    }
  
    /// 马上报名
    @objc func clickedApplyBtn(){
        requestActivityApply()
    }
    
    ///获取活动报名
    func requestActivityApply(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Store/ActivityPublish/apply", parameters: ["id":activityId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.applyBtn.isUserInteractionEnabled = false
                weakSelf?.applyBtn.backgroundColor = kHeightGaryFontColor
                weakSelf?.applyBtn.setTitle("我已报名", for: .normal)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
