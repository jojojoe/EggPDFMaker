//
//  WeScanCropManager.swift
//  PDfMaker
//
//  Created by JOJO on 2023/5/12.
//

import Foundation

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
