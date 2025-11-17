import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    static var commonHeaders: HTTPHeaders {
        var h = HTTPHeaders()
        h.add(name: "x-cmver", value: "iOS_SO-25.11.0")
        h.add(name: "x-channel-id", value: "SODIMAC_APP")
        h.add(name: "x-ecomm-name", value: "sodimac-mx")
        h.add(name: "Content-Type", value: "application/json")
        return h
    }
}
