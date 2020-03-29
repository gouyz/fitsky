//
//  FSMessageVC.swift
//  fitsky
//  消息
//  Created by gouyz on 2019/12/2.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let messageCell = "messageCell"
private let messageChatCell = "messageChatCell"

private let msgCustomPopupMenuCell = "msgCustomPopupMenuCell"

class FSMessageVC: RCConversationListViewController {
    
    var hud : MBProgressHUD?
    
    let titleArr:[String] = ["点赞","评论","收藏","通知"]
    let iconNameArr:[String] = ["app_icon_like_message","app_icon_comment_message","app_icon_collect_message","app_icon_message_official"]
    let iconHightNameArr:[String] = ["app_icon_like_message_have","app_icon_comment_message_have","app_icon_collect_message_have","app_icon_message_official_have"]
    
    var dataModel: FSMessageHomeModel?
    var rightManagerTitles: [String] = [String]()
    /// 会话列表
    var conversationList:[RCConversation] = [RCConversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = clearBtn
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        // 添加返回按钮,不被系统默认渲染,显示图像原始颜色
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back_black")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedBackBtn))
        
        self.view.backgroundColor = kBackgroundColor
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue,RCConversationType.ConversationType_GROUP.rawValue,RCConversationType.ConversationType_APPSERVICE.rawValue,RCConversationType.ConversationType_PUBLICSERVICE.rawValue,RCConversationType.ConversationType_SYSTEM.rawValue])
        
        //设置tableView样式
        self.conversationListTableView.separatorColor = kGrayLineColor
        self.conversationListTableView.tableFooterView = UIView()
        self.conversationListTableView.tableHeaderView = headerView
        // 设置在NavigatorBar中显示连接中的提示
        self.showConnectingStatusOnNavigatorBar = true
        self.emptyConversationView = UIView()
        
        headerView.didSelectItemBlock = {[unowned self] (index) in
            self.goOperator(index: index)
        }
        
    }
    /// 清扫消息
    lazy var clearBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kTitleHeight)
        btn.titleLabel?.font = k18Font
        btn.setTitleColor(kGaryFontColor, for: .normal)
        btn.set(image: UIImage.init(named: "app_btn_clear_message"), title: "消息", titlePosition: .left, additionalSpacing: kMargin, state: .normal)
        btn.addTarget(self, action: #selector(onClickedClearMsg), for: .touchUpInside)
        return btn
    }()
    ///
    lazy var rightBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_btn_circle"), for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        btn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        
        return btn
    }()
    lazy var headerView:FSMessageHeaderView = FSMessageHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 300))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestMessageInfo()
    }
    // 清消息
    @objc func onClickedClearMsg(){
        if dataModel != nil {
            requestClearMsg()
        }
        
    }
    /// 返回
    @objc func clickedBackBtn() {
        _ = navigationController?.popViewController(animated: true)
    }
    /// 创建HUD
    func createHUD(message: String){
        if hud != nil {
            hud?.hide(animated: true)
            hud = nil
        }
        
        hud = MBProgressHUD.showHUD(message: message,toView: view)
    }
    ///
    func goOperator(index: Int){
        if index == 110 {//点赞
            goZanMsgVC(type: "1")
        }else if index == 112 {//收藏
            goZanMsgVC(type: "2")
        }else if index == 111 {//评论
            let vc = FSMsgConmentVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if index == 113 {//通知
            let vc = FSMsgNoticeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if index == 114 {//订阅号
            let vc = FSSubscriptionVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    //清消息
    func requestClearMsg(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Message/Message/clear", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                weakSelf?.dataModel?.collect = data["collect"].stringValue
                weakSelf?.dataModel?.like = data["like"].stringValue
                weakSelf?.dataModel?.comment = data["comment"].stringValue
                weakSelf?.dataModel?.notice = data["notice"].stringValue
                weakSelf?.dataModel?.subscription = data["subscription"].stringValue
                weakSelf?.conversationListTableView.reloadData()
                MBProgressHUD.showAutoDismissHUD(message: "清扫成功")
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    //消息
    func requestMessageInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Message/Message/home", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSMessageHomeModel.init(dict: data)
                weakSelf?.initHeaderViewData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func initHeaderViewData(){
        headerView.dingYueView.numLab.isHidden = true
        if let model = dataModel {
            // 点赞
            headerView.zanView.tagImgView.image = UIImage.init(named: iconNameArr[0])
            headerView.zanView.tagImgView.highlightedImage = UIImage.init(named: iconHightNameArr[0])
            headerView.zanView.nameLab.text = titleArr[0]
            if Int(model.like!) > 0 {
                headerView.zanView.numLab.isHidden = false
                headerView.zanView.numLab.text = model.like
                headerView.zanView.tagImgView.isHighlighted = true
            }else{
                headerView.zanView.numLab.isHidden = true
                headerView.zanView.tagImgView.isHighlighted = false
            }
            
            /// 评论
            headerView.conmentView.tagImgView.image = UIImage.init(named: iconNameArr[1])
            headerView.conmentView.tagImgView.highlightedImage = UIImage.init(named: iconHightNameArr[1])
            headerView.conmentView.nameLab.text = titleArr[1]
            if Int(model.comment!) > 0 {
                headerView.conmentView.numLab.isHidden = false
                headerView.conmentView.numLab.text = model.comment
                headerView.conmentView.tagImgView.isHighlighted = true
            }else{
                headerView.conmentView.numLab.isHidden = true
                headerView.conmentView.tagImgView.isHighlighted = false
            }
            
            /// 收藏
            headerView.favouriteView.tagImgView.image = UIImage.init(named: iconNameArr[2])
            headerView.favouriteView.tagImgView.highlightedImage = UIImage.init(named: iconHightNameArr[2])
            headerView.favouriteView.nameLab.text = titleArr[2]
            if Int(model.collect!) > 0 {
                headerView.favouriteView.numLab.isHidden = false
                headerView.favouriteView.numLab.text = model.collect
                headerView.favouriteView.tagImgView.isHighlighted = true
            }else{
                headerView.favouriteView.numLab.isHidden = true
                headerView.favouriteView.tagImgView.isHighlighted = false
            }
            
            /// 通知
            headerView.noticeView.tagImgView.image = UIImage.init(named: iconNameArr[3])
            headerView.noticeView.tagImgView.highlightedImage = UIImage.init(named: iconHightNameArr[3])
            headerView.noticeView.nameLab.text = titleArr[3]
            if Int(model.notice!) > 0 {
                headerView.noticeView.numLab.isHidden = false
                headerView.noticeView.numLab.text = model.notice
                headerView.noticeView.tagImgView.isHighlighted = true
            }else{
                headerView.noticeView.numLab.isHidden = true
                headerView.noticeView.tagImgView.isHighlighted = false
            }
            
            headerView.dingYueView.tagImgView.image = UIImage.init(named: "app_icon_message_subscription")
            headerView.dingYueView.nameLab.text = "订阅号"
            headerView.dingYueView.numLab.isHidden = false
            headerView.dingYueView.nameLab.text = model.subscriptionData?.title
            headerView.dingYueView.timeLab.text = model.subscriptionData?.display_send_time
            headerView.dingYueView.contentLab.text = (model.subscriptionData?.store_name)! + "：" + (model.subscriptionData?.title)!

            if Int(model.subscription!) > 0 {
                headerView.dingYueView.numLab.isHidden = false
                headerView.dingYueView.numLab.text = model.subscription
            }else{
                headerView.dingYueView.numLab.isHidden = true
            }
        }
    }
    
    func goZanMsgVC(type:String){
        let vc = FSMsgZanVC()
        vc.type = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 右侧按钮
    @objc func onClickRightBtn(){
        rightManagerTitles.removeAll()
        rightManagerTitles.append("发现社圈")
        rightManagerTitles.append("创立社圈")
        rightManagerTitles.append("扫一扫")
        YBPopupMenu.showRely(on: rightBtn, titles: rightManagerTitles, icons: nil, menuWidth: 170) { [weak self](popupMenu) in
            popupMenu?.delegate = self
            popupMenu?.isShadowShowing = false
            popupMenu?.textColor = kGaryFontColor
            popupMenu?.tableView.register(GYZLabelCenterCell.classForCoder(), forCellReuseIdentifier: msgCustomPopupMenuCell)
        }
    }
    /// 发现社圈
    func goFindCircleVC(){
        let vc = FSFindCircleVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 创建社圈
    func goCreateCircleVC(){
        let vc = FSCreateIMCircleVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 扫一扫
    func goScanVC(){
        let vc = FSIMScanQRCodeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 聊天页面
    func pushChatVC(model: RCConversationModel){
        let vc = FSChatVC()
        vc.targetId = model.targetId
        vc.conversationType = model.conversationType
        vc.userName = model.conversationTitle
        vc.title = model.conversationTitle
        if model.conversationModelType == .CONVERSATION_MODEL_TYPE_NORMAL {
            vc.unReadMessage = model.unreadMessageCount
            vc.enableNewComingMessageIcon = true
            vc.enableUnreadMessageIcon = true
            if model.conversationType == .ConversationType_SYSTEM {
                vc.userName = "系统消息"
                vc.title = "系统消息"
            }else if model.conversationType == .ConversationType_PRIVATE{
                vc.displayUserNameInCell = false
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
    *  点击进入会话页面
    *
    *  @param conversationModelType 会话类型
    *  @param model                 会话数据
    *  @param indexPath             indexPath description
    */
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        if model.conversationModelType == .CONVERSATION_MODEL_TYPE_NORMAL || model.conversationModelType == .CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE {
            pushChatVC(model: model)
        }
    }
    //左滑删除
    override func rcConversationListTableView(_ tableView: UITableView!, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath!) {
        let model: RCConversationModel = self.conversationListDataSource[indexPath.row] as! RCConversationModel
        RCIMClient.shared()?.remove(.ConversationType_SYSTEM, targetId: model.targetId)
        self.conversationListDataSource.removeObject(at: indexPath.row)
        conversationListTableView.reloadData()
    }
}
extension FSMessageVC: YBPopupMenuDelegate{
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        if index == 0 { /// 发现社圈
            goFindCircleVC()
        }else if index == 1 { /// 创建社圈
            goCreateCircleVC()
        }else if index == 2 { /// 扫一扫
            goScanVC()
        }
        
    }
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, cellForRowAt index: Int) -> UITableViewCell! {
        
        let cell = ybPopupMenu.tableView.dequeueReusableCell(withIdentifier: msgCustomPopupMenuCell) as! GYZLabelCenterCell
        
        cell.nameLab.text = rightManagerTitles[index]
        cell.nameLab.textColor = kGaryFontColor
        
        cell.selectionStyle = .none
        return cell
    }
    
}
