//
//  FSIMCircleCategoryVC.swift
//  fitsky
//  分类
//  Created by gouyz on 2020/3/17.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let IMCircleCategoryCell = "IMCircleCategoryCell"

class FSIMCircleCategoryVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ categoryModel: FSWorksCategoryModel) -> Void)?
    var dataList: [FSWorksCategoryModel] = [FSWorksCategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "分类"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestWorksList()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSSelectSeePowerCell.classForCoder(), forCellReuseIdentifier: IMCircleCategoryCell)
        
        return table
    }()
    
    ///获取社圈类别数据
    func requestWorksList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Circle/Circle/category",parameters: nil,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSWorksCategoryModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无社圈分类信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.hiddenEmptyView()
                weakSelf?.requestWorksList()
            })
            
        })
    }
    
}
extension FSIMCircleCategoryVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleCategoryCell) as! FSSelectSeePowerCell
        
        cell.nameLab.text = dataList[indexPath.row].name
        cell.desLab.isHidden = true
        cell.desLab.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        cell.nameLab.snp.updateConstraints { (make) in
            make.height.equalTo(40)
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
        
        if resultBlock != nil {
            resultBlock!(dataList[indexPath.row])
        }
        self.clickedBackBtn()
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
