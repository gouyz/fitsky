//
//  FSManageIMCircleVC.swift
//  fitsky
//  管理社圈
//  Created by gouyz on 2020/3/7.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let manageIMCircleCell = "manageIMCircleCell"
private let manageIMCircleSwitchCell = "manageIMCircleSwitchCell"

class FSManageIMCircleVC: GYZWhiteNavBaseVC {
    
    var managerTitles:[String] = ["社圈名称","分类","坐标","社圈邀请确认","管理权转让","新的申请"]
    var circleId: String = ""
    var dataModel: FSIMCircleDetailModel?
    /// 地点
    var currAddress: AMapPOI?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "管理社圈"
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
        
        table.register(GYZCommonArrowCell.classForCoder(), forCellReuseIdentifier: manageIMCircleCell)
        table.register(GYZCommonSwitchCell.classForCoder(), forCellReuseIdentifier: manageIMCircleSwitchCell)
        
        return table
    }()

    /// 修改社圈名称
    func goModeifyDaiHao(){
        let vc = FSModifyDaiHaoVC()
        vc.circleId = circleId
        vc.contentMaxCount = dataModel == nil ? 10 : (dataModel?.circle_name_limit)!
        vc.nickName = dataModel == nil ? "" : (dataModel?.circleModel?.name)!
        vc.resultBlock = {[unowned self] (name) in
            self.dataModel?.circleModel?.name = name
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 管理权转让
    func goTransferManage(){
        let vc = FSTransferManageVC()
        vc.circleId = circleId
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 申请加入
    func goApplyJoin(){
        let vc = FSApplyJoinIMCircleVC()
        vc.circleId = circleId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 修改坐标
    func goSelectAddress(){
        let vc = FSSelectAddressVC()
        vc.selectPoi = self.currAddress
        vc.resultBlock = {[unowned self] (address) in
            self.currAddress = address
            if  address != nil {
                self.requestAddressInfo()
            }
        }
        let seeNav = GYZBaseNavigationVC(rootViewController:vc)
        self.present(seeNav, animated: true, completion: nil)
    }
    
    /// 社圈邀请确认状态
    @objc func onSwitchViewChange(sender: UISwitch){
//        let tag = sender.tag
        let status: String = sender.isOn ? "1" : "0"
        requestConfirmationInfo(status: status)
    }
    
    //修改社圈邀请确认
    func requestConfirmationInfo(status: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Circle/Circle/editIsInvitationConfirmation", parameters: ["is_invitation_confirmation":status,"id":circleId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataModel?.circleModel?.is_invitation_confirmation = status
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    //修改坐标
    func requestAddressInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        let paramDic: [String:Any] = ["id":circleId,"province":currAddress?.province ?? "","city":currAddress?.city ?? "","county":currAddress?.district ?? "","lng":currAddress?.location.longitude ?? "","lat":currAddress?.location.latitude ?? "","position":currAddress?.name ?? "","address":currAddress?.address ?? ""]
        
        GYZNetWork.requestNetwork("Circle/Circle/editPosition", parameters: paramDic,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataModel?.circleModel?.province = weakSelf?.currAddress?.province
                weakSelf?.dataModel?.circleModel?.city = weakSelf?.currAddress?.city
                weakSelf?.dataModel?.circleModel?.county = weakSelf?.currAddress?.district
                weakSelf?.dataModel?.circleModel?.position = weakSelf?.currAddress?.name
                weakSelf?.dataModel?.circleModel?.address = weakSelf?.currAddress?.address
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSManageIMCircleVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return managerTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 3 {// 社圈邀请确认
            let cell = tableView.dequeueReusableCell(withIdentifier: manageIMCircleSwitchCell) as! GYZCommonSwitchCell
            
            cell.switchView.tag = indexPath.row
            cell.switchView.addTarget(self, action: #selector(onSwitchViewChange(sender:)), for: .valueChanged)
            
            cell.nameLab.text = managerTitles[indexPath.row]
            if let model = dataModel {
                cell.switchView.isOn = model.circleModel?.is_invitation_confirmation == "1"
            }
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: manageIMCircleCell) as! GYZCommonArrowCell
            
            cell.nameLab.text = managerTitles[indexPath.row]
            cell.nameLab.font = UIFont.boldSystemFont(ofSize: 14)
            cell.contentLab.font = UIFont.boldSystemFont(ofSize: 14)
            cell.contentLab.textAlignment = .left
            cell.contentLab.textColor = kGaryFontColor
            cell.rightIconView.isHidden = false
            if indexPath.row == 1 {
                cell.rightIconView.isHidden = true
            }
            cell.contentLab.text = ""
            if let model = dataModel {
                if indexPath.row == 0 {
                    cell.contentLab.text = model.circleModel?.name
                }else if indexPath.row == 1{
                    cell.contentLab.text = model.circleModel?.category_id_text
                }else if indexPath.row == 2{
                    cell.contentLab.text = (model.circleModel?.province)! + (model.circleModel?.city)! + (model.circleModel?.county)!
                }
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
 
        if indexPath.row == 0 {// 代号
            goModeifyDaiHao()
        }else if indexPath.row == 2{// 坐标
            goSelectAddress()
        }else if indexPath.row == 4{// 管理权转让
            goTransferManage()
        }else if indexPath.row == 5{// 申请加入
            goApplyJoin()
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
