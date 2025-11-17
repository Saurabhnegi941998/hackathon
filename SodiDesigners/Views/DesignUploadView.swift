import SwiftUI
import PhotosUI

struct DesignUploadView: View {
    var selectedCategory: CategoryModel
    var designViewModel: DesignUploadViewModel = DesignUploadViewModel()
    
    @State private var visionText: String = ""
    @State private var selectedItemIndex: Int? = nil
    @Environment(\.dismiss) private var dismiss

    @FocusState private var isVisionFocused: Bool

    // MARK: Picker States
    @State private var showActionSheet = false
    @State private var showCamera = false
    @State private var showGallery = false
    @State private var galleryItem: PhotosPickerItem?
    @State private var uploadedImage: UIImage?
    @State private var uploadedPhotoData : Data?
    
    var uploadedBase64String: String? {
        guard let data = uploadedPhotoData else { return nil }
        return data.base64EncodedString()
    }

    let items: [(name: String, imageName: String)] = [
        ("TV", "photo"),
        ("Sofa", "photo"),
        ("Chair", "photo"),
        ("Table", "photo"),
        ("Lamp", "photo"),
        ("Bookshelf", "photo"),
        ("Desk", "photo"),
        ("Cabinet", "photo")
    ]

    var body: some View {
        VStack(spacing: 0) {

            SodiDesignersHeader(onBack: { dismiss() })

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Section: Title
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Upload Your Space")
                            .font(.system(size: 22, weight: .semibold))
                            .padding(.top, 24)

                        HStack(spacing: 0) {
                            Text("Share a photo of your ")
                                .foregroundColor(.secondary)
                            Text(selectedCategory.name)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        .font(.system(size: 16))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 18)


                    // MARK: Upload Photo Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Upload Photo")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.bottom, 8)

                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                .foregroundColor(Color.gray.opacity(0.3))
                                .frame(height: 180)

                            if let img = uploadedImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            } else {
                                VStack(spacing: 18) {
                                    HStack(spacing: 32) {
                                        Circle()
                                            .fill(Color.gray.opacity(0.12))
                                            .frame(width: 56, height: 56)
                                            .overlay(Image(systemName: "camera").font(.system(size: 26)))

                                        Circle()
                                            .fill(Color.gray.opacity(0.12))
                                            .frame(width: 56, height: 56)
                                            .overlay(Image(systemName: "photo").font(.system(size: 26)))
                                    }
                                    Text("Take photo or choose from gallery")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onTapGesture {
                            showActionSheet = true
                        }
                        .padding(.bottom, 18)
                    }
                    .padding(.horizontal, 24)


                    // Section: Add Items
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What do you want to add?")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.bottom, 8)

                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]

                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(items.indices, id: \.self) { index in
                                VStack(spacing: 6) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 64, height: 64)
                                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedItemIndex == index ? Color("AppBlue") : .clear,
                                                            lineWidth: 2)
                                            )
                                        Image(systemName: items[index].imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 56, height: 56)
                                            .clipShape(Circle())
                                    }
                                    Text(items[index].name)
                                        .font(.system(size: 13))
                                }
                                .onTapGesture {
                                    selectedItemIndex = index
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 18)


                    // MARK: Vision Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Describe your vision")
                            .font(.system(size: 16, weight: .semibold))

                        TextField("E.g., I want a modern living room with warm lighting...", text: $visionText)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(isVisionFocused ? Color("AppBlue") : Color.gray.opacity(0.3), lineWidth: 2)
                            )
                            .focused($isVisionFocused)

                        Button(action: {
                            Task {
                                    await designViewModel.submitDesign()
                                }
                            
                        }) {
                            Text("Continue")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color("AppBlue"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("AppBlue"), lineWidth: 2)
                                )
                        }
                        .padding(.top, 12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarHidden(true)

        // MARK: PICKER MODIFIERS
        .confirmationDialog("Select Option", isPresented: $showActionSheet) {
            Button("Camera") { showCamera = true }
            Button("Gallery") { showGallery = true }
            Button("Cancel", role: .cancel) {}
        }

        .photosPicker(isPresented: $showGallery,
                      selection: $galleryItem,
                      matching: .images)

        .onChange(of: galleryItem) { newValue in
            if let galleryItem {
                   Task {
                       if let data = try? await galleryItem.loadTransferable(type: Data.self),
                                     let img = UIImage(data: data),
                                     let jpegData = img.jpegData(compressionQuality: 0.8) {

                                      uploadedImage = img            // UI Preview Image
                                      uploadedPhotoData = jpegData   // Save as Data
                           designViewModel.uploadedPhotoData = jpegData
                       }
                   }
               }
        }

        .sheet(isPresented: $showCamera) {
            ZStack {
                CameraPicker(image: $uploadedImage)
                    .ignoresSafeArea()
            }
        }.onAppear {
            designViewModel.selectedCategory = selectedCategory
        }
    }
}



struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        print("Hello")
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        
        init(_ parent: CameraPicker) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
