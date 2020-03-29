//
//  FSSearchChatRecordVC.swift
//  fitsky
//  查找聊天内容
//  Created by gouyz on 2020/3/29.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let searchChatRecordCell = "searchChatRecordCell"

class FSSearchChatRecordVC: GYZWhiteNavBaseVC {
    
    var targetId: String = ""
    /// 搜索 内容
    var searchContent: String = ""
    
    var conversationType: RCConversationType = .ConversationType_PRIVATE
    var dataList:[FSSearchChatMessageModel] = [FSSearchChatMessageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let rightBtn = UIButton(type: .custom)
//        rightBtn.setTitle("取消", for: .normal)
//        rightBtn.titleLabel?.font = k15Font
//        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
//        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
//        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        navigationItem.titleView = searchBar
        /// 解决iOS11中UISearchBar高度变大
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: kTitleHeight).isActive = true
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    /// 搜索框
    lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        
        search.placeholder = "查找聊天内容"
        search.delegate = self
        //显示输入光标
        search.tintColor = kHeightGaryFontColor
        /// 搜索框背景色
        if #available(iOS 13.0, *){
            search.searchTextField.backgroundColor = kGrayBackGroundColor
        }else{
            if let textfiled = search.subviews.first?.subviews.last as? UITextField {
                textfiled.backgroundColor = kGrayBackGroundColor
            }
        }
        //弹出键盘
        search.becomeFirstResponder()
        
        return search
    }()
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSSearchChatMsgCell.classForCoder(), forCellReuseIdentifier: searchChatRecordCell)
        
        return table
    }()
    /// 取消
    @objc func onClickRightBtn(){
        searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchMessage(time: Int64){
        
        let messageList:[RCMessage] = (RCIMClient.shared()?.searchMessages(conversationType, targetId: targetId, keyword: searchContent, count: 50, startTime: time))!
        if messageList.count > 0 {
            self.hiddenEmptyView()
            for (index,item) in messageList.enumerated() {
                dealMessage(msgModel: item,isRefresh: (index == messageList.count - 1))
            }
        }else{
            self.showEmptyView(content:"暂无消息")
        }
    }
    
    func dealMessage(msgModel:RCMessage,isRefresh:Bool){
        let resultModel: FSSearchChatMessageModel = FSSearchChatMessageModel()
        resultModel.conversationType = msgModel.conversationType
        resultModel.targetId = msgModel.targetId
        resultModel.sentTime = msgModel.sentTime
        
        var content: String = ""
        if msgModel.content.isKind(of: RCRichContentMessage.classForCoder()) {
            let rich :RCRichContentMessage = msgModel.content as! RCRichContentMessage
            content = rich.title
        }else if msgModel.content.isKind(of: RCFileMessage.classForCoder()){
            let file: RCFileMessage = msgModel.content as! RCFileMessage
            content = file.name
        }else{
            content = RCKitUtility.formatMessage(msgModel.content)
        }
        resultModel.otherInformation = content
        if msgModel.conversationType == .ConversationType_PRIVATE {
            getUserInfo(userId: msgModel.targetId, model: resultModel, isRefresh: isRefresh)
        }else if msgModel.conversationType == .ConversationType_GROUP{
            getUserInfo(userId: msgModel.senderUserId, model: resultModel, isRefresh: isRefresh)
        }
    }
    
    /*!
    *获取用户信息
    */
    func getUserInfo(userId: String,model: FSSearchChatMessageModel,isRefresh:Bool) {
        if !GYZTool.checkNetWork() {
            return
        }
        weak var weakSelf = self
        GYZNetWork.requestNetwork("Circle/Circle/getRongyunMemberInfo", parameters: ["member_id":userId],  success: { (response) in
            
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["formdata"].dictionaryObject else { return }
                let dataModel = FSUserInfoModel.init(dict: data)
                model.name = dataModel.nick_name
                model.portraitUri = dataModel.avatar
                weakSelf?.dataList.append(model)
                if isRefresh {
                    weakSelf?.tableView.reloadData()
                }
            }
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    
    /// 聊天
    func goChat(index: Int){
        let vc = FSChatVC()
        vc.targetId = dataList[index].targetId!
        vc.conversationType = dataList[index].conversationType
        vc.userName = dataList[index].name!
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSSearchChatRecordVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: searchChatRecordCell) as! FSSearchChatMsgCell
        
        cell.dataModel = dataList[indexPath.row]
        
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
        
        goChat(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

extension FSSearchChatRecordVC: UISearchBarDelegate {
    ///mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        self.searchContent = searchBar.text ?? ""
        searchMessage(time: 0)
    }
    
}
