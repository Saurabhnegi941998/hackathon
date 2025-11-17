import Foundation

struct CategoryModel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let imageURL: String
    let description: String
}
