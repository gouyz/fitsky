//
//  FSIMCircleInitModel.swift
//  fitsky
//  申请加入社圈 初始化model
//  Created by gouyz on 2020/3/19.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSIMCircleInitModel: LHSBaseModel {
   
    /// 社圈信息
    var circleModel : FSIMCircleModel?
    var memberList:[FSIMCircleMemberModel] = [FSIMCircleMemberModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "admin_member"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSIMCircleMemberModel(dict: item)
                memberList.append(model)
            }
        }else if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            circleModel = FSIMCircleModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
