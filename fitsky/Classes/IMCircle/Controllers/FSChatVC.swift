//
//  FSChatVC.swift
//  fitsky
//  聊天IM
//  Created by iMac on 2020/3/25.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSChatVC: RCConversationViewController {
    /// 社圈 管理员
    var ismanager: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.userName
//        UIApplication.shared.statusBarStyle = .default
        self.enableSaveNewPhotoToLocalSystem = true        
        self.notifyUpdateUnreadMessageCount()
        //开启语音连读功能
        self.enableContinuousReadUnreadVoice = true
        // 移除发送位置
        self.chatSessionInputBarControl.pluginBoardView.removeItem(at: 2)
        self.chatSessionInputBarControl.emojiBoardView.addExtensionEmojiTab(nil)
        
        if self.conversationType == .ConversationType_PRIVATE || self.conversationType == .ConversationType_GROUP {
            setRightNavigationItem()
        }else{
            self.navigationItem.rightBarButtonItem = nil
        }
        if self.conversationType == .ConversationType_GROUP {
            requestCircleData()
        }
    }
    /// 未读消息数
    func getTotalUnreadCount() ->Int{
        let count: Int32 = RCIMClient.shared()?.getUnreadCount([RCConversationType.ConversationType_PRIVATE.rawValue,RCConversationType.ConversationType_GROUP.rawValue,RCConversationType.ConversationType_APPSERVICE.rawValue,RCConversationType.ConversationType_PUBLICSERVICE.rawValue,RCConversationType.ConversationType_SYSTEM.rawValue]) ?? 0
        
        return Int(count)
    }
    func setLeftNavigationItem(){
        let count = getTotalUnreadCount()
        var backString:String = ""
        if count > 0 && count < 1000 {
            backString = "返回(\(count))"
        }else if count > 1000{
            backString = "返回(...)"
        }else{
            backString = "返回"
        }
        let leftBtn = UIButton(type: .custom)
        leftBtn.titleLabel?.font = k15Font
        leftBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        leftBtn.set(image: UIImage.init(named: "icon_back_black"), title: backString, titlePosition: .right, additionalSpacing: 5, state: .normal)
        leftBtn.addTarget(self, action: #selector(leftBarButtonItemPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
    }
    
    func setRightNavigationItem(){
        let leftBtn = UIButton(type: .custom)
        leftBtn.titleLabel?.font = k13Font
        leftBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        leftBtn.setTitle("设置", for: .normal)
        leftBtn.addTarget(self, action: #selector(goSetting), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
    }
    /// 设置
    @objc func goSetting(){
        if conversationType == .ConversationType_PRIVATE {
            goPrivateSetting()
        }else if conversationType == .ConversationType_GROUP{
            if ismanager {
                goManagerDetail()
            }else{
                goCircleDetail()
            }
        }
    }
    // 单聊设置
    func goPrivateSetting(){
        let vc = FSPrivateChatSettingVC()
        vc.targetId = self.targetId
        vc.resultBlock = {[unowned self]() in
            self.conversationDataRepository.removeAllObjects()
            self.conversationMessageCollectionView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    // 管理员详情
    func goManagerDetail(){
        let vc = FSIMCircleMangerDetailVC()
        vc.circleId = self.targetId
        vc.resultBlock = {[unowned self]() in
            self.conversationDataRepository.removeAllObjects()
            self.conversationMessageCollectionView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    // 普通成员详情
    func goCircleDetail(){
        let vc = FSIMCircleDetailVC()
        vc.circleId = self.targetId
        vc.resultBlock = {[unowned self]() in
            self.conversationDataRepository.removeAllObjects()
            self.conversationMessageCollectionView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 返回
    override func leftBarButtonItemPressed(_ sender: Any!) {
        super.leftBarButtonItemPressed(sender)
    }
    /**
    *  更新左上角未读消息数
    */
    override func notifyUpdateUnreadMessageCount() {
        if self.allowsMessageCellSelection {
            super.notifyUpdateUnreadMessageCount()
            return
        }
        
        DispatchQueue.main.async {
            self.setLeftNavigationItem()
        }
    }
    
    ///获取社圈数据
    func requestCircleData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("Circle/Circle/info",parameters: ["id":self.targetId!],  success: { (response) in
            
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                
                guard let data = response["data"].dictionaryObject else { return }
                let model = FSIMCircleDetailModel.init(dict: data)
                if model.myCircleMemberModel?.is_group == "1" || model.myCircleMemberModel?.is_admin == "1"{
                    weakSelf?.ismanager = true
                }
                weakSelf?.title = model.circleModel?.name
            }
            
        }, failture: { (error) in
            GYZLog(error)
            
        })
    }
}
/*!
消息Cell点击的回调
*/
extension FSChatVC:RCMessageCellDelegate{
    /**
    *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
    *
    *  @param imageMessageContent 图片消息内容
    */
    override func presentImagePreviewController(_ model: RCMessageModel!) {
        let previewController = FSChatImageSlideVC.init()
        previewController.messageModel = model
        previewController.navigationItem.title = "图片预览"
        
        let nav = GYZBaseNavigationVC.init(rootViewController: previewController)
        self.present(nav, animated: true, completion: nil)
    }
    
    override func didTapMessageCell(_ model: RCMessageModel!) {
        super.didTapMessageCell(model)
    }
}
