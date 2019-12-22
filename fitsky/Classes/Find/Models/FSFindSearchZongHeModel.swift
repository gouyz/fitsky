//
//  FSFindSearchZongHeModel.swift
//  fitsky
//  搜索综合 model
//  Created by gouyz on 2019/11/28.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSFindSearchZongHeModel: LHSBaseModel {

    /// 资讯列表
    var newslList: [FSSquareHotModel] = [FSSquareHotModel]()
    /// 课程列表
    var courselList: [FSFindCourseModel] = [FSFindCourseModel]()
    /// 食谱列表
    var cookbooklList: [FSCookBookModel] = [FSCookBookModel]()
    /// 器材列表
    var instrumentlList: [FSFindCourseModel] = [FSFindCourseModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "news"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSSquareHotModel(dict: item)
                newslList.append(model)
            }
        }else if key == "course"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSFindCourseModel(dict: item)
                courselList.append(model)
            }
        }else if key == "cookbook"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSCookBookModel(dict: item)
                cookbooklList.append(model)
            }
        }else if key == "instrument"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSFindCourseModel(dict: item)
                instrumentlList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
}
