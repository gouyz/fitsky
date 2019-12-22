//
//  FSSquareUserModel.swift
//  fitsky
//  广场搜索用户 model
//  Created by gouyz on 2019/8/29.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSSquareUserModel: LHSBaseModel {
    
    /// 普通用户信息
    var formData: FSUserInfoModel?
    /// 场馆信息
    var storeData: FSStoreInfoModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            formData = FSUserInfoModel(dict: datas)
        }else if key == "store"{
            guard let datas = value as? [String : Any] else { return }
            storeData = FSStoreInfoModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 普通用户信息 model
@objcMembers
class FSUserInfoModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 会员名
    var member_name : String? = ""
    /// 手机号
    var mobile : String? = ""
    /// 邮箱
    var email : String? = ""
    /// 绑定手机（0-否 1-是）
    var is_mobile : String? = ""
    /// 状态（0-禁用 1-正常 2-删除
    var status : String? = ""
    /// 注册时间
    var register_time : String? = ""
    /// 注册IP
    var register_ip : String? = ""
    /// 最后一次登录时间
    var last_login_time : String? = ""
    /// 最后一次登录IP
    var last_login_ip : String? = ""
    /// 头像
    var avatar : String? = ""
    /// 昵称
    var nick_name : String? = ""
    /// 性别（0-女 1-男 2-保密）
    var sex : String? = ""
    /// 生日
    var birthday : String? = ""
    /// 省
    var province : String? = ""
    /// 市
    var city : String? = ""
    /// 区
    var county : String? = ""
    /// 个人简介
    var brief : String? = ""
    /// ID
    var unique_id : String? = ""
    /// 二维码
    var qrcode : String? = ""
    /// 关注数
    var follow : String? = "0"
    /// 粉丝数
    var fans : String? = "0"
    /// 打卡数
    var punch : String? = "0"
    /// 拉黑别人数
    var from_black : String? = "0"
    /// 被人拉黑数
    var to_black : String? = "0"
    /// 达人（0-否 1-是）
    var is_daren : String? = ""
    /// 私教（0-否 1-是）
    var is_coach : String? = ""
    /// 场馆（0-否 1-是）
    var is_gym : String? = ""
    /// 社长（0-否 1-是）
    var is_sz : String? = ""
    /// 推荐（0-否 1-是）
    var is_recommend : String? = ""
    /// 上次type值（1-普通 2-达人 3-场馆）
    var prev_type : String? = ""
    /// 会员类型（1-普通 2-达人 3-场馆）
    var type : String? = ""
    ///  经度
    var lng : String? = ""
    /// 纬度
    var lat : String? = ""
    /// 更新时间
    var update_time : String? = ""
    ///会员ID
    var member_id : String? = ""
    /// 好友关系（0-未关注 1-已关注 2-相互关注 3-自己）
    var friend_type : String? = ""
    ///
    var type_text : String? = ""
    
    /// 注册日期
    var register_date : String? = ""
    /// 性别
    var sex_text : String? = ""
}
/// 场馆信息 model
@objcMembers
class FSStoreInfoModel: LHSBaseModel {
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
    var tagsText : [String] = [String]()
    /// 标签（多个用英文逗号隔开）数组
    var tags : String? = ""
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
    var store_logo_thumb : String? = ""
    /// 店内照
    var store_inside_thumb : String? = ""
    /// 身份证半身照
    var identity_card_half_thumb : String? = ""
    /// 身份证正面
    var identity_card_front_thumb : String? = "0"
    /// 身份证反面'
    var identity_card_backend_thumb : String? = "0"
    /// 营业执照
    var business_license_thumb : String? = "0"
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
    /// 更新时间
    var update_time : String? = ""
    /// 规模|面积（单位：㎡）如： 400㎡
    var area_text : String? = ""
    /// 12
    var more_type : String? = ""
    ///
    var display_create_time : String? = ""
    
    /// 场馆详情
    var content : String? = ""
    
    /// 类型
    var store_type_text : String? = ""
    /// 动态素材（图片|视频)列表
    var materialList : [FSStoreMaterialModel] = [FSStoreMaterialModel]()
    /// 动态素材（图片|视频)url列表
    var materialUrlList : [String] = [String]()
    /// 动态素材（图片|视频)原图url列表
    var materialOrgionUrlList : [String] = [String]()
    /// 分类
    var catrgoryList: [FSCompainCategoryModel] = [FSCompainCategoryModel]()
    var catrgoryNameList: [String] = [String]()
    /// 点赞、收藏、评论等数量
    var countModel: FSDynamicCountModel?
    
    /// 视频封面图
    var video_thumb_url : String? = ""
    /// 视频封面图
    var video_material_url : String? = ""
    /// 视频地址
    var video : String? = ""
    /// 视频时长
    var video_duration : String? = ""
    ///
    var video_duration_text : String? = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "material_list"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSStoreMaterialModel(dict: item)
                materialList.append(model)
                materialUrlList.append(model.thumb!)
                materialOrgionUrlList.append(model.material!)
            }
        }else if key == "tags_text"{
            guard let datas = value as? [String] else { return }
            for item in datas {
                tagsText.append(item)
            }
        }else if key == "count"{
            guard let datas = value as? [String : Any] else { return }
            countModel = FSDynamicCountModel(dict: datas)
        }else if key == "goods_category"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSCompainCategoryModel(dict: item)
                catrgoryList.append(model)
                catrgoryNameList.append(model.name!)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 场馆图片model
@objcMembers
class FSStoreMaterialModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 场馆ID
    var store_id : String? = ""
    /// 主图（0-否 1-是）
    var is_main : String? = ""
    /// 素材地址
    var material : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 排序ID
    var sort_id : String? = ""
    /// 用户id
    var user_id : String? = ""
    /// 用户名
    var user_name : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 缩略图
    var update_time : String? = ""
    /// 创建时间
    var ip : String? = ""
    /// 缩略图
    var thumb : String? = ""
}
