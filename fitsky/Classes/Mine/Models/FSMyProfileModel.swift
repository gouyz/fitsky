//
//  FSMyProfileModel.swift
//  fitsky
//  我的资料model
//  Created by gouyz on 2019/11/7.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSMyProfileModel: LHSBaseModel {
    /// 用户信息
    var infoData: FSUserInfoModel?
    /// 性别选择list
    var sexList: [FSMineSexModel] = [FSMineSexModel]()
    /// 昵称字数限制
    var nick_name_limit : Int? = 10
    /// 个人简介字数限制
    var brief_limit : Int? = 20
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            infoData = FSUserInfoModel(dict: datas)
        }else if key == "init_data"{
            guard let datas = value as? [String : Any] else { return }
            guard let sexDatas = datas["sex"] as? [[String : Any]] else { return }
            for item in sexDatas {
                let model = FSMineSexModel(dict: item)
                sexList.append(model)
            }
            nick_name_limit = datas["nick_name_limit"] as? Int
            brief_limit = datas["brief_limit"] as? Int
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
/// 我的 性别model
@objcMembers
class FSMineSexModel: LHSBaseModel {
    /// 0女1男2保密
    var value : String? = "0"
    ///
    var text : String? = ""
    
}
