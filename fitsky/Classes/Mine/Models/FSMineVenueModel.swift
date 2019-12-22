//
//  FSMineVenueModel.swift
//  fitsky
//  场馆我的 model
//  Created by gouyz on 2019/11/19.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSMineVenueModel: LHSBaseModel {

    /// 场馆信息
    var storeData: FSStoreInfoModel?
    /// 场馆名称长度限制数
    var store_name_limit: Int? = 10
    /// 场馆简介长度限制数
    var store_brief_limit: Int? = 20
    /// 邮箱长度限制数
    var store_email_limit: Int? = 32
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "init_data"{
            guard let datas = value as? [String : Any] else { return }
            store_name_limit = datas["store_name_limit"] as? Int
            store_brief_limit = datas["store_brief_limit"] as? Int
            store_email_limit = datas["store_email_limit"] as? Int
        }else if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            storeData = FSStoreInfoModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
