//
//  FSCoinRuleVC.swift
//  fitsky
//  积分规则
//  Created by gouyz on 2019/10/28.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let coinRuleCell = "coinRuleCell"

class FSCoinRuleVC: GYZWhiteNavBaseVC {
    
    var addRuleList: [String] = [String]()
    var minusRuleList: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "积分规则"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestCoinRule()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = kTitleHeight
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSConfirmConditionCell.classForCoder(), forCellReuseIdentifier: coinRuleCell)
        
        return table
    }()
    
    //积分规则
    func requestCoinRule(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/MemberPoint/rule", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let addData = response["data"]["add"].array else { return }
                for addItem in addData {
                    weakSelf?.addRuleList.append(addItem.stringValue)
                }
                
                guard let minusData = response["data"]["sub"].array else { return }
                for subItem in minusData {
                    weakSelf?.minusRuleList.append(subItem.stringValue)
                }
                
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSCoinRuleVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return addRuleList.count
        }
        return minusRuleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: coinRuleCell) as! FSConfirmConditionCell
        
        if indexPath.section == 0 {
            cell.nameLab.text = addRuleList[indexPath.row]
            cell.bgView.backgroundColor = kBlueFontColor
        }else{
            cell.nameLab.text = minusRuleList[indexPath.row]
            cell.bgView.backgroundColor = kRedFontColor
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
