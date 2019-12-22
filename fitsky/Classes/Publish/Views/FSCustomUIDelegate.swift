//
//  FSCustomUIDelegate.swift
//  fitsky
//
//  Created by gouyz on 2019/9/2.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import DKImagePickerController

class FSCustomUIDelegate: DKImagePickerControllerBaseUIDelegate {
    
    override open func prepareLayout(_ imagePickerController: DKImagePickerController, vc: UIViewController) {
        super.prepareLayout(imagePickerController, vc: vc)
        self.imagePickerController = imagePickerController
    }
    
    open override func imagePickerControllerCollectionImageCell() -> DKAssetGroupDetailBaseCell.Type {
        return FSCustomGroupDetailImageCell.self
    }
    open override func imagePickerControllerCollectionVideoCell() -> DKAssetGroupDetailBaseCell.Type {
        return FSCustomGroupDetailVideoCell.self
    }
}
