import SwiftUI
import Kingfisher

struct CategoryListView: View {
    @StateObject private var viewModel = CategoryListViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SodiDesignersHeader(onBack: { dismiss() })
                CategoryListContentView(viewModel: viewModel)
                    .navigationDestination(for: CategoryModel.self) { selectedRoom in
                        DesignUploadView(selectedCategory: selectedRoom)
                    }
            }
        }.navigationBarHidden(true)
    }
}

struct SodiDesignersHeader: View {
    var onBack: () -> Void
    var showBackArrow: Bool = true

    var body: some View {
          

            ZStack {
                Color("AppBlue")
                    

                HStack(spacing: 18) {
                    if showBackArrow {
                        Button(action: onBack) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                    }

                    Image("Sodimac")
                        .resizable()
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("SodiDesigners")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                        Text("AI Interior Design")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer()
                }
                .padding(.horizontal, 28)
                .frame(height: 88)
                .padding(.top, 10)
            }
            .frame(height: 88)
        }
    }


struct CategoryListContentView: View {
    @ObservedObject var viewModel: CategoryListViewModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            titleSection
            categoryGrid
        }
    }
}

private extension CategoryListContentView {
    
    var titleSection: some View {
        VStack(spacing: 8) {
            Text("Transform Your Space")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 16)
            Text("Choose a room to redesign with AI")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    var categoryGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.categories) { room in
                    NavigationLink(destination: DesignUploadView(selectedCategory: room)) {
                        CategoryCardView(room: room)
                    }
                }
            }
            .padding()
        }
    }
}

struct CategoryCardView: View {
    let room: CategoryModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            KFImage(URL(string: room.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 110)
                .frame(maxWidth: .infinity)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(room.name)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

extension String {
    var encodedURL: URL? {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            .flatMap { URL(string: $0) }
    }
}

#Preview {
    CategoryListView()
}
