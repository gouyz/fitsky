//
//  FSFindCourseModel.swift
//  fitsky
//  发现运动课程 model
//  Created by gouyz on 2019/11/25.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSFindCourseModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 课程类型（1-课程主题 2-部位强化）
    var course_type : String? = ""
    /// 分类ID（1-课程主题【课程分类ID】 2-部位强化【部位强化分类ID】
    var category_id : String? = ""
    /// 索引图
    var material : String? = ""
    /// 视频地址
    var video : String? = ""
    /// 时长（秒）
    var video_duration : String? = ""
    /// 课程名称
    var name : String? = ""
    /// 卡里路（千卡）
    var calorie : String? = ""
    /// 简介
    var brief : String? = ""
    /// 描述
    var desContent : String? = ""
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
    /// 播放次数
    var play_count : String? = "0"
    /// 学习人数
    var member_count : String? = "0"
    ///
    var _id : String? = ""
    ///
    var category_id_text : String? = ""
    /// 排序
    var attr_id_1 : String? = ""
    ///  目标
    var attr_id_2 : String? = ""
    /// 难度
    var attr_id_3 : String? = ""
    ///  部位
    var attr_id_4 : String? = ""
    /// 场景
    var attr_id_5 : String? = ""
    ///  流派
    var attr_id_6 : String? = ""
    /// 风格
    var attr_id_7 : String? = ""
    /// 缩略图
    var thumb : String? = ""
    /// 
    var video_duration_text : String? = ""
    ///
    var attr_id_3_text : String? = ""
    /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
    var more_type : String? = ""
    /// "06/04 15:45" 时间显示
    var display_create_time : String? = ""
    /// 是否点赞、收藏等
    var moreModel: FSDynamicMoreModel?
    
    ///  课程介绍
    var content : String? = ""
    /// 建议周期
    var proposed_cycle : String? = ""
    ///  课程特色
    var course_features : String? = ""
    /// 注意事项
    var precautions : String? = ""
    
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
