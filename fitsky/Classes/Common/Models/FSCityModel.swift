//
//  FSCityModel.swift
//  fitsky
//  城市model
//  Created by gouyz on 2019/7/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSCityModel: LHSBaseModel,NSCoding {
    /// 城市索引
    var pinyinIndexArr : [String] = []
    var cityListDic:[String:[FSCityListModel]] = [String:[FSCityListModel]]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list"{
            guard let datas = value as? [String : Any] else { return }
            for key in datas.keys {
                guard let itemDatas = datas[key] as? [[String : Any]] else { continue }
                var cityArr: [FSCityListModel] = [FSCityListModel]()
                for item in itemDatas {
                    let model = FSCityListModel(dict: item)
                    cityArr.append(model)
                }
                cityListDic[key] = cityArr
            }
        }else if key == "first_pinyin"{
            guard let datas = value as? [String] else { return }
            for item in datas {
                pinyinIndexArr.append(item)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    override init(dict: [String : Any]) {
        super.init(dict: dict)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        pinyinIndexArr = aDecoder.decodeObject(forKey: "pinyinIndexArr") as? [String] ?? [String]()
        cityListDic = aDecoder.decodeObject(forKey: "cityListDic") as? [String:[FSCityListModel]] ?? [String:[FSCityListModel]]()
        
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(pinyinIndexArr, forKey:"pinyinIndexArr")
        aCoder.encode(cityListDic, forKey:"cityListDic")
        
    }
}
@objcMembers
class FSCityListModel: LHSBaseModel,NSCoding {
    /// 城市id
    var id : String? = ""
    /// 城市编号
    var code : String? = ""
    /// 城市名称
    var name : String? = ""
    /// 父id
    var pid : String? = ""
    /// 类型
    var type : String? = ""
    /// 城市拼音首字母
    var first_pinyin : String? = ""
    /// 城市拼音首字母缩写
    var short_pinyin : String? = ""
    /// 城市拼音全拼
    var full_pinyin : String? = ""
    /// 是否热门城市1是0否
    var is_hot : String? = ""
    var areaList:[FSCityListModel] = [FSCityListModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "child"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = FSCityListModel(dict: dict)
                areaList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    override init(dict: [String : Any]) {
        super.init(dict: dict)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        code = aDecoder.decodeObject(forKey: "code") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        pid = aDecoder.decodeObject(forKey: "pid") as? String ?? ""
        type = aDecoder.decodeObject(forKey: "type") as? String ?? ""
        first_pinyin = aDecoder.decodeObject(forKey: "first_pinyin") as? String ?? ""
        short_pinyin = aDecoder.decodeObject(forKey: "short_pinyin") as? String ?? ""
        full_pinyin = aDecoder.decodeObject(forKey: "full_pinyin") as? String ?? ""
        is_hot = aDecoder.decodeObject(forKey: "is_hot") as? String ?? ""
        areaList = aDecoder.decodeObject(forKey: "areaList") as? [FSCityListModel] ?? [FSCityListModel]()
       
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey:"id")
        aCoder.encode(code, forKey:"code")
        aCoder.encode(name, forKey:"name")
        aCoder.encode(pid, forKey:"pid")
        aCoder.encode(type, forKey:"type")
        aCoder.encode(first_pinyin, forKey:"first_pinyin")
        aCoder.encode(short_pinyin, forKey:"short_pinyin")
        aCoder.encode(full_pinyin, forKey:"full_pinyin")
        aCoder.encode(is_hot, forKey:"is_hot")
        aCoder.encode(areaList, forKey:"areaList")
    }
}
/// 区域model
@objcMembers
class FSAreaModel: LHSBaseModel,NSCoding {
    /// 用户id
    var id : String? = ""
    /// 城市编号
    var code : String? = ""
    /// 城市名称
    var name : String? = ""
    /// 父id
    var pid : String? = ""
    /// 类型
    var type : String? = ""
    /// 城市拼音首字母
    var first_pinyin : String? = ""
    /// 城市拼音首字母缩写
    var short_pinyin : String? = ""
    /// 城市拼音w全拼
    var full_pinyin : String? = ""
    /// 是否热门城市1是0否
    var is_hot : String? = ""
    
    override init(dict: [String : Any]) {
        super.init(dict: dict)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        code = aDecoder.decodeObject(forKey: "code") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        pid = aDecoder.decodeObject(forKey: "pid") as? String ?? ""
        type = aDecoder.decodeObject(forKey: "type") as? String ?? ""
        first_pinyin = aDecoder.decodeObject(forKey: "first_pinyin") as? String ?? ""
        short_pinyin = aDecoder.decodeObject(forKey: "short_pinyin") as? String ?? ""
        full_pinyin = aDecoder.decodeObject(forKey: "full_pinyin") as? String ?? ""
        is_hot = aDecoder.decodeObject(forKey: "is_hot") as? String ?? ""
        
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey:"id")
        aCoder.encode(code, forKey:"code")
        aCoder.encode(name, forKey:"name")
        aCoder.encode(pid, forKey:"pid")
        aCoder.encode(type, forKey:"type")
        aCoder.encode(first_pinyin, forKey:"first_pinyin")
        aCoder.encode(short_pinyin, forKey:"short_pinyin")
        aCoder.encode(full_pinyin, forKey:"full_pinyin")
        aCoder.encode(is_hot, forKey:"is_hot")
    }
}

