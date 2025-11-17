import SwiftUI

struct DesignResultView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: Int = 0
    let designImageURL = "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80"
    let products = [
        (name: "Samsung 55\" 4K Smart TV", imageName: "photo"),
        // Add more products as needed
    ]
    var body: some View {
        VStack(spacing: 0) {
            SodiDesignersHeader(onBack: { dismiss() })
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title Section
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Your Design")
                            .font(.system(size: 22, weight: .semibold))
                            .padding(.top, 24)
                            .padding(.bottom, 2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        HStack(spacing: 0) {
                            Text("AI-generated results for your ")
                                .foregroundColor(Color(.label).opacity(0.7))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Text("Empty Wall")
                                .fontWeight(.bold)
                                .foregroundColor(Color(.label).opacity(0.7))
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .font(.system(size: 16))
                        .padding(.top, 2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    // Segmented Control
                    HStack(spacing: 0) {
                        Button(action: { selectedTab = 0 }) {
                            Text("Your Design")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(selectedTab == 0 ? .white : .blue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(selectedTab == 0 ? Color("AppBlue") : Color(.systemGray6))
                                .cornerRadius(12)
                        }
                        Button(action: { selectedTab = 1 }) {
                            Text("Alternatives (5)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(selectedTab == 1 ? .white : .blue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(selectedTab == 1 ? Color("AppBlue") : Color(.systemGray6))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    // Design Image
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(url: URL(string: designImageURL)) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.opacity(0.15)
                        }
                        .frame(height: 260)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("AI Generated")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(Circle().fill(Color.green).frame(width: 8, height: 8).offset(x: -18, y: -12), alignment: .leading)
                            .padding(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    // Products List
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Products in this design:")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Button(action: { /* Add all action */ }) {
                                Text("Add All")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.bottom, 8)
                        ForEach(products, id: \.name) { product in
                            HStack(spacing: 12) {
                                Image(systemName: product.imageName)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                Text(product.name)
                                    .font(.system(size: 15, weight: .medium))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                                Button(action: { /* Add action */ }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "cart")
                                        Text("Add")
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color("AppBlue"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("AppBlue"), lineWidth: 1))
                                }
                            }
                            .padding(10)
                            .background(Color(red: 0.96, green: 0.98, blue: 1))
                            .cornerRadius(12)
                            .padding(.bottom, 8)
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(18)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            // Bottom Bar
            HStack(spacing: 18) {
                Button(action: { /* Bookmark action */ }) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 22))
                        .foregroundColor(.blue)
                        .frame(width: 56, height: 56)
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("AppBlue"), lineWidth: 1))
                }
                Button(action: { /* Share action */ }) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("AppBlue"), lineWidth: 1))
                }
                Button(action: { /* Retry action */ }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text("Retry")
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("AppBlue"), lineWidth: 1))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemGroupedBackground))
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
    }
}

#Preview {
    DesignResultView()
}
