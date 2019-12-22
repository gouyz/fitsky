//
//  FSSelectCityVC.swift
//  fitsky
//  城市选择
//  Created by gouyz on 2019/7/19.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let selectAreasHeaderView = "selectAreasHeaderView"
private let cityHeaderView = "cityHeaderView"
private let selectAreasCell = "selectAreasCell"
private let cityCell = "cityCell"

class FSSelectCityVC: GYZWhiteNavBaseVC {
    
    /// 搜索 内容
    var searchContent: String = ""
    /// 所有城市
    var cityModel: FSCityModel?
    /// 热门城市
    var hotCityList: [FSCityListModel] = [FSCityListModel]()
    /// 当前选择城市
    var currCityModel: FSCityListModel?
    /// 当前选择区县
    var currAreaModel: FSCityListModel?
    /// 是否显示当前城市的所有区县
    var isShowArea: Bool = false
    /// 高德地图定位
    let locationManager: AMapLocationManager = AMapLocationManager()
    /// 当前定位城市
    var currLocationCityModel: FSCityListModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchView
        searchView.searchBtn.addTarget(self, action: #selector(onClickedSearch), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"app_btn_close")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(onClickClose))
        
        initLocation()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestCityData()
    }
    /// 初始化高德地图定位
    func initLocation(){
        locationManager.delegate = self
        /// 设置定位最小更新距离
        locationManager.distanceFilter = 200
        locationManager.locatingWithReGeocode = true
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSHotCityCell.self, forCellReuseIdentifier: selectAreasCell)
        table.register(FSCitySelectedHeaderView.self, forHeaderFooterViewReuseIdentifier: selectAreasHeaderView)
        table.register(GYZLabArrowCell.self, forCellReuseIdentifier: cityCell)
        table.register(LHSGeneralHeaderView.self, forHeaderFooterViewReuseIdentifier: cityHeaderView)
        
        return table
    }()
    
    lazy var searchView: GYZSearchBtnView = GYZSearchBtnView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kTitleHeight))
    
    /// 取消
    @objc func onClickClose(){
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 搜索
    @objc func onClickedSearch(){
        let vc = FSSearchCityVC()
        let cityNav = GYZBaseNavigationVC(rootViewController:vc)
        self.present(cityNav, animated: true, completion: nil)
    }
    
    ///获取城市数据
    func requestAllCityList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Home/ChinaArea/city",parameters: nil,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                
                weakSelf?.cityModel = FSCityModel.init(dict: data)
                
                if weakSelf?.cityModel?.cityListDic.count > 0{
                    weakSelf?.locationManager.startUpdatingLocation()
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                    weakSelf?.saveCityInfo(citys: (weakSelf?.cityModel)!)
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无城市信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            //第一次加载失败，显示加载错误页面
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.hiddenEmptyView()
                weakSelf?.requestCityData()
            })
        })
    }

    ///获取热门城市数据
    func requestHotCityList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("Home/ChinaArea/hotCity",parameters: nil,  success: { (response) in
            
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"]["list"].array else { return }
                
                weakSelf?.hotCityList.removeAll()
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSCityListModel.init(dict: itemInfo)
                    
                    weakSelf?.hotCityList.append(model)
                }
                
                if weakSelf?.hotCityList.count > 0{
                    weakSelf?.tableView.reloadData()
                }
                
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
    
    func requestCityData(){
        getCityInfo()
        requestHotCityList()
    }
    ///保存城市信息
    func saveCityInfo(citys: FSCityModel){
        let model = NSKeyedArchiver.archivedData(withRootObject: citys)
        userDefaults.set(model, forKey: ALLCITYINFO)
    }
    ///保存选择城市信息/区域信息
    func saveSelectCityInfo(city: FSCityListModel,keyStr: String){
        let model = NSKeyedArchiver.archivedData(withRootObject: city)
        userDefaults.set(model, forKey: keyStr)
        self.dismiss(animated: true, completion: nil)
    }
    ///本地获取城市信息
    func getCityInfo(){
        /// 获取当前选择城市
        if let currModel =  userDefaults.data(forKey: CURRCITYINFO){
            currCityModel = NSKeyedUnarchiver.unarchiveObject(with: currModel) as? FSCityListModel
            let area = FSCityListModel.init(dict: ["id":"0","name":"全城"])
            currCityModel?.areaList.insert(area, at: 0)
        }
        /// 获取当前选择城市区县
        if let currModel =  userDefaults.data(forKey: CURRCITYAREAINFO){
            currAreaModel = NSKeyedUnarchiver.unarchiveObject(with: currModel) as? FSCityListModel
        }
         ///本地获取城市信息
        let model = userDefaults.data(forKey: ALLCITYINFO)
        if model != nil {

            locationManager.startUpdatingLocation()
            cityModel = NSKeyedUnarchiver.unarchiveObject(with: model!) as? FSCityModel
            tableView.reloadData()
        }else{
            requestAllCityList()
        }
    }
    /// 展开区域
    @objc func onClickedAreaExport(){
        isShowArea = !isShowArea
        tableView.reloadData()
    }
}
extension FSSelectCityVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if cityModel != nil {
            return (cityModel?.pinyinIndexArr.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cityModel != nil {
            if section > 2 {
                return (cityModel?.cityListDic[(cityModel?.pinyinIndexArr[section])!]!.count)!
            }
        }
        if section == 1 {// 定位城市
            return currLocationCityModel == nil ? 0 : 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section > 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cityCell) as! GYZLabArrowCell
            
            let model = cityModel?.cityListDic[(cityModel?.pinyinIndexArr[indexPath.section])!]![indexPath.row]
            cell.nameLab.text = model?.name
            cell.rightIconView.isHidden = true
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: selectAreasCell) as! FSHotCityCell
            
            cell.areaModel = nil
            if indexPath.section == 2{/// 热门城市
                cell.dataModels = hotCityList
            }else if indexPath.section == 0{/// 当前城市
                cell.areaModel = currAreaModel
                if currCityModel != nil{
                    cell.dataModels = currCityModel?.areaList
                }
            }else{// 当前定位城市
                cell.dataModels = [currLocationCityModel!]
            }
            
            cell.didSelectItemBlock = {[unowned self] (index) in
                if indexPath.section == 0{
                    self.saveSelectCityInfo(city: ((self.currCityModel?.areaList[index])!),keyStr: CURRCITYAREAINFO)
                }else if indexPath.section == 2{/// 热门城市
                    
                    let hotCity = self.hotCityList[index]
                    for item in (self.cityModel?.cityListDic[hotCity.first_pinyin!])!{
                        if item.id == hotCity.id{
                            userDefaults.removeObject(forKey: CURRCITYAREAINFO)
                            self.saveSelectCityInfo(city: item,keyStr: CURRCITYINFO)
                            
                            break
                        }
                    }
                }else if indexPath.section == 1{
                    userDefaults.removeObject(forKey: CURRCITYAREAINFO)
                    self.saveSelectCityInfo(city: self.currLocationCityModel!,keyStr: CURRCITYINFO)
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: selectAreasHeaderView) as! FSCitySelectedHeaderView
            
            if currCityModel != nil{
                headerView.nameLab.text = "当前：\((currCityModel?.name)!)" + (currAreaModel != nil ? (currAreaModel?.name)! : "")
                headerView.areasBtn.isHidden = false
            }else{
                headerView.nameLab.text = "当前：暂无选择城市"
                headerView.areasBtn.isHidden = true
            }
            headerView.areasBtn.addTarget(self, action: #selector(onClickedAreaExport), for: .touchUpInside)
            
            return headerView
        }else{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: cityHeaderView) as! LHSGeneralHeaderView
            
            headerView.nameLab.text = cityModel?.pinyinIndexArr[section]
            headerView.lineView.isHidden = true
            if section > 2{
                headerView.nameLab.backgroundColor = kGrayBackGroundColor
                headerView.nameLab.text = cityModel?.pinyinIndexArr[section]
                headerView.nameLab.snp.updateConstraints { (make) in
                    make.width.equalTo(30)
                }
                headerView.nameLab.textAlignment = .center
            }else{
                headerView.nameLab.backgroundColor = kWhiteColor
                headerView.nameLab.text = section == 1 ? "当前定位" : "热门城市"
                headerView.nameLab.snp.updateConstraints { (make) in
                    make.width.equalTo(80)
                }
                headerView.nameLab.textAlignment = .left
            }
            
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section > 2 {
            return kTitleHeight
        }else if indexPath.section == 2 {
            if hotCityList.count > 0{
                return (hotCityList.count % 3 == 0 ? CGFloat(Int(hotCityList.count / 3)) : CGFloat(Int(hotCityList.count / 3) + 1)) * 40 - kMargin
            }
            return 0.0
        }else if indexPath.section == 1 {
            return 30
        }else{
            if currCityModel != nil && currCityModel?.areaList.count > 0 {
                return isShowArea ? ((currCityModel?.areaList.count)! % 3 == 0 ? CGFloat(Int((currCityModel?.areaList.count)! / 3)) : CGFloat(Int((currCityModel?.areaList.count)! / 3) + 1)) * 40 - kMargin : 0.0
            }
            return  0.0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 2 {
            userDefaults.removeObject(forKey: CURRCITYAREAINFO)
            saveSelectCityInfo(city: (cityModel?.cityListDic[(cityModel?.pinyinIndexArr[indexPath.section])!]![indexPath.row])!,keyStr: CURRCITYINFO)
        }
    }
    
    //实现索引数据源代理方法
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return cityModel?.pinyinIndexArr
    }
    
    //点击索引，移动TableView的组位置
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        var tpIndex:Int = 0
        //遍历索引值
        for character in cityModel!.pinyinIndexArr{
            //判断索引值和组名称相等，返回组坐标
            if character == title{
                return tpIndex
            }
            tpIndex += 1
        }
        return 0
    }
}

extension FSSelectCityVC:AMapLocationManagerDelegate{
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode?) {
        NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy);};");
        
        if let reGeocode = reGeocode {
            locationManager.stopUpdatingLocation()
            NSLog("reGeocode:%@", reGeocode)
            if reGeocode.city != nil{
                findLocationCity(cityName: reGeocode.city)
            }
            if currLocationCityModel != nil{
                tableView.reloadData()
            }
        }
    }
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        
    }
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        GYZLog(error)
    }
    
    /// 根据城市名称获取数据库中对应的城市
    ///
    /// - Parameter cityName: 城市名称
    func findLocationCity(cityName: String){
        var name: String = cityName
        if name.isEmpty {
            return
        }
        name = name.subString(start: 0, length: name.count - 1)
        let firstString : String = GYZTool.shareTool.findFirstLetterFromString(aString: name)
        if cityModel != nil {
            let cityList:[FSCityListModel] = (cityModel?.cityListDic[firstString])!
            for city in cityList {
                if city.name == name{
                    currLocationCityModel = city
                    break
                }
            }
        }
    }
}
