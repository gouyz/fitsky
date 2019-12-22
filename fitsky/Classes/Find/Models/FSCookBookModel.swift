//
//  FSCookBookModel.swift
//  fitsky
//  食谱model
//  Created by gouyz on 2019/11/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSCookBookModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 标题
    var title : String? = ""
    /// 索引图
    var material : String? = ""
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
    var content : String? = ""
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
    var read_count : String? = "0"
    /// 分享次数
    var share_count : String? = "0"
    /// 评论次数
    var comment_count : String? = "0"
    ///  收藏数
    var collect_count : String? = "0"
    /// 点赞数
    var like_count : String? = "0"
    ///
    var _id : String? = ""
    ///
    var category_id_text : String? = ""
    /// 饮食指南ID
    var category_id_1 : String? = ""
    ///  时段ID
    var category_id_2 : String? = ""
    /// 菜式ID
    var category_id_3 : String? = ""
    ///  类型ID
    var category_id_4 : String? = ""
    /// 缩略图
    var thumb : String? = ""
    /// 热量 （kcal）
    var heat_text : String? = ""
    /// 碳水（g）
    var carbon_text : String? = ""
    /// 蛋白质（g）
    var protein_text : String? = ""
    /// 脂肪（g）
    var fat_text : String? = ""
    /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
    var more_type : String? = ""
    /// "06/04 15:45" 时间显示
    var display_create_time : String? = ""
    /// 是否点赞、收藏等
    var moreModel: FSDynamicMoreModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "more"{
            guard let datas = value as? [String : Any] else { return }
            moreModel = FSDynamicMoreModel(dict: datas)
        }else {
            if key == "description"{
                super.setValue(value, forKey: "desContent")
            }else{
                super.setValue(value, forKey: key)
            }
        }
    }
}
