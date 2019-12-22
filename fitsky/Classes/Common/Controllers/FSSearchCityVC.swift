//
//  FSSearchCityVC.swift
//  fitsky
//  搜索城市
//  Created by gouyz on 2019/7/24.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let searchCityCell = "searchCityCell"

class FSSearchCityVC: GYZWhiteNavBaseVC {
    /// 搜索城市
    var cityList:[FSCityListModel] = [FSCityListModel]()
    // 所有的城市
    var cityAllList:[FSCityListModel] = [FSCityListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }

        getCityInfo()
    }
    ///本地获取城市信息
    func getCityInfo(){
        let model = userDefaults.data(forKey: ALLCITYINFO)
        if model != nil {
            
            let cityModel: FSCityModel = (NSKeyedUnarchiver.unarchiveObject(with: model!) as? FSCityModel)!
            for item in cityModel.cityListDic.keys{
                cityAllList += cityModel.cityListDic[item]!
            }
        }
    }
    func setupUI(){
        
        /// 解决iOS11中UISearchBar高度变大
        if #available(iOS 11.0, *) {
            let titleView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth - 100, height: kTitleHeight))
            
            searchBar.frame = titleView.bounds
            titleView.addSubview(searchBar)
            navigationItem.titleView = titleView
        }else{
            navigationItem.titleView = searchBar
        }
        
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        btn.addTarget(self, action: #selector(cancleSearchClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(GYZLabArrowCell.self, forCellReuseIdentifier: searchCityCell)
        
        return table
    }()
    
    /// 搜索框
    lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        
        search.placeholder = "请输入城市名/拼音"
        search.delegate = self
        //显示输入光标
        search.tintColor = kHeightGaryFontColor
        /// 搜索框背景色
        if #available(iOS 13.0, *){
            search.searchTextField.backgroundColor = kGrayBackGroundColor
        }else{
            if let textfiled = search.subviews.first?.subviews.last as? UITextField {
                textfiled.backgroundColor = kGrayBackGroundColor
            }
        }
        //弹出键盘
        search.becomeFirstResponder()
        
        return search
    }()
    
    /// 取消搜索
    @objc func cancleSearchClick(){
        searchBar.resignFirstResponder()
        
        self.dismiss(animated: false, completion: nil)
    }
    
    ///保存选择城市信息
    func saveSelectCityInfo(city: FSCityListModel){
        userDefaults.removeObject(forKey: CURRCITYAREAINFO)
        let model = NSKeyedArchiver.archivedData(withRootObject: city)
        userDefaults.set(model, forKey: CURRCITYINFO)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func searchCityData(searchTxt: String){
        cityList.removeAll()
        for city in cityAllList {
            let chinese: Range? = city.name?.range(of: searchTxt, options: NSString.CompareOptions.caseInsensitive)
            let pinYin: Range? = city.full_pinyin?.range(of: searchTxt, options: .caseInsensitive)
            let shortPinyin: Range? = city.short_pinyin?.range(of: searchTxt, options: .caseInsensitive)
            
            if chinese != nil || pinYin != nil || shortPinyin != nil{
                cityList.append(city)
            }
        }
        if cityList.count > 0 {
            hiddenEmptyView()
            tableView.reloadData()
        }else{
            showEmptyView(content:"未搜索到城市信息")
        }
    }

}
extension FSSearchCityVC: UISearchBarDelegate{
    ///mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if searchBar.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入搜索内容")
            return
        }
        searchCityData(searchTxt: searchBar.text!)
    }
}
extension FSSearchCityVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCityCell) as! GYZLabArrowCell
        
        let model = cityList[indexPath.row]
        cell.nameLab.text = model.name
        cell.rightIconView.isHidden = true
        
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTitleHeight
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveSelectCityInfo(city: cityList[indexPath.row])
    }
    
}

