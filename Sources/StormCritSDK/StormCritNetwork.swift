//
//  StormCritNetwork.swift
//  StormCritSDK
//
//  Created by Vadzim Ivanchanka on 9/25/25.
//

import Foundation

public enum StormCritNetworkEndpoint: Sendable {
    case crit
    case custom(String)
    
    public var rawValue: String {
        switch self {
        case .crit: return "crit"
        case .custom(let value): return value
        }
    }
    
    public init(rawValue: String) {
        switch rawValue {
        case "crit": self = .crit
        default: self = .custom(rawValue)
        }
    }
}

final internal class StormCritNetwork: Sendable {
    
    // Constants
    private let baseURL: String
    private let endpoint: StormCritNetworkEndpoint
    private let token: String
    
    required public init(baseURL: String, endpoint: StormCritNetworkEndpoint, token: String) {
        self.baseURL = baseURL
        self.endpoint = endpoint
        self.token = token
    }
    
    func makeCritRequest(event: StormCritEvent, additionalInfo: [String: String] = [:]) {
        guard let url = URL(string: "\(self.baseURL)/\(endpoint)") else {
            print("Invalide URL")
            return
        }
        var request = self.buildRequest(with: url)
        
        request.httpBody = try? self.buildBody(with: [
            "app": AppInfoHelper.getAppName(),
            "event": event.rawValue,
            "additional_info": additionalInfo,
            "base_app_info": AppInfoHelper.getAppInfo()
        ])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error request: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                self.handleHTTPStatus(httpResponse)
            }
        }
    
        task.resume()
    }
    
    private func handleHTTPStatus(_ response: URLResponse?) {
        guard let httpResponse = response as? HTTPURLResponse else {
            print("StormCrit: Invalid response")
            return
        }
        
        let status = httpResponse.statusCode
        switch status {
        case 200...299:
            print("StormCrit: Success (\(status))")
        case 400...499:
            print("StormCrit: Client error (\(status))")
        case 500...599:
            print("StormCrit: Server error (\(status))")
        default:
            print("StormCrit: Unexpected status (\(status))")
        }
    }
    
    private func buildRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func buildBody(with params: [AnyHashable: Any]) throws -> Data? {
        do {
            let jsonBody = try JSONSerialization.data(withJSONObject: params, options: [])
            return jsonBody
        } catch {
            print("Eror with build JSON: \(error)")
            return nil
        }
    }
}
