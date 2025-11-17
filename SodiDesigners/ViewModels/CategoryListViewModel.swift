import Foundation

final class CategoryListViewModel: ObservableObject {
    @Published var categories: [CategoryModel] = []

    init() {
        loadCategories()
    }

    func loadCategories() {
        categories = MockData.sampleCategories
    }
}
