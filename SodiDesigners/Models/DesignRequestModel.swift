import Foundation

struct DesignRequestModel: Codable {
    let userId: String
    let category: String
    let inputs: DesignInputs
    let appMetadata: AppMetadata
}

struct DesignInputs: Codable {
    let photoBase64: String?
    let itemsToAdd: [String]
    let visionDescription: String?
}

struct AppMetadata: Codable {
    let platform: String
    let version: String
    let language: String
    let source: String
}
