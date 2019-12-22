//
//  FSDynamicDetailModel.swift
//  fitsky
//  动态详情 model
//  Created by gouyz on 2019/8/29.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSDynamicDetailModel: LHSBaseModel {

    var formData: FSSquareHotModel?
    /// 动态素材（图片|视频)列表
    var materialList : [FSDynamicMaterialModel] = [FSDynamicMaterialModel]()
    /// 动态素材（图片|视频)url列表
    var materialUrlList : [String] = [String]()
    /// 动态素材（图片|视频)原图url列表
    var materialOrgionUrlList : [String] = [String]()
    /// 阅读次数
    var material_total : String? = ""
    /// 分享次数
    var material_class : String? = ""
    /// 是否点赞、收藏等
    var moreModel: FSDynamicMoreModel?
    /// 评论list
    var conmentList:[FSConmentModel] = [FSConmentModel]()
    /// 分享model
    var sharedModel : FSSharedModel?
    /// 点赞、收藏、评论等数量
    var countModel: FSDynamicCountModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "material_list"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSDynamicMaterialModel(dict: item)
                materialList.append(model)
                materialUrlList.append(model.thumb!)
                materialOrgionUrlList.append(model.material!)
            }
        }else if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            formData = FSSquareHotModel(dict: datas)
        }else if key == "more"{
            guard let datas = value as? [String : Any] else { return }
            moreModel = FSDynamicMoreModel(dict: datas)
        }else if key == "comment"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSConmentModel(dict: item)
                conmentList.append(model)
            }
        }else if key == "count"{
            guard let datas = value as? [String : Any] else { return }
            countModel = FSDynamicCountModel(dict: datas)
        }else if key == "share"{
            guard let datas = value as? [String : Any] else { return }
            sharedModel = FSSharedModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 点赞、收藏、评论等数量
@objcMembers
class FSDynamicCountModel: LHSBaseModel {
    /// 动态ID
    var id : String? = ""
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
    /// 举报数
    var report_count : String? = "0"
    /// 回复数
    var reply_count : String? = "0"
    
    /// 动态数
    var dynamic_count : String? = "0"
    /// 学习人数
    var member_count : String? = "0"
    /// 购买数
    var buy_count : String? = "0"
    
    /// 活动报名人数
    var apply_count : String? = "0"
}
