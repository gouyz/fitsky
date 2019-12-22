//
//  FSVenueInfoVC.swift
//  fitsky
//  场馆信息
//  Created by gouyz on 2019/9/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXPagingView
import SKPhotoBrowser

private let venueInfoHeader = "venueInfoHeader"
private let venueInfoImgCell = "venueInfoImgCell"
private let venueInfoCell = "venueInfoCell"
private let venueInfoContentCell = "venueInfoContentCell"

class FSVenueInfoVC: GYZWhiteNavBaseVC {
    
    var userModel: FSSquareUserModel?
    
    weak var naviController: UINavigationController?
    var listViewDidScrollCallback: ((UIScrollView) -> ())?

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
        
        // 设置大概高度
        table.estimatedRowHeight = 100
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSVenueInfoCell.classForCoder(), forCellReuseIdentifier: venueInfoCell)
        table.register(FSVenueContentCell.classForCoder(), forCellReuseIdentifier: venueInfoContentCell)
        table.register(FSVenueImgCell.classForCoder(), forCellReuseIdentifier: venueInfoImgCell)
        table.register(LHSGeneralHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: venueInfoHeader)
        
        return table
    }()
    
    /// 查看大图
    ///
    /// - Parameters:
    ///   - index: 索引
    ///   - urls: 图片路径
    func goBigPhotos(index: Int, urls: [String]){
        let browser = SKPhotoBrowser(photos: GYZTool.createWebPhotos(urls: urls, isShowDel: false, isShowAction: true))
        browser.initializePageIndex(index)
        //        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
    }
}
extension FSVenueInfoVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: venueInfoImgCell) as! FSVenueImgCell
                
                cell.dataModels = userModel?.storeData?.materialUrlList
                
                cell.didSelectItemBlock = {[unowned self] (index) in
                    self.goBigPhotos(index: index, urls: (self.userModel?.storeData?.materialOrgionUrlList)!)
                }
                
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: venueInfoCell) as! FSVenueInfoCell
                
                cell.dataModel = userModel?.storeData
                
                cell.selectionStyle = .none
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: venueInfoContentCell) as! FSVenueContentCell
            
            cell.dataModel = userModel?.storeData
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: venueInfoHeader) as! LHSGeneralHeaderView
        
        headerView.nameLab.textColor = kGaryFontColor
        if section == 0 {
            headerView.nameLab.text = "场馆设施"
        }else{
            headerView.nameLab.text = "场馆简介"
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}
extension FSVenueInfoVC: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallback = callback
    }
}
