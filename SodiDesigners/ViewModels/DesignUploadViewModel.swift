import Foundation
import SwiftUI
import Alamofire

@MainActor
final class DesignUploadViewModel: ObservableObject {
    @Published var selectedCategory: CategoryModel?
    @Published var selectedItems: [String] = []
    @Published var descriptionText: String = ""
    @Published var uploadedPhotoData: Data?
    @Published var uploadedPhotoUrl: String?
    @Published var isLoading = false
    @Published var responseMessage: String?

    func submitDesign() async {
        guard let category = selectedCategory else { return }
        guard !selectedItems.isEmpty else {
            responseMessage = "Please add at least one item to add."
            return
        }

        isLoading = true
        defer { isLoading = false }
        let base64Image = uploadedPhotoData?.base64EncodedString()
        let request = DesignRequestModel(
            userId: "USR12345",
            category: category.id,
            inputs: DesignInputs(
                photoBase64: base64Image,
                itemsToAdd: selectedItems,
                visionDescription: descriptionText.isEmpty ? nil : descriptionText
            ),
            appMetadata: AppMetadata(
                platform: "iOS",
                version: "1.0.0",
                language: "en",
                source: "SodiDesigners"
            )
        )

        do {
            // Using a test endpoint (jsonplaceholder) to simulate upload
            let encoder = JSONEncoder()
            let data = try encoder.encode(request)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]

            let afResponse = await AF.request(APIEndpoints.uploadDesign,
                                             method: .post,
                                             parameters: json,
                                             encoding: JSONEncoding.default,
                                             headers: NetworkManager.commonHeaders)
                .serializingDecodable(DesignResponseModel.self).response

            if let value = afResponse.value {
                responseMessage = "Success: id=\(value.id ?? -1)"
            } else if let error = afResponse.error {
                responseMessage = "Error: \(error.localizedDescription)"
            } else {
                responseMessage = "Unknown response"
            }
        } catch {
            responseMessage = "Encoding error: \(error.localizedDescription)"
        }
    }
}
