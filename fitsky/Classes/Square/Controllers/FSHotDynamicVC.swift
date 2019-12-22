//
//  FSHotDynamicVC.swift
//  fitsky
//  热门图片动态详情
//  Created by gouyz on 2019/8/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SKPhotoBrowser
import ZFPlayer

private let hotDynamicCell = "hotDynamicCell"
private let hotDynamicConmentCell = "hotDynamicConmentCell"
private let hotDynamicConmentHeader = "hotDynamicConmentHeader"
private let hotDynamicConmentFooter = "hotDynamicConmentFooter"
private let hotDynamicEmptyFooter = "hotDynamicEmptyFooter"

class FSHotDynamicVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ isRefesh: Bool, _ dynamicId: String) -> Void)?
    var isModify:Bool = false
    
    var dynamicId: String = ""
    var dataModel: FSDynamicDetailModel?
    /// 区分评论或回复，true评论，false回复
    var isReplyOrConment: Bool = true
    /// 要回复的评论索引
    var conmentIndex: Int = -1
    
    var player:ZFPlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 1
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "app_icon_more_gray")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedRightBtn))
        
        navBarView.addSubview(userImgView)
        navBarView.addSubview(vipImgView)
        navBarView.addSubview(nameLab)
        
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(navBarView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 32, height: 32))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 12, height: 12))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.centerY.equalTo(userImgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        
        self.navigationItem.titleView = navBarView
        navBarView.isHidden = true
        //        navBarView.alpha = 0
        
        view.addSubview(sendConmentView)
        sendConmentView.isHidden = true
        sendConmentView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(kTabBarHeight)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-kTabBarHeight)
            make.left.right.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        
        // 监听键盘隐藏通知
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
        
        bottomView.onClickedOperatorBlock = {[weak self] (index) in
            
            if index == 101 { // 评论
                self?.isReplyOrConment = true
                self?.showConment()
            }else if index == 103 { // 点赞
                self?.requestZan(id: (self?.dynamicId)!, type: (self?.dataModel?.formData!.more_type)!)
            }else if index == 102 { // 收藏
                self?.requestFavourite()
            }
        }
        sendConmentView.sendBtn.addTarget(self, action: #selector(onClickedSend), for: .touchUpInside)
        
        showVideo()
        requestDynamicDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.player?.isViewControllerDisappear = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        self.player?.isViewControllerDisappear = true
    }
    lazy var controlView: ZFPlayerControlView = {
        let playerView = ZFPlayerControlView.init()
        playerView.fastViewAnimated = true
        playerView.autoHiddenTimeInterval = 5
        playerView.autoFadeTimeInterval = 0.5
        playerView.prepareShowLoading = true
        playerView.prepareShowControlView = true
        
        return playerView
    }()
    
    func showVideo(){
        
        let playerManager = ZFAVPlayerManager.init()
        /// player的tag值必须在cell里设置
        self.player = ZFPlayerController.init(scrollView: self.tableView, playerManager: playerManager, containerViewTag: 100)
        self.player?.shouldAutoPlay = false
        /// 1.0是完全消失的时候
        self.player?.playerDisapperaPercent = 1.0
        /// 0.0是刚开始显示的时候
        self.player?.playerApperaPercent = 0.0
        /// 移动网络依然自动播放
        //        self.player?.isWWANAutoPlay = true
        /// 设置退到后台继续播放
        self.player?.pauseWhenAppResignActive = false
        self.player?.controlView = self.controlView
        self.player?.orientationWillChange = {[unowned self] (player,isFullScreen) in
            self.setNeedsStatusBarAppearanceUpdate()
            UIViewController.attemptRotationToDeviceOrientation()
            self.tableView.scrollsToTop = !isFullScreen
        }
        self.player?.playerDidToEnd = {[unowned self] (asset) in
            self.player?.stopCurrentPlayingCell()
        }
        
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 100
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSHotDynamicCell.classForCoder(), forCellReuseIdentifier: hotDynamicCell)
        table.register(FSConmentHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: hotDynamicConmentHeader)
        table.register(FSMoreConmentFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: hotDynamicConmentFooter)
        table.register(GYZEmptyFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: hotDynamicEmptyFooter)
        table.register(FSConmentCell.classForCoder(), forCellReuseIdentifier: hotDynamicConmentCell)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.requestDynamicDetail()
        })
        
        return table
    }()
    /// 底部评论view
    lazy var bottomView: FSConmentBottomView = FSConmentBottomView()
    /// 发送评论view
    lazy var sendConmentView: FSConmentSendView = FSConmentSendView()
    
    lazy var navBarView: UIView = {
        let navView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kTitleHeight))
        
        return navView
    }()
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 16
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    ///名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "Alison"
        
        return lab
    }()
    
    override func clickedBackBtn() {
        super.clickedBackBtn()
        if resultBlock != nil {
            resultBlock!(isModify, self.dynamicId)
        }
    }
    /// 播放、暂停
//    @objc func onClickedPlay(){
//        if let model = dataModel {
//            if !(model.formData?.video!.isEmpty)!{
//                self.player?.assetURL = URL.init(string: (model.formData?.video)!)!
//                let imgSize = GYZTool.getThumbSize(url: (model.formData?.video_material_url)!, thumbUrl: (model.formData?.video_thumb_url)!)
//                if imgSize.height > imgSize.width {
//                    self.controlView.showTitle("", coverURLString: model.formData?.thumb, fullScreenMode: .portrait)
//                }else{
//                    self.controlView.showTitle("", coverURLString: model.formData?.thumb, fullScreenMode: .landscape)
//                }
//            }
//        }
//    }
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            GYZTool.endRefresh(scorllView: tableView)
        }
    }
    
    // 键盘隐藏
    @objc func keyboardWillHide(notification: Notification) {
        bottomView.isHidden = false
        sendConmentView.isHidden = true
        self.tableView.snp.updateConstraints { (make) in
            make.bottom.equalTo(-kTabBarHeight)
        }
        //        sendConmentView.contentTxtView.resignFirstResponder()
    }
    // 移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    ///动态详情
    func requestDynamicDetail(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Dynamic/Dynamic/info", parameters: ["id":dynamicId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            weakSelf?.closeRefresh()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSDynamicDetailModel.init(dict: data)
                weakSelf?.dealData()
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            weakSelf?.closeRefresh()
            GYZLog(error)
        })
    }
    
    func dealData(){
        if dataModel != nil {
            if dataModel?.moreModel?.is_like == "1"{
                bottomView.zanImgView.isHighlighted = true
            }else {
                bottomView.zanImgView.isHighlighted = false
            }
            if dataModel?.moreModel?.is_collect == "1"{
                bottomView.favouriteImgView.isHighlighted = true
            }else {
                bottomView.favouriteImgView.isHighlighted = false
            }
            vipImgView.isHidden = false
            if dataModel?.formData?.member_type == "2"{
                vipImgView.image = UIImage.init(named: "app_icon_daren")
            }else if dataModel?.formData?.member_type == "3"{
                vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
            }else{
                vipImgView.isHidden = true
            }
            userImgView.kf.setImage(with: URL.init(string: (dataModel?.formData?.avatar)!), placeholder: UIImage.init(named: "app_img_avatar_def"))
            nameLab.text = dataModel?.formData?.nick_name
        }
    }
    
    /// 显示评论或回复
    func showConment(){
        self.bottomView.isHidden = true
        self.sendConmentView.isHidden = false
        self.tableView.snp.updateConstraints({ (make) in
            make.bottom.equalTo(-kBottomTabbarHeight)
        })
        //弹出键盘
        self.sendConmentView.contentTxtView.becomeFirstResponder()
    }
    // 发送评论或回复
    @objc func onClickedSend(){
        if sendConmentView.contentTxtView.text.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "发送内容不能为空")
            return
        }
        sendConmentView.contentTxtView.resignFirstResponder()
        if isReplyOrConment {//发送评论
            requestSendConment()
        }else{//回复
            requestSendReply()
        }
    }
    
    ///发送评论
    func requestSendConment(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Comment/Publish/add", parameters: ["content_id":dynamicId,"content":sendConmentView.contentTxtView.text!,"type":(dataModel?.formData!.more_type)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.isModify = true
                weakSelf?.sendConmentView.contentTxtView.text = ""
                weakSelf?.requestDynamicDetail()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///发送回复
    func requestSendReply(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Comment/Reply/add", parameters: ["comment_id":(dataModel?.conmentList[conmentIndex].id)!,"content":sendConmentView.contentTxtView.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.sendConmentView.contentTxtView.text = ""
                weakSelf?.dealReplyData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 回复后处理
    func dealReplyData(){
        let count: Int = Int((dataModel?.conmentList[conmentIndex].reply_count)!)! + 1
        dataModel?.conmentList[conmentIndex].reply_count = "\(count)"
        tableView.reloadData()
    }
    
    // 全部评论
    @objc func onClickedAllConment(){
        let vc = FSAllConmentVC()
        vc.contentId = dynamicId
        vc.type = (dataModel?.formData?.more_type)!
        vc.isLike = (dataModel?.moreModel?.is_like)!
        vc.resultBlock = {[weak self] (isRefresh) in
            self?.navBarView.alpha = 0
            if isRefresh {
                self?.requestDynamicDetail()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    // 用户主页
    @objc func onClickedPersonHome(){
        if let model = dataModel {
            if model.formData?.member_type == "3"{ /// 场馆
                let vc = FSVenueHomeVC()
                vc.userId = (dataModel?.formData?.member_id)!
                navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = FSPersonHomeVC()
                vc.userId = (dataModel?.formData?.member_id)!
                vc.userType = (dataModel?.formData?.member_type)!
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    // 点击评论用户头像 用户主页
    @objc func onClickedUserHome(sender:UITapGestureRecognizer){
        let tag = sender.view?.tag
        if let model = dataModel?.conmentList[tag!] {
            if model.member_type == "3"{ /// 场馆
                let vc = FSVenueHomeVC()
                vc.userId = model.member_id!
                navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = FSPersonHomeVC()
                vc.userId = model.member_id!
                vc.userType = model.member_type!
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    // 关注
    @objc func onClickedFollow(){
        requestFollow()
    }
    ///关注（取消关注）
    func requestFollow(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Member/MemberFollow/add", parameters: ["friend_id":(dataModel?.formData?.member_id)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                weakSelf?.dataModel?.formData?.friend_type = data["statue"].stringValue
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 举报
    //    @objc func clickedRightBtn(){
    //        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["举报"])
    //        actionSheet.cancleTextColor = kWhiteColor
    //        actionSheet.cancleTextFont = k15Font
    //        actionSheet.itemTextColor = kWhiteColor
    //        actionSheet.itemTextFont = k15Font
    //        actionSheet.itemBgColor = UIColor.UIColorFromRGB(valueRGB: 0x777777)
    //        actionSheet.didSelectIndex = {[weak self] (index,title) in
    //            if index == 0{//举报
    //                self?.goComplainVC(type: (self?.dataModel?.formData!.more_type)!, contentId: (self?.dynamicId)!)
    //            }
    //        }
    //    }
    /// 更多
    @objc func clickedRightBtn(){
        if let model = dataModel {
            var shardCards = kDynamicSharedCards
            if model.formData?.friend_type == "3" {// 自己
                shardCards = kDynamicSelfSharedCards
            }
            let mmShareSheet = MMShareSheet.init(title: "分享至", cards: shardCards, duration: nil, cancelBtn: kSharedCancleBtn)
            mmShareSheet.callBack = { [unowned self](handler) ->() in
                
                if handler != "cancel" {// 取消
                    if handler == kWXFriendShared || handler == kWXMomentShared{/// 微信分享
                        self.weChatShared(tag: handler)
                    }else if handler == kQQFriendShared {// QQ
                        self.qqShared(tag: handler)
                    }else if handler == kComplainShared {// 举报
                        self.goComplainVC(type: (self.dataModel?.formData!.more_type)!, contentId: self.dynamicId)
                    }else if handler == kPinBiShared {// 屏蔽
                        self.shoePingBiAlert()
                    }else if handler == kDeleteShared {// 删除
                        self.showDeleteAlert()
                    }
                }
            }
            mmShareSheet.present()
        }
    }
    /// 微信分享
    func weChatShared(tag: String){
        //发送给好友还是朋友圈（默认好友）
        var scene = WXSceneSession
        if tag == kWXMomentShared {//朋友圈
            scene = WXSceneTimeline
        }
        
        WXApiManager.shared.sendLinkURL((dataModel?.sharedModel?.link)!, title: (dataModel?.sharedModel?.title)!, description: (dataModel?.sharedModel?.desc)!, thumbImage: (dataModel?.sharedModel?.img_url)!.getImageFromURL()!, scene: scene,sender: self)
    }
    /// qq 分享
    func qqShared(tag: String){
        
        if !GYZTencentShare.shared.isQQInstall() {
            GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "QQ未安装", cancleTitle: nil, viewController: self, buttonTitles: "确定")
            return
        }
        //发送给好友还是QQ空间（默认好友）
        let scene: GYZTencentFlag = .QQ
        //        if tag == kQZoneShared {//QQ空间
        //            scene = .QZone
        //        }
        GYZTencentShare.shared.shareNews(URL.init(string: (dataModel?.sharedModel?.link)!)!, preUrl: URL.init(string: (dataModel?.sharedModel?.img_url)!), preImage: nil, title: (dataModel?.sharedModel?.title)!, description: (dataModel?.sharedModel?.desc)!, flag: scene) { (success, description) in
            
        }
    }
    /// 屏蔽
    func shoePingBiAlert(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确定要屏蔽此人吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (tag) in
            
            if tag != cancelIndex{
                weakSelf?.requestAddBlack()
            }
        }
    }
    ///添加屏蔽
    func requestAddBlack(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/MemberBlack/add", parameters: ["black_id":(dataModel?.formData?.member_id)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.isModify = true
                weakSelf?.clickedBackBtn()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 删除提示
    func showDeleteAlert(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确定要删除此动态吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (tag) in
            
            if tag != cancelIndex{
                weakSelf?.requestDeleteDynamic()
            }
        }
    }
    /// 删除动态
    func requestDeleteDynamic(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Dynamic/Publish/delete", parameters: ["id":(dataModel?.formData?.id)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.isModify = true
                weakSelf?.clickedBackBtn()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    // 查看全部回复
    @objc func onClickedAllReply(sender:UITapGestureRecognizer){
        let tag = sender.view?.tag
        let vc = FSAllReplyMsgVC()
        vc.conmentId = (dataModel?.conmentList[tag!].id)!
        vc.resultBlock = {[weak self] (isRefresh) in
            if isRefresh {
                self?.requestDynamicDetail()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    // 评论点赞
    @objc func onClickedZan(sender:UIButton){
        let tag = sender.tag
        conmentIndex = tag
        requestZan(id: (dataModel?.conmentList[tag].id)!, type: "9")
    }
    ///点赞（取消点赞）
    func requestZan(id: String,type: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberLike/add", parameters: ["content_id":id,"type":type],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                if type == "9"{
                    weakSelf?.dataModel?.conmentList[(weakSelf?.conmentIndex)!].like_count = data["count"].stringValue
                    weakSelf?.dataModel?.conmentList[(weakSelf?.conmentIndex)!].moreModel?.is_like = data["status"].stringValue
                }else{
                    weakSelf?.isModify = true
                    weakSelf?.dataModel?.moreModel?.is_like = data["status"].stringValue
                    weakSelf?.dataModel?.countModel?.like_count = data["count"].stringValue
                    weakSelf?.dealData()
                }
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///收藏（取消收藏）
    func requestFavourite(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberCollect/add", parameters: ["content_id":dynamicId,"type":(dataModel?.formData!.more_type)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.isModify = true
                let data = response["data"]
                weakSelf?.dataModel?.moreModel?.is_collect = data["status"].stringValue
                weakSelf?.dealData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    // 回复/举报
    @objc func onClickedShowConment(sender:UIButton){
        let tag = sender.tag
        self.conmentIndex = tag
        
        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["回复","举报"])
        actionSheet.cancleTextColor = kWhiteColor
        actionSheet.cancleTextFont = k15Font
        actionSheet.itemTextColor = kGaryFontColor
        actionSheet.itemTextFont = k15Font
        actionSheet.didSelectIndex = {[weak self] (index,title) in
            if index == 0 {//回复
                self?.isReplyOrConment = false
                self?.showConment()
            }else if index == 1{//评论举报
                self?.goComplainVC(type: "9", contentId: (self?.dataModel?.conmentList[tag].id)!)
            }
        }
    }
    /// 评论投诉
    func goComplainVC(type: String,contentId: String){
        let vc = FSComplainVC()
        vc.type = type
        vc.contentId = contentId
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 查看大图
    ///
    /// - Parameters:
    ///   - index: 索引
    ///   - urls: 图片路径
    func goBigPhotos(index: Int, urls: [String]){
        let browser = SKPhotoBrowser(photos: GYZTool.createWebPhotos(urls: urls, isShowDel: false, isShowAction: true))
        browser.initializePageIndex(index)
        //        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
    }
    /// 播放视频
    func playVideo(index:IndexPath){
        if let model = dataModel {
            if !(model.formData?.video!.isEmpty)!{
                self.player?.playTheIndexPath(index, scrollToTop: false)
                self.player?.assetURL = URL.init(string: (model.formData?.video_url)!)!
                let imgSize = GYZTool.getThumbSize(url: (model.formData?.video_material_url)!, thumbUrl: (model.formData?.video_thumb_url)!)
                if imgSize.height > imgSize.width {
                    self.controlView.showTitle("", coverURLString: model.formData?.video_thumb_url, fullScreenMode: .portrait)
                }else{
                    self.controlView.showTitle("", coverURLString: model.formData?.video_thumb_url, fullScreenMode: .landscape)
                }
            }
        }
    }
}
extension FSHotDynamicVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataModel != nil {
            if section == 1 {
                return (dataModel?.conmentList.count)!
            }
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: hotDynamicCell) as! FSHotDynamicCell
            
            cell.dataModel = self.dataModel
            cell.imgViews.onClickedImgDetailsBlock = {[unowned self](index,urls) in
                self.goBigPhotos(index: index, urls: self.dataModel!.materialOrgionUrlList)
            }
            cell.currIndexPath = indexPath
            cell.onClickedVideoBlock = {[unowned self] (index) in
                self.playVideo(index: index)
            }
            cell.userImgView.addOnClickListener(target: self, action: #selector(onClickedPersonHome))
            cell.followLab.addOnClickListener(target: self, action: #selector(onClickedFollow))
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: hotDynamicConmentCell) as! FSConmentCell
            cell.dataModel = dataModel?.conmentList[indexPath.row]
            
            cell.replyLab.tag = indexPath.row
            cell.replyLab.addOnClickListener(target: self, action: #selector(onClickedAllReply(sender:)))
            cell.conmentBtn.tag = indexPath.row
            cell.conmentBtn.addTarget(self, action: #selector(onClickedShowConment(sender:)), for: .touchUpInside)
            cell.zanBtn.tag = indexPath.row
            cell.zanBtn.addTarget(self, action: #selector(onClickedZan(sender:)), for: .touchUpInside)
            
            cell.userImgView.tag = indexPath.row
            cell.userImgView.addOnClickListener(target: self, action: #selector(onClickedUserHome(sender:)))
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: hotDynamicConmentHeader) as! FSConmentHeaderView
            
            if dataModel != nil {
                headerView.dataModel = self.dataModel?.countModel
            }
            
            return headerView
        }
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            if dataModel != nil {
                if dataModel?.conmentList.count > 0{
                    let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: hotDynamicConmentFooter) as! FSMoreConmentFooterView
                    footerView.conmentBtn.addTarget(self, action: #selector(onClickedAllConment), for: .touchUpInside)
                    
                    return footerView
                }
            }
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: hotDynamicEmptyFooter) as! GYZEmptyFooterView
            
            return footerView
        }
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return kTitleHeight
        }
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            if dataModel != nil {
                if dataModel?.conmentList.count > 0{
                    return kTitleHeight
                }
            }
            return 120
        }
        return 0.00001
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollView.zf_scrollViewDidScroll()
        
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = kTitleHeight - topLayoutGuide.length
        
        
        //navigationBar alpha
        if contentOffsetY > showNavBarOffsetY  {
            
            //            var navAlpha = (contentOffsetY - showNavBarOffsetY) / 40.0
            //            if navAlpha > 1 {
            //                navAlpha = 1
            //            }
            //            navBarView.alpha = navAlpha
            navBarView.isHidden = false
        }else{
            //            navBarView.alpha = 0
            navBarView.isHidden = true
        }
    }
    
    /// UIScrollViewDelegate 列表播放必须实现
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidEndDecelerating()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.zf_scrollViewDidEndDraggingWillDecelerate(decelerate)
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScrollToTop()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewWillBeginDragging()
    }
}
extension FSHotDynamicVC{
    override var shouldAutorotate: Bool{
        
        return (self.player?.shouldAutorotate)!
    }
    //viewController所支持的全部旋转方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if player != nil && (self.player?.isFullScreen)! && self.player?.orientationObserver.fullScreenMode == .landscape {
            return .landscape
        }
        return .portrait
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if player != nil && self.player!.isFullScreen {
            return .lightContent
        }
        return .default
    }
    override var prefersStatusBarHidden: Bool{
        /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
        return player == nil ? false : (self.player?.isStatusBarHidden)!
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
}
