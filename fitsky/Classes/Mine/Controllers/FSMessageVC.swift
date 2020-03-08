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

class FSMessageVC: GYZWhiteNavBaseVC {
    
    let titleArr:[String] = ["点赞","评论","收藏","通知"]
    let iconNameArr:[String] = ["app_icon_like_message","app_icon_comment_message","app_icon_collect_message","app_icon_message_official"]
    let iconHightNameArr:[String] = ["app_icon_like_message_have","app_icon_comment_message_have","app_icon_collect_message_have","app_icon_message_official_have"]
    
    var dataModel: FSMessageHomeModel?
    var rightManagerTitles: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = clearBtn
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
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
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        
        table.register(FSMessageCell.classForCoder(), forCellReuseIdentifier: messageCell)
        table.register(FSMessageChatCell.classForCoder(), forCellReuseIdentifier: messageChatCell)
        
        return table
    }()
    
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
                weakSelf?.tableView.reloadData()
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
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
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
        let vc = FSIMCircleMangerDetailVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSMessageVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return titleArr.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: messageCell) as! FSMessageCell
            
            cell.tagImgView.image = UIImage.init(named: iconNameArr[indexPath.row])
            cell.tagImgView.highlightedImage = UIImage.init(named: iconHightNameArr[indexPath.row])
            cell.nameLab.text = titleArr[indexPath.row]
            
            if let model = dataModel {
                if indexPath.row == 0 {// 点赞
                    
                    if Int(model.like!) > 0 {
                        cell.numLab.isHidden = false
                        cell.numLab.text = model.like
                        cell.tagImgView.isHighlighted = true
                    }else{
                        cell.numLab.isHidden = true
                        cell.tagImgView.isHighlighted = false
                    }
                    
                }else if indexPath.row == 1 {// 评论
                    
                    if Int(model.comment!) > 0 {
                        cell.numLab.isHidden = false
                        cell.numLab.text = model.comment
                        cell.tagImgView.isHighlighted = true
                    }else{
                        cell.numLab.isHidden = true
                        cell.tagImgView.isHighlighted = false
                    }
                }else if indexPath.row == 2 {// 收藏
                    
                    if Int(model.collect!) > 0 {
                        cell.numLab.isHidden = false
                        cell.numLab.text = model.collect
                        cell.tagImgView.isHighlighted = true
                    }else{
                        cell.numLab.isHidden = true
                        cell.tagImgView.isHighlighted = false
                    }
                }else if indexPath.row == 3{// 通知
                    
                    if Int(model.notice!) > 0 {
                        cell.numLab.isHidden = false
                        cell.numLab.text = model.notice
                        cell.tagImgView.isHighlighted = true
                    }else{
                        cell.numLab.isHidden = true
                        cell.tagImgView.isHighlighted = false
                    }
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: messageChatCell) as! FSMessageChatCell
            
            cell.tagImgView.image = UIImage.init(named: "app_icon_message_subscription")
            cell.nameLab.text = "订阅号"
            
            if let model = dataModel {
                cell.numLab.isHidden = false
                cell.nameLab.text = model.subscriptionData?.title
                cell.timeLab.text = model.subscriptionData?.display_send_time
                cell.contentLab.text = (model.subscriptionData?.store_name)! + "：" + (model.subscriptionData?.title)!
                
                if Int(model.subscription!) > 0 {
                    cell.numLab.isHidden = false
                    cell.numLab.text = model.subscription
                }else{
                    cell.numLab.isHidden = true
                }
            }else{
                cell.numLab.isHidden = true
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {//点赞
                goZanMsgVC(type: "1")
            }else if indexPath.row == 2 {//收藏
                goZanMsgVC(type: "2")
            }else if indexPath.row == 1 {//评论
                let vc = FSMsgConmentVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 3 {//通知
                let vc = FSMsgNoticeVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if indexPath.row == 0 {//订阅号
                let vc = FSSubscriptionVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 64
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return kMargin
        }
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
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
