//
//  FSSquareHotModel.swift
//  fitsky
//  广场热门 model
//  Created by gouyz on 2019/8/28.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSSquareHotModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 类型（1-纯文字 2-图片+文字 3-视频+文字 4、作品 （纯文字） 5-作品（图片+文字）6-作品（视频+文字））
    var type : String? = ""
    /// 作品分类ID
    var category_id : String? = ""
    /// 图片地址
    var material : String? = ""
    /// 视频地址
    var video : String? = ""
    /// 视频封面图
    var video_thumb_url : String? = ""
    /// 视频封面图
    var video_material_url : String? = ""
    /// 视频url
    var video_url : String? = ""
    /// 内容（如果type=4,5,6时，表示作品标题）
    var content : String? = ""
    /// 话题ID
    var topic_id : String? = "0"
    /// 转发动态ID
    var content_id : String? = ""
    /// 转发（0-否 1-是）
    var is_forward : String? = ""
    /// 官方推荐（0-否 1-是）
    var is_official : String? = ""
    /// 推荐（0-否 1-是）
    var is_recommend : String? = ""
    /// 作品（0-否 1-是）
    var is_opus : String? = ""
    /// 场馆（0-否 1-是）
    var is_gym : String? = ""
    /// 置顶
    var is_top : String? = ""
    /// 话题动态置顶（0-否 1-是）
    var is_top_topic : String? = ""
    /// 公开类型（1-公开 2-好友圈 3-仅限自己）
    var open_type : String? = ""
    /// 经度
    var lng : String? = ""
    /// 纬度
    var lat : String? = ""
    /// 位置
    var position : String? = ""
    /// 地址
    var address : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 排序ID
    var sort_id : String? = ""
    /// 会员ID
    var member_id : String? = ""
    /// 会员名
    var member_name : String? = ""
    /// 昵称
    var nick_name : String? = ""
    /// 会员头像
    var avatar : String? = ""
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
    /// 举报数
    var report_count : String? = ""
    ///
    var _id : String? = ""
    ///
    var topic_id_text : String? = ""
    /// 会员类型（1-普通 2-达人 3-场馆）
    var member_type : String? = ""
    ///  热门动态显示位置（1-热门动态第一个位置 2-表示热门动态第二个位置）
    var display_location : String? = ""
    /// 缩略图
    var thumb : String? = ""
    /// 动态素材（图片|视频)列表
    var materialList : [FSDynamicMaterialModel] = [FSDynamicMaterialModel]()
    /// 动态素材（图片|视频)url列表
    var materialUrlList : [String] = [String]()
    /// 动态素材（图片|视频)原图url列表
    var materialOrgionUrlList : [String] = [String]()
    /// 动态素材数（图片数|视频数）
    var material_total : String? = ""
    ///
    var material_class : String? = ""
    /// 好友关系（0-未关注 1-已关注 2-相互关注 3-自己）
    var friend_type : String? = ""
    /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
    var more_type : String? = ""
    /// "06/04 15:45" 时间显示
    var display_create_time : String? = ""
    /// 是否点赞、收藏等
    var moreModel: FSDynamicMoreModel?
    /// 类型（1-图片 2-视频）相册里有返回字段
    var material_type : String? = ""
    /// 作品内容
    var opus_content : String? = ""
    /// 作品集ID
    var opus_category_id : String? = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "material_list"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSDynamicMaterialModel(dict: item)
                materialList.append(model)
                materialUrlList.append(model.thumb!)
                materialOrgionUrlList.append(model.material!)
            }
        }else if key == "more"{
            guard let datas = value as? [String : Any] else { return }
            moreModel = FSDynamicMoreModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 是否点赞、收藏等
@objcMembers
class FSDynamicMoreModel: LHSBaseModel {
    /// 点赞（0-否 1-是）
    var is_like : String? = ""
    /// 收藏（0-否 1-是）
    var is_collect : String? = ""
    /// 分享（0-否 1-是）
    var is_share : String? = ""
    /// 评论（0-否 1-是）
    var is_comment : String? = ""
}
