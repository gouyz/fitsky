//
//  FSIMCircleDetailModel.swift
//  fitsky
//
//  Created by gouyz on 2020/3/19.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSIMCircleDetailModel: LHSBaseModel {
    /// 昵称字数限制
    var circle_name_limit : Int? = 10
    /// 简介字数限制
    var circle_brief_limit : Int? = 120
    /// 社圈用户昵称限制字数
    var circle_nick_name_limit : Int? = 10
    /// 社圈公告字数限制
    var circle_notice_limit : Int? = 120
    /// 社圈信息
    var circleModel : FSIMCircleModel?
    /// 我的社圈信息
    var myCircleMemberModel : FSIMCircleMemberModel?
    /// 社圈成员（详情页目前显示9个）
    var memberList:[FSIMCircleMemberModel] = [FSIMCircleMemberModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "circle_member"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSIMCircleMemberModel(dict: item)
                memberList.append(model)
            }
        }else if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            circleModel = FSIMCircleModel(dict: datas)
        }else if key == "my_circle_member"{
            guard let datas = value as? [String : Any] else { return }
            myCircleMemberModel = FSIMCircleMemberModel(dict: datas)
        }else if key == "init_data"{
            guard let datas = value as? [String : Any] else { return }
            
            circle_name_limit = datas["circle_name_limit"] as? Int
            circle_brief_limit = datas["circle_brief_limit"] as? Int
            circle_nick_name_limit = datas["circle_nick_name_limit"] as? Int
            circle_notice_limit = datas["circle_notice_limit"] as? Int
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
