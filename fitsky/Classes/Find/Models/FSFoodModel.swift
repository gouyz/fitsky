//
//  FSFoodModel.swift
//  fitsky
//  食材model
//  Created by gouyz on 2019/11/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSFoodModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 标题
    var name : String? = ""
    /// 营养价值
    var autritive_value : String? = ""
    /// 热量
    var heat : String? = ""
    /// 碳水
    var carbon : String? = ""
    /// 蛋白质
    var protein : String? = ""
    /// 脂肪
    var fat : String? = ""
    /// 描述
    var desContent : String? = ""
    /// 做法步骤
    var unit_id : String? = ""
    /// 推荐（0-否 1-是）
    var is_recommend : String? = ""
    /// 用户ID
    var user_id : String? = ""
    /// 用户名
    var user_name : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 排序ID
    var sort_id : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 更新时间
    var update_time : String? = ""
    /// 创建者IP
    var ip : String? = ""
    /// 阅读次数
    var food_id : String? = "0"
    /// 数量
    var amount : String? = "0"
    /// 食材单位
    var unit_id_text : String? = "0"
    /// 热量 （kcal）
    var heat_text : String? = ""
    /// 碳水（g）
    var carbon_text : String? = ""
    /// 蛋白质（g）
    var protein_text : String? = ""
    /// 脂肪（g）
    var fat_text : String? = ""
    /// 营养价值（每100g可食用部分）
    var autritive_value_text : String? = ""
    /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
    var more_type : String? = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description"{
            super.setValue(value, forKey: "desContent")
        }else{
            super.setValue(value, forKey: key)
        }
    }
}
