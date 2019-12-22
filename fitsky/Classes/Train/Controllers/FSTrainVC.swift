//
//  FSTrainVC.swift
//  fitsky
//  训练营
//  Created by gouyz on 2019/8/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView

class FSTrainVC: GYZWhiteNavBaseVC {
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    let titles = ["健身", "瑜伽", "武术", "休闲"]
    
    /// 高德地图定位
    let locationManager: AMapLocationManager = AMapLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor
        self.navigationItem.titleView = segmentedView
        
        initLocation()
        self.view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        segmentedView.contentScrollView = listContainerView.scrollView
        
    }
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    lazy var segmentedView: JXSegmentedView = {
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleNormalColor = kHeightGaryFontColor
        segmentedViewDataSource.titleSelectedColor = kOrangeFontColor
        segmentedViewDataSource.titleNormalFont = UIFont.boldSystemFont(ofSize: 16)
        segmentedViewDataSource.titleSelectedFont = UIFont.boldSystemFont(ofSize: 16)
        segmentedViewDataSource.titles = titles
        //reloadData(selectedIndex:)一定要调用
        segmentedViewDataSource.reloadData(selectedIndex: 0)
        //配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorColor = kOrangeFontColor
        
        let segView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kTitleHeight))
        segView.delegate = self
        segView.backgroundColor = kWhiteColor
        segView.dataSource = segmentedViewDataSource
        segView.indicators = [indicator]
        
        return segView
    }()
    
    /// 初始化高德地图定位
    func initLocation(){
        locationManager.delegate = self
        /// 设置定位最小更新距离
        locationManager.distanceFilter = 200
        locationManager.locatingWithReGeocode = true
        locationManager.startUpdatingLocation()
    }
}

extension FSTrainVC:AMapLocationManagerDelegate{
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode?) {
        NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy);};");
        
        // 存储定位经纬度
        userDefaults.set(location.coordinate.latitude, forKey: CURRlatitude)
        userDefaults.set(location.coordinate.longitude, forKey: CURRlongitude)
        locationManager.stopUpdatingLocation()
        if let reGeocode = reGeocode {
            //            locationManager.stopUpdatingLocation()
            NSLog("reGeocode:%@", reGeocode)
        }
    }
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        
    }
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        GYZLog(error)
    }
    
}
extension FSTrainVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedViewDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        let vc = FSTrainListVC()
        vc.naviController = self.navigationController
        vc.type = index
        return vc
    }
}

extension FSTrainVC: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        //传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        //传递scrollingFrom事件给listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}
