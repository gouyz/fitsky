//
//  FSApplyJoinIMCircleVC.swift
//  fitsky
//  申请加入
//  Created by gouyz on 2020/3/8.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let applyJoinIMCircleCell = "applyJoinIMCircleCell"

class FSApplyJoinIMCircleVC: GYZWhiteNavBaseVC {
    
    var dataList:[FSIMCircleMemberModel] = [FSIMCircleMemberModel]()
    var circleId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "申请加入"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestCircleMemberList()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSApplyJoinIMCircleCell.classForCoder(), forCellReuseIdentifier: applyJoinIMCircleCell)
        
        return table
    }()
    ///获取申请加入成员数据
    func requestCircleMemberList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Circle/Circle/memberApply",parameters: ["circle_id":circleId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSIMCircleMemberModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无申请信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.hiddenEmptyView()
                weakSelf?.requestCircleMemberList()
            })
        })
    }
    
    //同意加入社圈
    func requestJoinAgree(index:Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Circle/Circle/joinAgree", parameters: ["id":dataList[index].id!],  success: { (response) in

            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)

            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataList[index].status = "1"
                weakSelf?.dataList[index].status_text = "已同意"
                weakSelf?.tableView.reloadData()
            }

        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    //拒绝加入社圈
    func requestJoinRefuse(index:Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Circle/Circle/joinRefuse", parameters: ["id":dataList[index].id!],  success: { (response) in

            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)

            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataList[index].status = "2"
                weakSelf?.dataList[index].status_text = "已拒绝"
                weakSelf?.tableView.reloadData()
            }

        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    @objc func onClickedStatus(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = dataList[tag!]
        if model.status == "0" {
            showAlert(index: tag!)
        }
    }
    ///
    func showAlert(index:Int){
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "同意申请加入吗？", cancleTitle: "拒绝", viewController: self, buttonTitles: "同意") { [unowned self] (tag) in
            
            if tag == cancelIndex{//拒绝
                self.requestJoinRefuse(index: index)
            }else{//同意
                self.requestJoinAgree(index: index)
            }
        }
    }
}
extension FSApplyJoinIMCircleVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: applyJoinIMCircleCell) as! FSApplyJoinIMCircleCell
        
        cell.stateLab.tag = indexPath.row
        cell.stateLab.addOnClickListener(target: self, action: #selector(onClickedStatus(sender:)))
        
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
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
