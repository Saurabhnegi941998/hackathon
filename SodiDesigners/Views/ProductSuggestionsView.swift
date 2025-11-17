import SwiftUI

struct ProductSuggestionsView: View {
    var selectedCategory: CategoryModel
    @Environment(\.dismiss) private var dismiss
    @State private var showResult = false
    @State private var selectedTVID: UUID? = nil // Track selected TV
    @State private var selectedLampID: UUID? = nil // Track selected Lamp
    // Dummy product data
    struct Product: Identifiable {
        let id = UUID()
        let name: String
        let price: String
        let imageName: String
    }
    let tvs: [Product] = [
        Product(name: "Samsung 55\" 4K Smart TV", price: "$699", imageName: "photo"),
        Product(name: "LG 65\" OLED TV", price: "$1,299", imageName: "photo"),
        Product(name: "Sony 50\" LED TV", price: "$899", imageName: "photo"),
        Product(name: "Panasonic 60\" UHD TV", price: "$1,099", imageName: "photo"),
        Product(name: "Philips 55\" Smart TV", price: "$799", imageName: "photo"),
        Product(name: "TCL 65\" QLED TV", price: "$1,399", imageName: "photo")
    ]
    let lamps: [Product] = [
        Product(name: "Modern Desk Lamp", price: "$89", imageName: "photo"),
        Product(name: "LED Floor Lamp", price: "$129", imageName: "photo"),
        Product(name: "Classic Table Lamp", price: "$59", imageName: "photo"),
        Product(name: "Smart Night Lamp", price: "$49", imageName: "photo"),
        Product(name: "Minimalist Lamp", price: "$99", imageName: "photo"),
        Product(name: "Decorative Lamp", price: "$119", imageName: "photo")
    ]
    var body: some View {
        VStack(spacing: 0) {
            SodiDesignersHeader(onBack: { dismiss() })
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Product Suggestions")
                            .font(.system(size: 22, weight: .semibold))
                            .padding(.top, 24)
                        HStack(spacing: 0) {
                            Text("Select products for your ")
                                .foregroundColor(Color(.label).opacity(0.7))
                            Text(selectedCategory.name)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.label))
                        }
                        .font(.system(size: 16))
                        .padding(.top, 2)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 18)
                    // TVs Section
                    ProductSectionView(title: "TVs", products: tvs, selectedProductID: $selectedTVID)
                    // Lamps Section
                    ProductSectionView(title: "Lamps", products: lamps, selectedProductID: $selectedLampID)
                }
            }
            .background(Color(.systemGroupedBackground))
            VStack {
                Button(action: { showResult = true }) {
                    HStack {
                        Image(systemName: "eye")
                            .font(.system(size: 20, weight: .semibold))
                        Text("Visualize")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(Color("AppBlue"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("AppBlue"), lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                }
            }
            NavigationLink(destination: DesignResultView(), isActive: $showResult) { EmptyView() }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
    }
}

struct ProductSectionView: View {
    let title: String
    let products: [ProductSuggestionsView.Product]
    @Binding var selectedProductID: UUID?
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal, 24)
                .padding(.top, 8)
            Text("Swipe to browse")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(products) { product in
                        ProductCardView(product: product, isSelected: selectedProductID == product.id) {
                            selectedProductID = product.id
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 24)
        }
    }
}

struct ProductCardView: View {
    let product: ProductSuggestionsView.Product
    let isSelected: Bool
    let onSelect: () -> Void
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.white, Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)))
                .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(isSelected ? Color("AppBlue") : Color.clear, lineWidth: isSelected ? 2 : 0)
                )
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: product.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .background(Color.gray.opacity(0.12))
                }
                Text(product.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .padding(.horizontal, 4)
                Spacer(minLength: 0)
                if isSelected {
                    HStack {
                        Spacer()
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color("AppBlue"))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(16)
        }
        .frame(width: 200, height: 240)
        .padding(.vertical, 8)
        .onTapGesture {
            onSelect()
        }
    }
}
