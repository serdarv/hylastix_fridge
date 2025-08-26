//
//  FridgeEndpoint.swift
//  HYLASTIX Fridge
//

enum FridgeEndpoint<ResponseType: Decodable> {
    case getFrigdeItems
}

extension FridgeEndpoint: RequestProtocol {
    typealias Response = ResponseType

    var path: String {
        switch self {
        case .getFrigdeItems:
            return "/fridge"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getFrigdeItems:
            return .get
        }
    }
}
