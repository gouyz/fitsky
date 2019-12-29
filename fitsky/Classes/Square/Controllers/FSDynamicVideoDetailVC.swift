//
//  FSDynamicVideoDetailVC.swift
//  fitsky
//  视频动态详情
//  Created by gouyz on 2019/12/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import ZFPlayer.ZFAVPlayerManager

private let dynamicVideoDetailCell = "dynamicVideoDetailCell"

class FSDynamicVideoDetailVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ isRefesh: Bool, _ dynamicId: String) -> Void)?
    var isModify:Bool = false
    
    var dynamicId: String = ""
    var dataModel: FSDynamicDetailModel?
    /// 是否展开
    var isShowTotal: Bool = false
    
    var player:ZFPlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "app_icon_more_white")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedRightBtn))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back_white")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedBackBtn))
        
        view.addSubview(sendConmentView)
        sendConmentView.isHidden = true
        sendConmentView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.left.right.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(-kTitleAndStateHeight)
            }else{
                make.top.equalTo(0)
            }
        }
        
        // 监听键盘隐藏通知
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.scrollsToTop = false
        table.showsVerticalScrollIndicator = false
        table.bounces = false
        
        table.rowHeight = kScreenHeight
        // 设置大概高度
//        table.estimatedRowHeight = 100
//        // 设置行高为自动适配
//        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSDynamicVideoDetailCell.classForCoder(), forCellReuseIdentifier: dynamicVideoDetailCell)
        //        weak var weakSelf = self
        //        ///添加下拉刷新
        //        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
        //            weakSelf?.requestDynamicDetail()
        //        })
        
        return table
    }()
    /// 发送评论view
    lazy var sendConmentView: FSConmentSendView = FSConmentSendView()
    
    lazy var controlView: ZFDouYinControlView = {
        let playerView = ZFDouYinControlView.init()
        
        return playerView
    }()
    
    func showVideo(){
        
        let playerManager = ZFAVPlayerManager.init()
        /// player,tag值必须在cell里设置
        self.player = ZFPlayerController.init(scrollView: self.tableView, playerManager: playerManager, containerViewTag: 100)
        self.player?.shouldAutoPlay = false
        /// 1.0是完全消失的时候
        self.player?.playerDisapperaPercent = 1.0
        self.player?.disableGestureTypes = ZFPlayerDisableGestureTypes(rawValue: (ZFPlayerDisableGestureTypes.doubleTap.rawValue | ZFPlayerDisableGestureTypes.pan.rawValue | ZFPlayerDisableGestureTypes.pinch.rawValue))
        self.player?.allowOrentitaionRotation = false
        /// 移动网络依然自动播放
        self.player?.isWWANAutoPlay = true
        /// 设置退到后台继续播放
        self.player?.pauseWhenAppResignActive = false
        self.player?.controlView = self.controlView
        
        self.player?.playerDidToEnd = {[unowned self] (asset) in
            self.player?.currentPlayerManager.replay?()
        }
        //        self.player?.presentationSizeChanged = {[unowned self] (asset,size) in
        //
        //            self.setPlayerScaleModel(size: size)
        //        }
        
    }
    
    func setPlayerScaleModel(size:CGSize){
        //        if size.width > size.height {
        //            player?.currentPlayerManager.scalingMode = ZFPlayerScalingMode.aspectFit
        //        }else{
        //            player?.currentPlayerManager.scalingMode = ZFPlayerScalingMode.aspectFill
        //        }
    }
    override func clickedBackBtn() {
        super.clickedBackBtn()
        if resultBlock != nil {
            resultBlock!(isModify, self.dynamicId)
        }
    }
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            GYZTool.endRefresh(scorllView: tableView)
        }
    }
    /// 指定到某一行播放
    func playTheIndex(index: Int){
        let indexPath = IndexPath.init(row: index, section: 0)
//        self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
//        self.tableView.zf_filterShouldPlayCellWhileScrolled {[unowned self] (indexPath) in
//            self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: false)
//        }
        self.playTheVideoAtIndexPath(indexPath: indexPath, scrollToTop: false)
    }
    /// 播放
    func playTheVideoAtIndexPath(indexPath: IndexPath,scrollToTop: Bool){
        self.player?.playTheIndexPath(indexPath, scrollToTop: scrollToTop)
        self.controlView.resetControlView()
        
        if let model = dataModel {
            if !(model.formData?.video!.isEmpty)!{
                
                let imgSize = GYZTool.getThumbSize(url: (model.formData?.video_material_url)!, thumbUrl: (model.formData?.video_thumb_url)!)
                if imgSize.height > imgSize.width {
                    //                    self.controlView.showTitle("", coverURLString: model.formData?.video_thumb_url, fullScreenMode: .portrait)
                    self.controlView.showCover(withUrl: (model.formData?.video_thumb_url)!, withImageMode: .scaleAspectFill)
                }else{
                    self.controlView.showCover(withUrl: (model.formData?.video_thumb_url)!, withImageMode: .scaleAspectFit)
                }
            }
        }
    }
    // 键盘隐藏
    @objc func keyboardWillHide(notification: Notification) {
        sendConmentView.isHidden = true
        self.tableView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view)
        }
        //        sendConmentView.contentTxtView.resignFirstResponder()
    }
    // 移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    ///动态/作品详情
    func requestDynamicDetail(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Dynamic/Dynamic/info", parameters: ["id":dynamicId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            //            weakSelf?.closeRefresh()
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
            //            weakSelf?.closeRefresh()
            GYZLog(error)
        })
    }
    
    func dealData(){
        if let model = dataModel {
            if !(model.formData?.video!.isEmpty)!{
                self.player?.assetURLs = [URL.init(string: (model.formData?.video_url)!)!]
//                self.player?.assetURL = URL.init(string: (model.formData?.video_url)!)!
                
                playTheIndex(index: 0)
            }
        }
    }
    
    /// 显示评论或回复
    func showConment(){
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
        requestSendConment()
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
                weakSelf?.isModify = true
                let data = response["data"]
                /// 状态（0-取消 1-关注）
                weakSelf?.dataModel?.formData?.friend_type = data["statue"].stringValue
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
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
                weakSelf?.isModify = true
                weakSelf?.dataModel?.moreModel?.is_like = data["status"].stringValue
                weakSelf?.dataModel?.countModel?.like_count = data["count"].stringValue
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
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 评论投诉
    func goComplainVC(type: String,contentId: String){
        let vc = FSComplainVC()
        vc.type = type
        vc.contentId = contentId
        navigationController?.pushViewController(vc, animated: true)
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
    /// 收起、点赞、评论等操作
    func operatorMethod(index: Int){
        switch index {
        case 101:// 用户主页
            goPersonHome()
        case 102:// 关注
            requestFollow()
        case 103:// 收起
            isShowTotal = false
            tableView.reloadData()
        case 104:// 收藏
            requestFavourite()
        case 105:// 评论列表
            goAllConment()
        case 106:// 点赞
            requestZan(id: dynamicId, type: (dataModel?.formData!.more_type)!)
        case 107:// 弹出评论
            showConment()
        default:
            break
        }
    }
    
    // 用户主页
    func goPersonHome(){
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
    /// 评论列表
    func goAllConment(){
        let vc = FSAllConmentVC()
        vc.contentId = dynamicId
        vc.type = (dataModel?.formData?.more_type)!
        vc.isLike = (dataModel?.moreModel?.is_like)!
        vc.resultBlock = {[weak self] (isRefresh) in
            if isRefresh {
                self?.requestDynamicDetail()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSDynamicVideoDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: dynamicVideoDetailCell) as! FSDynamicVideoDetailCell
        cell.dataModel = dataModel
        
        cell.shouqiLab.isHidden = !isShowTotal
        
        if let infoModel = dataModel?.formData {
            if infoModel.topic_id != "0" {
                var content: String = infoModel.content!
                if infoModel.content?.count > 50 && !isShowTotal {
                    content = content.subString(start: 0, length: 50) + "...展开"
                    let attStr = NSMutableAttributedString.init(string: content)
                    attStr.addAttribute(NSAttributedString.Key.font, value: k13Font, range: NSMakeRange(0, content.count))
                    
                    attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeFontColor, range: NSMakeRange(content.count - 2, 2))
                    attStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: NSMakeRange(content.count - 2, 2))
                    
                    cell.contentLab.attributedText = attStr
                    cell.contentLab.yb_addAttributeTapAction(with: ["展开"], delegate: self)
                }else{
                    content += " \(infoModel.topic_id_text!)"
                    let attStr = NSMutableAttributedString.init(string: content)
                    attStr.addAttribute(NSAttributedString.Key.font, value: k13Font, range: NSMakeRange(0, content.count))
                    
                    attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeFontColor, range: NSMakeRange(content.count - infoModel.topic_id_text!.count,infoModel.topic_id_text!.count))
                    attStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: NSMakeRange(content.count - infoModel.topic_id_text!.count ,infoModel.topic_id_text!.count))
                    
                    cell.contentLab.attributedText = attStr
                    cell.contentLab.yb_addAttributeTapAction(with: [infoModel.topic_id_text!], delegate: self)
                }
                
            }else{
                var content: String = infoModel.content!
                if infoModel.content?.count > 50  && !isShowTotal{
                    content = content.subString(start: 0, length: 50) + "...展开"
                    let attStr = NSMutableAttributedString.init(string: content)
                    attStr.addAttribute(NSAttributedString.Key.font, value: k13Font, range: NSMakeRange(0, content.count))
                    
                    attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeFontColor, range: NSMakeRange(content.count - 2, 2))
                    attStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: NSMakeRange(content.count - 2, 2))
                    
                    cell.contentLab.attributedText = attStr
                    cell.contentLab.yb_addAttributeTapAction(with: ["展开"], delegate: self)
                    
                }else{
                    content += ""
                    let attStr = NSMutableAttributedString.init(string: content)
                    attStr.addAttribute(NSAttributedString.Key.font, value: k13Font, range: NSMakeRange(0, content.count))
                    
                    cell.contentLab.attributedText = attStr
                }
                
            }
        }
        
        cell.onClickedOperatorBlock = {[unowned self] (index) in
            self.operatorMethod(index: index)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
}
extension FSDynamicVideoDetailVC{
    override var shouldAutorotate: Bool{
        
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
    override var prefersStatusBarHidden: Bool{
        /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
        return player == nil ? false : (self.player?.isStatusBarHidden)!
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    /// pragma mark - UIScrollViewDelegate  列表播放必须实现
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidEndDecelerating()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.zf_scrollViewDidEndDecelerating()
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScrollToTop()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScroll()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewWillBeginDragging()
    }
}
extension FSDynamicVideoDetailVC: YBAttributeTapActionDelegate{
    func yb_tapAttribute(in label: UILabel!, string: String!, range: NSRange, index: Int) {
        
        if string == "展开" {
            self.isShowTotal = true
            self.tableView.reloadData()
        }else{
            goTopicDetailVC()
        }
        
        
    }
    
    /// 话题详情
    func goTopicDetailVC(){
        let vc = FSTopicDetailVC()
        vc.topicId = (dataModel?.formData?.topic_id)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
