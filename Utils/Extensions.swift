import Foundation
import UIKit
import SwiftUI

extension UIImage {
    func jpegDataWithCompression(_ quality: CGFloat) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }
}
