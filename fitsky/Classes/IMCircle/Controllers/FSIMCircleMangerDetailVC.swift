//
//  FSIMCircleMangerDetailVC.swift
//  fitsky
//  社圈 详情
//  Created by gouyz on 2020/3/4.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

private let IMCircleMangerMemberIconCell = "IMCircleMangerMemberIconCell"
private let IMCircleMangerCell = "IMCircleMangerCell"
private let IMCircleMangerSwitchCell = "IMCircleMangerSwitchCell"
private let IMCircleMangerOperatorCell = "IMCircleMangerOperatorCell"

class FSIMCircleMangerDetailVC: GYZWhiteNavBaseVC {
    
    var managerTitles:[String] = ["管理社圈","圈内昵称","*ID账号","*二维码","公告","简介","置顶消息","消息免打扰","查找聊天内容","地址","清空聊天内容","删除并退出"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "社圈"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSIMCircleMemberCell.classForCoder(), forCellReuseIdentifier: IMCircleMangerMemberIconCell)
        table.register(GYZCommonArrowCell.classForCoder(), forCellReuseIdentifier: IMCircleMangerCell)
        table.register(GYZCommonSwitchCell.classForCoder(), forCellReuseIdentifier: IMCircleMangerSwitchCell)
        table.register(GYZLabelCenterCell.classForCoder(), forCellReuseIdentifier: IMCircleMangerOperatorCell)
        
        
        return table
    }()
    ///获取广场 话题搜索数据
    //    func requestTalkSearchList(){
    //        if !GYZTool.checkNetWork() {
    //            return
    //        }
    //
    //        weak var weakSelf = self
    //        showLoadingView()
    //
    //        GYZNetWork.requestNetwork("Dynamic/Topic/search",parameters: ["p":currPage,"keyword": searchContent],  success: { (response) in
    //
    //            weakSelf?.closeRefresh()
    //            weakSelf?.hiddenLoadingView()
    //            GYZLog(response)
    //
    //            if response["result"].intValue == kQuestSuccessTag{//请求成功
    //
    //                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
    //
    //                guard let data = response["data"]["list"].array else { return }
    //                for item in data{
    //                    guard let itemInfo = item.dictionaryObject else { return }
    //                    let model = FSTalkModel.init(dict: itemInfo)
    //
    //                    weakSelf?.dataList.append(model)
    //                }
    //                weakSelf?.tableView.reloadData()
    //                if weakSelf?.dataList.count > 0{
    //                    weakSelf?.hiddenEmptyView()
    //                }else{
    //                    ///显示空页面
    //                    weakSelf?.showEmptyView(content:"暂无话题信息")
    //                }
    //
    //            }else{
    //                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
    //            }
    //
    //        }, failture: { (error) in
    //            weakSelf?.closeRefresh()
    //            weakSelf?.hiddenLoadingView()
    //            GYZLog(error)
    //
    //            //第一次加载失败，显示加载错误页面
    //            if weakSelf?.currPage == 1{
    //                weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
    //                    weakSelf?.hiddenEmptyView()
    //                    weakSelf?.requestTalkSearchList()
    //                })
    //            }
    //
    //        })
    //    }
    /// 全部成员
    func goAllMembers(){
        let vc = FSIMCircleAllMemberVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 管理社圈
    func goManageCircle(){
        let vc = FSManageIMCircleVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 简介
    func goEditIntroduction(){
        let vc = FSEditIntroductionVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 昵称
    func goEditNickName(){
        let vc = FSEditIMCircleNameVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 公告
    func goNoticeVC(){
        let vc = FSIMCircleNoticeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSIMCircleMangerDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return managerTitles.count + 1
        //            return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleMangerMemberIconCell) as! FSIMCircleMemberCell
            
            cell.didSelectItemBlock = {[unowned self](index) in
                self.goAllMembers()
            }
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 7 || indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleMangerSwitchCell) as! GYZCommonSwitchCell
            
            cell.nameLab.text = managerTitles[indexPath.row - 1]
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 11 || indexPath.row == 12 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleMangerOperatorCell) as! GYZLabelCenterCell
            cell.nameLab.text = managerTitles[indexPath.row - 1]
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleMangerCell) as! GYZCommonArrowCell
            
            cell.nameLab.text = managerTitles[indexPath.row - 1]
            
            if indexPath.row == 3 || indexPath.row == 10 {
                cell.rightIconView.isHidden = true
            }else{
                cell.rightIconView.isHidden = false
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
        if indexPath.row == 1 { //管理社圈
            goManageCircle()
        }else if indexPath.row == 2 { //昵称
            goEditNickName()
        }else if indexPath.row == 5 { //公告
            goNoticeVC()
        }else if indexPath.row == 6 { //简介
            goEditIntroduction()
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 0 {
            return 50
        }
        return 130
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
