//
//  FSConmentModel.swift
//  fitsky
//  评论model
//  Created by gouyz on 2019/8/29.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSConmentModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 父级ID
    var parent_id : String? = ""
    /// 内容ID
    var content_id : String? = ""
    /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论）
    var type : String? = ""
    /// 索引图
    var material : String? = ""
    /// 内容
    var content : String? = ""
    /// 会员ID
    var member_id : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 排序ID
    var sort_id : String? = ""
    /// 回复数
    var reply_count : String? = "0"
    /// 用户名称
    var member_name : String? = ""
    /// 昵称
    var nick_name : String? = ""
    /// 会员头像
    var avatar : String? = ""
    /// 会员类型（1-普通 2-达人 3-场馆）
    var member_type : String? = ""
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
    /// 举报数
    var report_count : String? = "0"
    ///
    var _id : String? = ""
    /// 缩略图
    var thumb : String? = ""
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
            super.setValue(value, forKey: key)
        }
    }
}

/// 评论详情
@objcMembers
class FSConmentDetailModel: LHSBaseModel {
    
    var formData: FSConmentModel?
    /// 点赞、收藏、评论等数量
    var countModel: FSDynamicCountModel?
    /// 是否点赞、收藏等
    var moreModel: FSDynamicMoreModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            formData = FSConmentModel(dict: datas)
        }else if key == "more"{
            guard let datas = value as? [String : Any] else { return }
            moreModel = FSDynamicMoreModel(dict: datas)
        }else if key == "count"{
            guard let datas = value as? [String : Any] else { return }
            countModel = FSDynamicCountModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
