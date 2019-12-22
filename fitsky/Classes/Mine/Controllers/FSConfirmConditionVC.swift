//
//  FSConfirmConditionVC.swift
//  fitsky
//  认证条件
//  Created by gouyz on 2019/10/22.
//  Copyright © 2019 gyz. All rights reserved.
// 2637 614 1209 320 400

import UIKit
import MBProgressHUD

private let confirmConditionCell = "confirmConditionCell"

class FSConfirmConditionVC: GYZWhiteNavBaseVC {
    
    /// 1达人认证2社长认证
    var type: String = "1"
    
    var dataModel: FSConfirmConditionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "认证条件"
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestApplyCondition()
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
        
        table.register(FSConfirmConditionCell.classForCoder(), forCellReuseIdentifier: confirmConditionCell)
        
        return table
    }()
    ///
    lazy var rightBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("下一步", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.setTitleColor(kHeightGaryFontColor, for: .disabled)
        btn.frame = CGRect.init(x: 0, y: 0, width: 60, height: kTitleHeight)
        
        return btn
    }()
    
    //申请认证条件
    func requestApplyCondition(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        var method: String = "Member/Apply/szApplyCondition"
        if type == "1" {
            method = "Member/Apply/darenApplyCondition"
        }
        
        GYZNetWork.requestNetwork(method, parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSConfirmConditionModel.init(dict: data)
                
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 下一步
    @objc func onClickRightBtn(){
        if dataModel != nil{
            if dataModel?.is_apply == "1"{
                if type == "1" {//达人认证
                    goDaRenConfirm()
                }else{// 社长认证
                    goSheZhangConfirm()
                }
            }else{
                showNoApply()
            }
        }
    }
    func showNoApply(){
        GYZAlertViewTools.alertViewTools.showAlert(title: "不满足认证条件", message: (dataModel?.no_apply_text)!, cancleTitle: nil, viewController: self, buttonTitles: "确定")
    }
    /// 达人认证
    func goDaRenConfirm(){
        let vc = FSDaRenConfirmVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 社长认证
    func goSheZhangConfirm(){
        let vc = FSSheZhangConfirmVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSConfirmConditionVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel != nil ? (dataModel?.conditionList.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: confirmConditionCell) as! FSConfirmConditionCell
        
        cell.nameLab.text = dataModel?.conditionList[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
