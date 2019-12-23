//
//  FSBannerModel.swift
//  fitsky
//  轮播图model
//  Created by gouyz on 2019/11/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSBannerModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 位置ID
    var position_id : String? = ""
    /// 类型（1-作品 2-活动 3-场馆 4-服务课程 5-课程 6-器械 7-饮食 8-外链）
    var type : String? = ""
    /// 内容ID（对应type类型跳转到对应模块详情页）
    var content_id : String? = "0"
    /// 标题
    var title : String? = ""
    /// 索引图
    var material : String? = ""
    /// 链接地址（type=8 时有值）用APP浏览器打开
    var link : String? = ""
    /// 开始时间
    var stime : String? = ""
    /// 结束时间
    var etime : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 排序ID
    var sort_id : String? = ""
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
    ///
    var type_text: String? = ""
    ///
    var thumb : String? = "0"
}
