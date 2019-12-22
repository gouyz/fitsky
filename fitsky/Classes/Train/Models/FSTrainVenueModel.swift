//
//  FSTrainVenueModel.swift
//  fitsky
//  训练营 场馆model
//  Created by gouyz on 2019/11/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSTrainVenueModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 场馆类型|经营范围（1-健身 2-瑜伽 3-武术 4-休闲）
    var store_type : String? = ""
    /// 场馆名称
    var store_name : String? = ""
    /// 法人姓名
    var legal_person : String? = ""
    /// 联系电话
    var tel : String? = ""
    /// 邮箱
    var email : String? = ""
    /// 建馆时间
    var building_time : String? = ""
    /// 营业时间（开始）
    var business_stime : String? = ""
    /// 营业时间（结束）
    var business_etime : String? = ""
    /// 规模|面积（单位：㎡）
    var area : String? = ""
    /// 标签（多个用英文逗号隔开）数组
    var tags : [String] = [String]()
    /// 标签（多个用英文逗号隔开）数组
    var tags_text : String? = ""
    /// 省
    var province : String? = ""
    /// 市
    var city : String? = ""
    /// 区
    var county : String? = ""
    /// 区
    var address : String? = ""
    /// 简介
    var brief : String? = ""
    /// ID
    var unique_id : String? = ""
    /// 门店照
    var store_logo : String? = ""
    /// 门店照
    var thumb_store_logo : String? = ""
    /// 店内照
    var store_inside : String? = ""
    /// 身份证半身照
    var identity_card_half : String? = ""
    /// 身份证正面
    var identity_card_front : String? = ""
    /// 身份证反面'
    var identity_card_backend : String? = ""
    /// 营业执照
    var business_license : String? = ""
    /// 店铺关闭（0-否 1-是）
    var is_close : String? = "0"
    /// 关闭理由'
    var close_remark : String? = "0"
    /// 打回备注
    var remark : String? = ""
    /// 运营者姓名
    var operate_real_name : String? = ""
    /// 运营者手机
    var operate_mobile : String? = ""
    /// 发票电子邮箱
    var operate_email : String? = ""
    /// 场馆升级（0-否 1-是）
    var is_upgrade : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 排序ID
    var sort_id : String? = ""
    /// 用户id
    var user_id : String? = ""
    /// 用户名
    var user_name : String? = ""
    /// 添加时间
    var create_time : String? = ""
    /// ip
    var ip : String? = ""
    ///  经度
    var lng : String? = ""
    /// 纬度
    var lat : String? = ""
    /// 阅读次数
    var read_count : String? = "0"
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
    /// 学习人数
    var member_count : String? = "0"
    /// 购买数
    var buy_count : String? = "0"
    /// 更新时间
    var update_time : String? = ""
    /// 规模|面积（单位：㎡）如： 400㎡
    var area_text : String? = ""
    /// 12
    var more_type : String? = ""
    ///
    var display_create_time : String? = ""
    
    /// 新店入驻
    var hot_text : String? = ""
    /// 距离
    var distance: String? = ""
    /// 距离 1.5km
    var distance_text : String? = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "tags"{
            guard let datas = value as? [String] else { return }
            for item in datas {
                tags.append(item)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
