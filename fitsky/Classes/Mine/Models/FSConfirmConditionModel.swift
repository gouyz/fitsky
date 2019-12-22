//
//  FSConfirmConditionModel.swift
//  fitsky
//  申请认证条件 model
//  Created by gouyz on 2019/11/12.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSConfirmConditionModel: LHSBaseModel {
    
    /// 是否可以申请（0-否 1-是）
    var is_apply: String? = "0"
    /// 不能申请原因
    var no_apply_text: String? = ""
    /// 条件list
    var conditionList: [String] = [String]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            is_apply = "\(datas["is_apply"] as? Int ?? 0)"
            no_apply_text = datas["no_apply_text"] as? String
        }else if key == "list"{
            guard let datas = value as? [String] else { return }
            conditionList.removeAll()
            for item in datas {
                conditionList.append(item)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
