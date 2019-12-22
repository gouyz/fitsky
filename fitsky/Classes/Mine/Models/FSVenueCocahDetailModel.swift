//
//  FSVenueCocahDetailModel.swift
//  fitsky
//  教练详情 model 
//  Created by gouyz on 2019/11/21.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSVenueCocahDetailModel: LHSBaseModel {

    /// 教练信息
    var coachData: FSCoachModel?
    /// 教练职称list
    var coachRankList: [FSCoachRankModel] = [FSCoachRankModel]()
    /// 教练职称名称list
    var coachRankNameList: [String] = [String]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "init_data"{
            guard let datas = value as? [String : Any] else { return }
            guard let rankdatas = datas["coach_rank"] as? [[String : Any]] else { return }
            for item in rankdatas {
                let model = FSCoachRankModel(dict: item)
                coachRankList.append(model)
                coachRankNameList.append(model.text!)
            }
        }else if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            coachData = FSCoachModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
/// 教练职称model
@objcMembers
class FSCoachRankModel: LHSBaseModel {
    /// id
    var value : String? = ""
    /// 名称
    var text : String? = ""
    
}
