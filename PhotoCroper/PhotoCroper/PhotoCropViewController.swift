//
//  PhotoCroperViewController.swift
//  PhotoCroper
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit


public protocol PhotoCroperViewControllerDelegate : class {
    
    /**
     Called on image cropped.
     */
    func photoCropersController(_ controller: PhotoCroperViewController, didFinishWithCroppedImage croppedImage: UIImage)
    /**
     Called on cropping image canceled
     */
    
    func photoCropersControllerDidCancel(_ controller: PhotoCroperViewController)
}

open class PhotoCroperViewController: UIViewController {
    
    //MARK: - Public VARs
    
    /*
     Image to process.
     */
    public var image: UIImage!
    
    /*
     The optional photo tweaks controller delegate.
     */
    public weak var delegate: PhotoCroperViewControllerDelegate?
    
    //MARK: - Protected VARs
    
    /*
     Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to YES.
     */
    internal var isAutoSaveToLibray: Bool = false
    
    //MARK: - Private VARs
    
    internal lazy var photoView: PhotoCroperView! = { [unowned self] by in
        
        let photoView = PhotoCroperView(frame: self.view.bounds,
                                          image: self.image,
                                          customizationDelegate: self)
        photoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(photoView)
        
        return photoView
        }(())
    
    // MARK: - Life Cicle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        self.setupThemes()
        self.setupSubviews()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.photoView.applyDeviceRotation()
        })
    }
    
    fileprivate func setupSubviews() {
        self.view.sendSubview(toBack: self.photoView)
    }
    
    open func setupThemes() {
        PhotoCroperView.appearance().backgroundColor = UIColor.photoCroperCanvasBackground()
        PhotoCroperContentView.appearance().backgroundColor = UIColor.clear
        PhotoCropView.appearance().backgroundColor = UIColor.clear
        PhotoCropGridLine.appearance().backgroundColor = UIColor.gridLine()
        PhotoCropLine.appearance().backgroundColor = UIColor.cropLine()
        PhotoCropCornerView.appearance().backgroundColor = UIColor.clear
        PhotoCropCornerLine.appearance().backgroundColor = UIColor.cropLine()
        PhotoCropMaskView.appearance().backgroundColor = UIColor.mask()
    }
    
    // MARK: - Public
    
    public func resetView() {
        self.photoView.resetView()
        self.stopChangeAngle()
    }
    
    public func dismissAction() {
        self.delegate?.photoCropersControllerDidCancel(self)
    }
    
    public func cropAction() {
        var transform = CGAffineTransform.identity
        // translate
        let translation: CGPoint = self.photoView.photoTranslation
        transform = transform.translatedBy(x: translation.x, y: translation.y)
        // rotate
        transform = transform.rotated(by: self.photoView.angle)
        // scale
        
        let t: CGAffineTransform = self.photoView.photoContentView.transform
        let xScale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let yScale: CGFloat = sqrt(t.b * t.b + t.d * t.d)
        transform = transform.scaledBy(x: xScale, y: yScale)
        
        if let fixedImage = self.image.cgImageWithFixedOrientation() {
            let imageRef = fixedImage.transformedImage(transform,
                                                       sourceSize: self.image.size,
                                                       outputWidth: self.image.size.width,
                                                       cropSize: self.photoView.cropView.frame.size,
                                                       imageViewSize: self.photoView.photoContentView.bounds.size)
            
            let image = UIImage(cgImage: imageRef)
            
            if self.isAutoSaveToLibray {
                
                self.saveToLibrary(image: image)
            }
            
            self.delegate?.photoCropersController(self, didFinishWithCroppedImage: image)
        }
    }
    
    //MARK: - Customization
    
    open func customBorderColor() -> UIColor {
        return UIColor.cropLine()
    }
    
    open func customBorderWidth() -> CGFloat {
        return 1.0
    }
    
    open func customCornerBorderWidth() -> CGFloat {
        return kCropViewCornerWidth
    }
    
    open func customCornerBorderLength() -> CGFloat {
        return kCropViewCornerLength
    }
    
    open func customIsHighlightMask() -> Bool {
        return true
    }
    
    open func customHighlightMaskAlphaValue() -> CGFloat {
        return 0.3
    }
    
    open func customCanvasHeaderHeigth() -> CGFloat {
        return kCanvasHeaderHeigth
    }
}
