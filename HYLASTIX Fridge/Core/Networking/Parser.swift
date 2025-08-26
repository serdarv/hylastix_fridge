//    
//  Parser.swift
//  HYLASTIX Fridge
//

import Foundation

class Parser {
    static func parse<T: Decodable>(response: Any) -> T? {
        if let jsonData = response as? Data {
            return parse(jsonData: jsonData)
        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
            return parse(jsonData: jsonData)
        }

        return nil
    }

    static func parse<T: Decodable>(jsonData: Data) -> T? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let parsedObject = try jsonDecoder.decode(T.self, from: jsonData)
            return parsedObject
        } catch {
            debugPrint("### Error deserializing JSON: \(error)")
        }

        return nil
    }

    static func toDictionary<T: Encodable>(object: T, keyEncodingStrategySnake: Bool = false) -> [String: Any]? {
        do {
            let lJSONEncoder = JSONEncoder()
            lJSONEncoder.dateEncodingStrategy = .formatted(DateFormatter.custom)
            if keyEncodingStrategySnake {
                lJSONEncoder.keyEncodingStrategy = .convertToSnakeCase
            }
            let data = try lJSONEncoder.encode(object)

            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        } catch {
            debugPrint("### Error deserializing JSON: \(error)")
        }

        return nil
    }

    static func toData<T: Encodable>(object: T, keyEncodingStrategySnake: Bool = false) -> Data? {
        do {
            let lJSONEncoder = JSONEncoder()
            if keyEncodingStrategySnake {
                lJSONEncoder.keyEncodingStrategy = .convertToSnakeCase
            }
            return try lJSONEncoder.encode(object)
        } catch {
            debugPrint("### Error deserializing JSON: \(error)")
        }

        return nil
    }

    static func toData(params: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: params)
    }
}
