//
//  FSSexInfoVC.swift
//  fitsky
//  选择性别
//  Created by gouyz on 2019/7/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSSexInfoVC: GYZWhiteNavBaseVC {
    
    /// 0-女 1-男 2-保密
    var sex: String = "2"
    var currCityModel: FSCityListModel?
    /// 所有城市
    var cityModel: FSCityModel?
    /// 高德地图定位
    let locationManager: AMapLocationManager = AMapLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        self.view.backgroundColor = kWhiteColor
        
        navigationItem.leftBarButtonItem = nil
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("进入", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        rightBtn.sizeToFit() // 解决iOS11以下，显示不全
        
        initLocation()
        setUpUI()
        getCityInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let model = userDefaults.data(forKey: CURRCITYINFO)
        if model != nil {
            
            currCityModel = NSKeyedUnarchiver.unarchiveObject(with: model!) as? FSCityListModel
            cityBtn.setTitle(currCityModel?.name, for: .normal)
        }
    }
    /// 初始化高德地图定位
    func initLocation(){
        locationManager.delegate = self
        /// 设置定位最小更新距离
        locationManager.distanceFilter = 200
        locationManager.locatingWithReGeocode = true
    }
    
    func setUpUI(){
        view.addSubview(desLab)
        view.addSubview(checkWomanImgView)
        view.addSubview(checkManImgView)
        view.addSubview(desCityLab)
        view.addSubview(addressImgView)
        view.addSubview(cityBtn)
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(kTitleHeight + kTitleAndStateHeight)
            make.right.equalTo(-30)
            make.height.equalTo(30)
        }
        checkWomanImgView.snp.makeConstraints { (make) in
            make.right.equalTo(desLab.snp.centerX).offset(-20)
            make.top.equalTo(desLab.snp.bottom).offset(kTitleHeight)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        checkManImgView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab.snp.centerX).offset(20)
            make.top.size.equalTo(checkWomanImgView)
        }
        desCityLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab)
            make.top.equalTo(checkWomanImgView.snp.bottom).offset(60)
        }
        addressImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(desCityLab)
            make.top.equalTo(desCityLab.snp.bottom).offset(20)
            make.size.equalTo(checkWomanImgView)
        }
        cityBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(addressImgView.snp.bottom).offset(30)
            make.size.equalTo(CGSize.init(width: 200, height: kUIButtonHeight))
        }
    }

    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k18Font
        lab.textAlignment = .center
        lab.text = "你的性别"
        
        return lab
    }()
    
    /// 女
    lazy var checkWomanImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_btn_woman_nor"))
        imgView.highlightedImage = UIImage.init(named: "app_btn_woman_sel")
        imgView.addOnClickListener(target: self, action: #selector(clickedCheckSex(sender:)))
        imgView.tag = 101
        
        return imgView
    }()
    /// 男
    lazy var checkManImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_btn_man_nor"))
        imgView.highlightedImage = UIImage.init(named: "app_btn_man_sel")
        imgView.addOnClickListener(target: self, action: #selector(clickedCheckSex(sender:)))
        imgView.tag = 102
        
        return imgView
    }()
    ///
    lazy var desCityLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k18Font
        lab.textAlignment = .center
        lab.text = "你所在的城市"
        
        return lab
    }()
    /// address
    lazy var addressImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_icon_loca"))
        
        return imgView
    }()
    /// 选择当前城市按钮
    lazy var cityBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("选择当前城市", for: .normal)
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.backgroundColor = kWhiteColor
        btn.cornerRadius = 15
        btn.borderColor = kGrayLineColor
        btn.borderWidth = klineWidth
        btn.addTarget(self, action: #selector(clickedCityBtn), for: .touchUpInside)
        
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    /// 进入
    @objc func onClickRightBtn(){
        requestPerfectInfo()
    }
    
    /// 选择当前城市
    @objc func clickedCityBtn(){
        
        let vc = FSSelectCityVC()
        let cityNav = GYZBaseNavigationVC(rootViewController:vc)
        self.present(cityNav, animated: true, completion: nil)
    }
    /// 选择性别
    @objc func clickedCheckSex(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        if tag == 101 {// 女
            if !checkWomanImgView.isHighlighted{
                sex = "0"
                checkWomanImgView.isHighlighted = true
                checkManImgView.isHighlighted = false
            }
        }else{
            if !checkManImgView.isHighlighted{
                sex = "1"
                checkManImgView.isHighlighted = true
                checkWomanImgView.isHighlighted = false
            }
        }
    }
    
    ///登录注册时完善性别、城市等信息
    func requestPerfectInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        var params:[String: Any] = ["sex":sex]
        if currCityModel != nil {
            params["city"] = currCityModel?.name
        }
        GYZNetWork.requestNetwork("Member/Member/perfectInfo", parameters: params,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                KeyWindow.rootViewController = GYZMainTabBarVC()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///获取城市数据
    func requestAllCityList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("Home/ChinaArea/city",parameters: nil,  success: { (response) in
            
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                
                weakSelf?.cityModel = FSCityModel.init(dict: data)
                
                if weakSelf?.cityModel?.cityListDic.count > 0{
                    weakSelf?.locationManager.startUpdatingLocation()
                    weakSelf?.saveCityInfo(citys: (weakSelf?.cityModel)!)
                }
                
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
            
        })
    }
    
    ///保存城市信息
    func saveCityInfo(citys: FSCityModel){
        let model = NSKeyedArchiver.archivedData(withRootObject: citys)
        userDefaults.set(model, forKey: ALLCITYINFO)
    }
    ///本地获取城市信息
    func getCityInfo(){
         ///本地获取城市信息
        let model = userDefaults.data(forKey: ALLCITYINFO)
        if model != nil {

            locationManager.startUpdatingLocation()
            cityModel = NSKeyedUnarchiver.unarchiveObject(with: model!) as? FSCityModel
            
        }else{
            requestAllCityList()
        }
    }
}
extension FSSexInfoVC:AMapLocationManagerDelegate{
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode?) {
        NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy);};");
        
        if let reGeocode = reGeocode {
            locationManager.stopUpdatingLocation()
            NSLog("reGeocode:%@", reGeocode)
            if reGeocode.city != nil{
                findLocationCity(cityName: reGeocode.city)
                if currCityModel != nil {
                    cityBtn.setTitle(currCityModel?.name, for: .normal)
                }
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
        if cityName.isEmpty {
            return
        }
        let firstString : String = GYZTool.shareTool.findFirstLetterFromString(aString: cityName)
        if cityModel != nil {
            let cityList:[FSCityListModel] = (cityModel?.cityListDic[firstString])!
            for city in cityList {
                if city.name == cityName{
                    currCityModel = city
                    break
                }
            }
        }
    }
}
