import Foundation
import UIKit

struct Expense: Identifiable, Codable {
    var id = UUID()
    var title: String
    var amount: Double
    var category: String
    var date: Date
    var receiptImageData: Data?
    
    init(title: String, amount: Double, category: String, date: Date, receiptImage: UIImage? = nil) {
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
        if let receiptImage = receiptImage {
            self.receiptImageData = receiptImage.jpegData(compressionQuality: 0.8)
        }
    }
    
    var receiptImage: UIImage? {
        if let imageData = receiptImageData {
            return UIImage(data: imageData)
        }
        return nil
    }
}
