//
//  WeScanCropManager.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/12.
//

import Foundation
import UIKit

class WeScanCropManager: NSObject {
    static let `default` = WeScanCropManager()
    
    func detect(image: UIImage, completion: @escaping (Quadrilateral?) -> Void) {
        // Whether or not we detect a quad, present the edit view controller after attempting to detect a quad.
        // *** Vision *requires* a completion block to detect rectangles, but it's instant.
        // *** When using Vision, we'll present the normal edit view controller first, then present the updated edit view controller later.

        guard let ciImage = CIImage(image: image) else { return }
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(orientation.rawValue))

        
        // Use the VisionRectangleDetector on iOS 11 to attempt to find a rectangle from the initial image.
        VisionRectangleDetector.rectangle(forImage: ciImage, orientation: orientation) { quad in
            let detectedQuad = quad?.toCartesian(withHeight: orientedImage.extent.height)
            completion(detectedQuad)
        }
        
    }
    
    func defaultQuad(forImage image: UIImage) -> Quadrilateral {
        let topLeft = CGPoint(x: image.size.width * 0.0, y: image.size.height * 0.0)
        let topRight = CGPoint(x: image.size.width * 1.0, y: image.size.height * 0.0)
        let bottomRight = CGPoint(x: image.size.width * 1.0, y: image.size.height * 1.0)
        let bottomLeft = CGPoint(x: image.size.width * 0.0, y: image.size.height * 1.0)

        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)

        return quad
    }
    
    func defaultQuad11(forImage image: UIImage) -> Quadrilateral {
        let minlenght: CGFloat = min(image.size.width, image.size.height)
        let topoffx: CGFloat = (image.size.width - minlenght) / 2
        let topoffy: CGFloat = (image.size.height - minlenght) / 2
        
        
        let topLeft = CGPoint(x: topoffx, y: topoffy)
        let topRight = CGPoint(x: image.size.width - topoffx, y: topoffy)
        let bottomRight = CGPoint(x: image.size.width - topoffx, y: image.size.height - topoffy)
        let bottomLeft = CGPoint(x: topoffx, y: image.size.height - topoffy)

        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)

        return quad
    }
    
    func defaultQuad23(forImage image: UIImage) -> Quadrilateral {
        
        var topoffx: CGFloat = image.size.width
        var topoffy: CGFloat = image.size.height
        
        let ratio: CGFloat = 2.0/3.0
        if (image.size.width / image.size.height) < ratio {
            let width: CGFloat = image.size.width
            let heigh: CGFloat = image.size.width / ratio
            topoffx = 0
            topoffy = (image.size.height - heigh) / 2
        } else {
            let heigh: CGFloat = image.size.height
            let width: CGFloat = image.size.height * ratio
            topoffx = (image.size.width - width) / 2
            topoffy = 0
        }
        
        let topLeft = CGPoint(x: topoffx, y: topoffy)
        let topRight = CGPoint(x: image.size.width - topoffx, y: topoffy)
        let bottomRight = CGPoint(x: image.size.width - topoffx, y: image.size.height - topoffy)
        let bottomLeft = CGPoint(x: topoffx, y: image.size.height - topoffy)

        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)

        return quad
    }
    
    func defaultQuad34(forImage image: UIImage) -> Quadrilateral {
        var topoffx: CGFloat = image.size.width
        var topoffy: CGFloat = image.size.height
        
        let ratio: CGFloat = 3.0/4.0
        if (image.size.width / image.size.height) < ratio {
            let width: CGFloat = image.size.width
            let heigh: CGFloat = image.size.width / ratio
            topoffx = 0
            topoffy = (image.size.height - heigh) / 2
        } else {
            let heigh: CGFloat = image.size.height
            let width: CGFloat = image.size.height * ratio
            topoffx = (image.size.width - width) / 2
            topoffy = 0
        }
        
        let topLeft = CGPoint(x: topoffx, y: topoffy)
        let topRight = CGPoint(x: image.size.width - topoffx, y: topoffy)
        let bottomRight = CGPoint(x: image.size.width - topoffx, y: image.size.height - topoffy)
        let bottomLeft = CGPoint(x: topoffx, y: image.size.height - topoffy)

        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)

        return quad
    }
    func defaultQuad00(forImage image: UIImage) -> Quadrilateral {
        let topLeft = CGPoint(x: image.size.width * 0.05, y: image.size.height * 0.05)
        let topRight = CGPoint(x: image.size.width * 0.95, y: image.size.height * 0.05)
        let bottomRight = CGPoint(x: image.size.width * 0.95, y: image.size.height * 0.95)
        let bottomLeft = CGPoint(x: image.size.width * 0.05, y: image.size.height * 0.95)

        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)

        return quad
    }
    
}


//public struct ImageScannerScan {
//    public enum ImageScannerError: Error {
//        case failedToGeneratePDF
//    }
//
//    public var image: UIImage
//
//    public func generatePDFData(completion: @escaping (Result<Data, ImageScannerError>) -> Void) {
//        DispatchQueue.global(qos: .userInteractive).async {
//            if let pdfData = self.image.pdfData() {
//                completion(.success(pdfData))
//            } else {
//                completion(.failure(.failedToGeneratePDF))
//            }
//        }
//
//    }
//
//    mutating func rotate(by rotationAngle: Measurement<UnitAngle>) {
//        guard rotationAngle.value != 0, rotationAngle.value != 360 else { return }
//        image = image.rotated(by: rotationAngle) ?? image
//    }
//}
//
//public struct ImageScannerResults {
//
//    /// The original scan taken by the user, prior to the cropping applied by WeScan.
//    public var originalScan: ImageScannerScan
//
//    /// The deskewed and cropped scan using the detected rectangle, without any filters.
//    public var croppedScan: ImageScannerScan
//
//    /// The enhanced scan, passed through an Adaptive Thresholding function.
//    /// This image will always be grayscale and may not always be available.
//    public var enhancedScan: ImageScannerScan?
//
//    /// Whether the user selected the enhanced scan or not.
//    /// The `enhancedScan` may still be available even if it has not been selected by the user.
//    public var doesUserPreferEnhancedScan: Bool
//
//    /// The detected rectangle which was used to generate the `scannedImage`.
//    public var detectedRectangle: Quadrilateral
//
//    @available(*, unavailable, renamed: "originalScan")
//    public var originalImage: UIImage?
//
//    @available(*, unavailable, renamed: "croppedScan")
//    public var scannedImage: UIImage?
//
//    @available(*, unavailable, renamed: "enhancedScan")
//    public var enhancedImage: UIImage?
//
//    @available(*, unavailable, renamed: "doesUserPreferEnhancedScan")
//    public var doesUserPreferEnhancedImage = false
//
//    init(
//        detectedRectangle: Quadrilateral,
//        originalScan: ImageScannerScan,
//        croppedScan: ImageScannerScan,
//        enhancedScan: ImageScannerScan?,
//        doesUserPreferEnhancedScan: Bool = false
//    ) {
//        self.detectedRectangle = detectedRectangle
//
//        self.originalScan = originalScan
//        self.croppedScan = croppedScan
//        self.enhancedScan = enhancedScan
//
//        self.doesUserPreferEnhancedScan = doesUserPreferEnhancedScan
//    }
//}
