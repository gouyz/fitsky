//
//  FSVenueServiceModel.swift
//  fitsky
//  场馆服务 model
//  Created by gouyz on 2019/9/16.
//  Copyright © 2019 gyz. All rights reserved.
//  

import UIKit

@objcMembers
class FSVenueServiceModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 场馆ID
    var store_id : String? = ""
    /// 分类ID
    var category_id : String? = ""
    /// 服务名称
    var goods_name : String? = ""
    /// 图片地址
    var material : String? = ""
    /// 视频地址
    var video : String? = ""
    /// 视频时长（单位：秒）
    var video_duration : String? = "0"
    /// 视频时长（单位：分钟）60分钟
    var video_duration_text : String? = ""
    /// 原价（元）
    var original_price : String? = "0"
    /// 价格（元）
    var price : String? = "0"
    /// 难度（1-零基础 2-入门级 3-中级 4-高级 5-加强版）
    var difficulty : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 排序id
    var sort_id : String? = ""
    /// 用户ID
    var user_id : String? = ""
    /// 用户名
    var user_name : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 更新时间
    var update_time : String? = ""
    /// 创建者IP
    var ip : String? = ""
    /// 阅读次数
    var read_count : String? = ""
    /// 分享次数
    var share_count : String? = ""
    /// 评论次数
    var comment_count : String? = ""
    ///  收藏数
    var collect_count : String? = ""
    /// 点赞数
    var like_count : String? = ""
    /// 动态数
    var dynamic_count : String? = "0"
    /// 学习人数
    var member_count : String? = "0"
    /// 购买数
    var buy_count : String? = "0"
    ///
    var _id : String? = ""
    /// 缩略图
    var thumb : String? = ""
    /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
    var more_type : String? = ""
    /// "06/04 15:45" 时间显示
    var display_create_time : String? = ""
    /// 难度文本说明 中级
    var difficulty_text : String? = ""
    /// 课程介绍
    var content : String? = ""
    /// 适用人群
    var for_people : String? = ""
    /// 课程须知
    var notes : String? = ""
    /// 客服电话
    var tel : String? = ""
    
    /// 简介
    var brief : String? = ""
    ///
    var store_name : String? = ""
    ///
    var store_id_text : String? = ""
    /// 是否可以购买（0-否 1-是）
    var is_may_buy : String? = ""
    /// 不可以购买原因（当is_may_buy == 0 时 toast提示用户）
    var is_may_buy_msg : String? = ""
}
