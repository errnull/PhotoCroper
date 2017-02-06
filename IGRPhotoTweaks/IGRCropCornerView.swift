//
//  IGRCropCornerView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

class IGRCropCornerView: UIView {

    init(cornerType type: CropCornerType) {
        super.init(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(kCropViewCornerLength), height: CGFloat(kCropViewCornerLength)))
        
        setup(cornerType: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup(cornerType: .upperRight)
    }
    
    fileprivate func setup(cornerType type: CropCornerType) {
        self.backgroundColor = UIColor.clear
        let lineWidth: CGFloat = 2
        let horizontal = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(kCropViewCornerLength), height: lineWidth))
        horizontal.backgroundColor = UIColor.cropLine()
        self.addSubview(horizontal)
        let vertical = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: lineWidth, height: CGFloat(kCropViewCornerLength)))
        vertical.backgroundColor = UIColor.cropLine()
        self.addSubview(vertical)
        
        if type == .upperLeft {
            horizontal.center = CGPoint(x: CGFloat(kCropViewCornerLength / 2), y: CGFloat(lineWidth / 2))
            vertical.center = CGPoint(x: CGFloat(lineWidth / 2), y: CGFloat(kCropViewCornerLength / 2))
        }
        else if type == .upperRight {
            horizontal.center = CGPoint(x: CGFloat(kCropViewCornerLength / 2), y: CGFloat(lineWidth / 2))
            vertical.center = CGPoint(x: CGFloat(kCropViewCornerLength - lineWidth / 2), y: CGFloat(kCropViewCornerLength / 2))
        }
        else if type == .lowerRight {
            horizontal.center = CGPoint(x: CGFloat(kCropViewCornerLength / 2), y: CGFloat(kCropViewCornerLength - lineWidth / 2))
            vertical.center = CGPoint(x: CGFloat(kCropViewCornerLength - lineWidth / 2), y: CGFloat(kCropViewCornerLength / 2))
        }
        else if type == .lowerLeft {
            horizontal.center = CGPoint(x: CGFloat(kCropViewCornerLength / 2), y: CGFloat(kCropViewCornerLength - lineWidth / 2))
            vertical.center = CGPoint(x: CGFloat(lineWidth / 2), y: CGFloat(kCropViewCornerLength / 2))
        }
    }
}