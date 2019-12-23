//
//  FSMineInfoModel.swift
//  fitsky
//
//  Created by gouyz on 2019/11/5.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSMineInfoModel: LHSBaseModel {
    /// 用户信息
    var infoData: FSUserInfoModel?
    /// 粉丝、关注、消息等数量
    var countData: FSMineCountModel?
    /// 打卡日期集合
    var punchList: [FSMinePunchModel] = [FSMinePunchModel]()
    /// 运动信息
    var supportData: FSMineSupportModel?
    /// 身体数量
    var bodyData: FSMineHealthModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "info"{
            guard let datas = value as? [String : Any] else { return }
            infoData = FSUserInfoModel(dict: datas)
        }else if key == "count"{
            guard let datas = value as? [String : Any] else { return }
            countData = FSMineCountModel(dict: datas)
        }else if key == "sport"{
            guard let datas = value as? [String : Any] else { return }
            supportData = FSMineSupportModel(dict: datas)
        }else if key == "health"{
            guard let datas = value as? [String : Any] else { return }
            bodyData = FSMineHealthModel(dict: datas)
        }else if key == "punch"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSMinePunchModel(dict: item)
                punchList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}


/// 我的 粉丝、关注、消息等数量
@objcMembers
class FSMineCountModel: LHSBaseModel {
    /// 关注数量
    var follow : String? = "0"
    /// 粉丝数量
    var fans : String? = "0"
    /// 消息数量
    var message : String? = "0"
    /// 收藏数
    var collect : String? = "0"
    /// 粉丝红点0不显示1显示
    var is_news_fans : String? = "0"
    
}
/// 我的 打卡日历
@objcMembers
class FSMinePunchModel: LHSBaseModel {
    /// 日期2019-09-11
    var date : String? = "0"
    /// 周几
    var week : String? = "0"
    /// 是否打卡
    var is_punch : String? = "0"
    
}
/// 我的 运动数据 model
@objcMembers
class FSMineSupportModel: LHSBaseModel {
    ///
    var id : String? = "0"
    /// 步数
    var step : String? = "0"
    /// 跑步（公里）
    var run : String? = "0"
    /// 健身（单位：秒 显示分钟）
    var fitness : String? = "0"
    /// 操课（单位：秒 显示分钟）
    var lesson : String? = "0"
    /// 瑜伽（单位：秒 显示分钟）
    var yoga : String? = "0"
    /// 理疗（单位：秒 显示分钟）
    var physiotherapy : String? = "0"
    /// 消耗（千卡）
    var consume : String? = "0"
    /// 累计天数
    var days : String? = "0"
    
}
/// 我的 身体数据 model
@objcMembers
class FSMineHealthModel: LHSBaseModel {
    ///
    var id : String? = "0"
    /// 身高cm
    var height : String? = "0"
    /// 体重kg
    var weight : String? = "0"
    /// BMI=体重(kg)/身高^2(m)，是衡量胖瘦的标准
    var bmi : String? = "0"
    /// 胸围
    var bust : String? = "0"
    /// 腰围
    var waistline : String? = "0"
    /// 臀围
    var hipline : String? = "0"
    /// 静息心率
    var resting_heart_rate : String? = "0"
    /// 最大息率
    var max_heart_rate : String? = "0"
    
    /// 身高cm
    var height_text : String? = "0"
    /// 体重kg
    var weight_text : String? = "0"
    /// BMI=体重(kg)/身高^2(m)，是衡量胖瘦的标准
    var bmi_text : String? = "0"
    /// 胸围
    var bust_text : String? = "0"
    /// 腰围
    var waistline_text : String? = "0"
    /// 臀围
    var hipline_text : String? = "0"
    /// 静息心率
    var resting_heart_rate_text : String? = "0"
    /// 最大息率
    var max_heart_rate_text : String? = "0"
}
