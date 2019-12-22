//
//  FSTopicManagerVC.swift
//  fitsky
//  管理话题
//  Created by gouyz on 2019/9/6.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let topicManagerCell = "topicManagerCell"

class FSTopicManagerVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ isRefesh: Bool) -> Void)?
    var isModify:Bool = false
    
    var topicId: String = ""
    var topicContent: String = ""
    //// 最大字数
    var contentMaxCount: Int = 30

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "管理话题"
        
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
        
        table.register(GYZLabArrowCell.classForCoder(), forCellReuseIdentifier: topicManagerCell)
        
        return table
    }()
    
    override func clickedBackBtn() {
        if resultBlock != nil {
            resultBlock!(isModify)
        }
        super.clickedBackBtn()
    }
    //  导语编辑
    func goEditIntroduce(){
        let vc = FSEditTopicIntroduceVC()
        vc.topicContent = self.topicContent
        vc.topicId = self.topicId
        vc.contentMaxCount = self.contentMaxCount
        vc.resultBlock = {[unowned self](isRefresh) in
            self.isModify = isRefresh
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSTopicManagerVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: topicManagerCell) as! GYZLabArrowCell
        
        cell.nameLab.text = "导语编辑"
        cell.nameLab.textColor = kGaryFontColor
        
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
        goEditIntroduce()
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
