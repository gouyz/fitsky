//
//  FSManageIMCircleVC.swift
//  fitsky
//  管理社圈
//  Created by gouyz on 2020/3/7.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit


private let manageIMCircleCell = "manageIMCircleCell"
private let manageIMCircleSwitchCell = "manageIMCircleSwitchCell"

class FSManageIMCircleVC: GYZWhiteNavBaseVC {
    
    var managerTitles:[String] = ["代号","分类","坐标","社圈邀请确认","管理权转让","新的申请"]

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
        
        //            weak var weakSelf = self
        //            ///添加下拉刷新
        //            GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
        //                weakSelf?.refresh()
        //            })
        //            ///添加上拉加载更多
        //            GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
        //                weakSelf?.loadMore()
        //            })
        
        return table
    }()

    /// 修改代号
    func goModeifyDaiHao(){
        let vc = FSModifyDaiHaoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 管理权转让
    func goTransferManage(){
        let vc = FSTransferManageVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 申请加入
    func goApplyJoin(){
        let vc = FSApplyJoinIMCircleVC()
        navigationController?.pushViewController(vc, animated: true)
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
            
            cell.nameLab.text = managerTitles[indexPath.row]
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: manageIMCircleCell) as! GYZCommonArrowCell
            
            cell.nameLab.text = managerTitles[indexPath.row]
            cell.nameLab.font = UIFont.boldSystemFont(ofSize: 14)
            cell.contentLab.font = UIFont.boldSystemFont(ofSize: 14)
            cell.contentLab.textAlignment = .left
            cell.contentLab.textColor = kGaryFontColor
            if indexPath.row == 1 {
                cell.contentLab.text = "湖塘社圈1圈"
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
