//
//  FSApplyJoinIMCircleVC.swift
//  fitsky
//  申请加入
//  Created by gouyz on 2020/3/8.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

private let applyJoinIMCircleCell = "applyJoinIMCircleCell"

class FSApplyJoinIMCircleVC: GYZWhiteNavBaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "申请加入"
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
        
        table.register(FSApplyJoinIMCircleCell.classForCoder(), forCellReuseIdentifier: applyJoinIMCircleCell)
        
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
    ///
    func showAlert(){
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "同意申请加入吗？", cancleTitle: "拒绝", viewController: self, buttonTitles: "同意") { [unowned self] (tag) in
            
            if tag == cancelIndex{//拒绝
                
            }else{//同意
                
            }
        }
    }
}
extension FSApplyJoinIMCircleVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: applyJoinIMCircleCell) as! FSApplyJoinIMCircleCell
        
        
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
        showAlert()
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
