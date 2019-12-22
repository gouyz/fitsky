//
//  FSGoodsBuyModel.swift
//  fitsky
//  购买商品 model
//  Created by gouyz on 2019/9/20.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSGoodsBuyModel: LHSBaseModel {

    /// 课程内容
    var formData: FSVenueServiceModel?
    /// 教练总数
    var total : String? = "0"
    /// 教练列表
    var coachList: [FSCoachModel] = [FSCoachModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            formData = FSVenueServiceModel(dict: datas)
        }else if key == "list"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSCoachModel(dict: item)
                coachList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
