//
//  FSMyApplyConfirmVC.swift
//  fitsky
//  申请认证
//  Created by gouyz on 2019/10/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSMyApplyConfirmVC: GYZWhiteNavBaseVC {
    
    var dataModel: FSApplyInitModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "申请认证"
        self.view.backgroundColor = kWhiteColor
        
        setUpUI()
        requestApplyInit()
    }
    
    //认证申请主页初始化
    func requestApplyInit(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Apply/init", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["formdata"].dictionaryObject else { return }
                weakSelf?.dataModel = FSApplyInitModel.init(dict: data)
            
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func setUpUI(){
        view.addSubview(darenImgView)
        view.addSubview(shezhangImgView)
        view.addSubview(venueImgView)
        
        darenImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.35)
        }
        shezhangImgView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(darenImgView)
            make.top.equalTo(darenImgView.snp.bottom).offset(kMargin)
        }
        venueImgView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(darenImgView)
            make.top.equalTo(shezhangImgView.snp.bottom).offset(kMargin)
        }
        
    }
    
    /// 达人认证
    lazy var darenImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_btn_apply_expert_entrance"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 101
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    
    /// 社长认证
    lazy var shezhangImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_btn_apply_administrate_entrance"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 102
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    /// 场馆认证
    lazy var venueImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_btn_apply_venue_entrance"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        
        imgView.tag = 103
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    ///
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        if tag == 101 {// 达人认证
            if let model = dataModel{
                if model.is_apply_daren == "1" {
                    goConditionVC(type: "1")
                }else{
                    MBProgressHUD.showAutoDismissHUD(message: model.is_apply_daren_text!)
                }
            }
        }else if tag == 102 {// 社长认证
            if let model = dataModel{
                if model.is_apply_sz == "1" {
                    goConditionVC(type: "2")
                }else{
                    MBProgressHUD.showAutoDismissHUD(message: model.is_apply_sz_text!)
                }
            }
        }else if tag == 103 {/// 场馆认证
            if let model = dataModel{
                if model.is_apply_gym == "1" {
                    goVenueConfirm()
                }else{
                    MBProgressHUD.showAutoDismissHUD(message: model.is_apply_gym_text!)
                }
            }
        }
        
    }
    /// 申请条件
    func goConditionVC(type: String){
        let vc = FSConfirmConditionVC()
        vc.type = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 场馆认证
    func goVenueConfirm(){
        let vc = FSVenueConfirmVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
