//
//  FSFoodMenuListVC.swift
//  fitsky
//  菜谱分类 list
//  Created by gouyz on 2019/10/12.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import MBProgressHUD

private let foodMenuListCell = "foodMenuListCell"

class FSFoodMenuListVC: GYZWhiteNavBaseVC {
    
    weak var naviController: UINavigationController?
    
    var categoryId: String = ""
    
    var categoryList:[FSCookBookCategoryModel] = [FSCookBookCategoryModel]()
    /// 请求参数
    var paramDic:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        table.register(FSFoodMenuListCell.classForCoder(), forCellReuseIdentifier: foodMenuListCell)
        
        
        return table
    }()
    /// 分类详情
    func goCategoryVC(index: Int){
        let model = categoryList[index]
        let vc = FSFoodMenuCategoryVC()
        vc.paramDic = [model.category_key!:model.id!]
        self.naviController?.pushViewController(vc, animated: true)
    }
}
extension FSFoodMenuListVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: foodMenuListCell) as! FSFoodMenuListCell
        
        cell.dataModel = categoryList[indexPath.row]
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
        goCategoryVC(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
}
extension FSFoodMenuListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
    func listDidAppear() {
        
    }
}
