//
//  FSIMCircleAllMemberVC.swift
//  fitsky
//  全部成员
//  Created by gouyz on 2020/3/7.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let IMCircleAllMemberCell = "IMCircleAllMemberCell"

class FSIMCircleAllMemberVC: GYZWhiteNavBaseVC {
    
    var isDel: Bool = false
    var dataList:[FSIMCircleMemberModel] = [FSIMCircleMemberModel]()
    var circleId: String = ""
    /// 是否是管理员
    var isAdmin: Bool = false
    ///  选择删除的成员
    var selectMemberDic:[String:FSIMCircleMemberModel] = [String:FSIMCircleMemberModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "全部成员"
        self.view.backgroundColor = kWhiteColor
        
        if isAdmin {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
            rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
            cancleBtn.addTarget(self, action: #selector(onClickCancleBtn), for: .touchUpInside)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestCircleMemberList()
    }
    var rightBtn: UIButton = {
       let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("删除", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        rightBtn.setTitleColor(kBlueFontColor, for: .selected)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        
        return rightBtn
    }()
    var cancleBtn: UIButton = {
       let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("取消", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        
        return rightBtn
    }()
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSIMCircleAllMemberCell.classForCoder(), forCellReuseIdentifier: IMCircleAllMemberCell)
        
        return table
    }()
    /// 删除
    @objc func onClickRightBtn(){
        if !isDel {
            isDel = true
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: cancleBtn)
            rightBtn.isSelected = isDel
            tableView.reloadData()
        }else{
            // 删除
            showDeleteAlert()
        }
    }
    
    /// 取消
    @objc func onClickCancleBtn(){
        dealDelete()
        tableView.reloadData()
    }
    ///获取社圈成员数据
    func requestCircleMemberList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Circle/Circle/member",parameters: ["circle_id":circleId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataList.removeAll()
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
                    weakSelf?.showEmptyView(content:"暂无成员信息")
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
    func showDeleteAlert(){
        if selectMemberDic.count == 0 {
            MBProgressHUD.showAutoDismissHUD(message: "请选择要删除的成员")
            return
        }
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确认删除吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { [unowned self] (tag) in
            
            if tag != cancelIndex{
                self.requestDeleteMember()
            }
        }
    }
    //删除成员
    func requestDeleteMember(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        var ids: String = ""
        for item in selectMemberDic.keys {
            ids += item + ","
        }
        ids = ids.subString(start: 0, length: ids.count - 1)
        
        GYZNetWork.requestNetwork("Circle/Circle/deleteMember", parameters: ["id":ids],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.requestCircleMemberList()
                weakSelf?.dealDelete()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func dealDelete(){
        isDel = false
        rightBtn.isSelected = isDel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: (isWhiteBack ? "icon_back_white" : "icon_back_black"))?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedBackBtn))
    }
    // 关注
    @objc func onClickedFollow(sender:UITapGestureRecognizer){
        
        let index = sender.view?.tag
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Member/MemberFollow/add", parameters: ["friend_id":dataList[index!].member_id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                weakSelf?.dataList[index!].friend_type = data["statue"].stringValue
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSIMCircleAllMemberVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleAllMemberCell) as! FSIMCircleAllMemberCell
        cell.followLab.tag = indexPath.row

        cell.followLab.addOnClickListener(target: self, action: #selector(onClickedFollow(sender:)))
        
        let model = dataList[indexPath.row]
        cell.dataModel = model
        
        if isDel {
            cell.followLab.isHidden = isDel
            if model.is_group == "1" || model.is_admin == "1" {
                cell.checkImgView.isHidden = true
            }else{
                cell.checkImgView.isHidden = !isDel
            }
            if selectMemberDic.keys.contains(model.id!) {
                cell.checkImgView.image = UIImage.init(named: "app_btn_sel_yes")
            }else{
                cell.checkImgView.image = UIImage.init(named: "app_btn_sel_no")
            }
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
         let model = dataList[indexPath.row]
         if model.is_group == "1" || model.is_admin == "1" {
         }else{
            let memberId: String = model.id!
            if selectMemberDic.keys.contains(memberId) {
                selectMemberDic.removeValue(forKey: memberId)
            }else{
                selectMemberDic[memberId] = model
            }
             tableView.reloadData()
         }
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
