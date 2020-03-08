//
//  FSTransferManageVC.swift
//  fitsky
//  管理权转让
//  Created by gouyz on 2020/3/8.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

private let transferManageCell = "transferManageCell"

class FSTransferManageVC: GYZWhiteNavBaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "管理权转让"
        self.view.backgroundColor = kWhiteColor
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("确定", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kGaryFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
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
        
        table.register(FSTransferManageCell.classForCoder(), forCellReuseIdentifier: transferManageCell)
        
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
    /// 确定
    @objc func onClickRightBtn(){
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确认将管理权转让?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { [unowned self] (tag) in
            
            if tag != cancelIndex{
                
            }
        }
    }
}
extension FSTransferManageVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: transferManageCell) as! FSTransferManageCell
        
        
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
