//
//  FSTalkModel.swift
//  fitsky
//  话题 model
//  Created by gouyz on 2019/8/29.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSTalkModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 分类ID
    var category_id : String? = ""
    /// 标题
    var title : String? = ""
    /// 素材地址
    var material : String? = ""
    /// 内容
    var content : String? = ""
    /// 推荐（0-否 1-是）
    var is_recommend : String? = ""
    /// 位置
    var position : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 排序ID
    var sort_id : String? = ""
    /// 会员ID
    var member_id : String? = ""
    /// 昵称
    var nick_name : String? = ""
    /// 会员名
    var member_name : String? = ""
    /// 会员头像
    var avatar : String? = ""
    /// 来源（0-用户发布 1-管理员发布）
    var source : String? = ""
    /// 用户ID
    var user_id : String? = ""
    /// 用户名
    var user_name : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 更新时间
    var update_time : String? = ""
    ///创建者IP
    var ip : String? = ""
    /// 阅读次数
    var read_count : String? = "0"
    /// 阅读次数 5万阅读
    var read_count_text : String? = ""
    /// 分享次数
    var share_count : String? = "0"
    /// 评论次数
    var comment_count : String? = "0"
    /// 收藏数
    var collect_count : String? = "0"
    /// 点赞数
    var like_count : String? = "0"
    /// 动态数
    var dynamic_count : String? = "0"
    /// 动态数 1万讨论
    var dynamic_count_text : String? = ""
    /// 参与人数
    var member_count : String? = "0"
    /// 活跃度
    var activity_count : String? = "0"
    /// 热度数
    var hot_count : String? = "0"
    /// 热度数 热度1.99万
    var hot_count_text : String? = ""
    ///
    var _id : String? = ""
    /// 分类名称
    var category_id_text : String? = ""
    /// 很火（0-否 1-是）
    var is_hot : String? = ""
    /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
    var more_type : String? = ""
    ///  经度
    var lng : String? = ""
    /// 纬度
    var lat : String? = ""
    
    ///  
    var member_count_text : String? = ""
    /// 管理员（麦克风）0-否 1-是
    var is_admin : String? = ""
    ///  申请管理员（麦克风）0-否 1-是
    var is_apply_admin : String? = ""
    /// 创建话题 0-否 1-是
    var is_add_topic : String? = ""
    /// 缩略图
    var thumb : String? = ""
    /// 话题内容字数限制
    var content_limit : String? = ""
    /// 话题标题字数限制
    var title_limit : String? = ""
    /// 申请麦克风描述
    var applyMikeDesArr : [String] = [String]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apply_admin_text_array"{
            guard let datas = value as? [String] else { return }
            for item in datas {
                applyMikeDesArr.append(item)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
