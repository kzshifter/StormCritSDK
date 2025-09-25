//
//  StormCritEvent.swift
//  StormCritSDK
//
//  Created by Vadzim Ivanchanka on 9/25/25.
//

import Foundation

public enum StormCritEvent: RawRepresentable, Codable, Sendable {
    case failGeneration
    case failPresentPaywall
    case failPayment
    case coldStartTimeout
    case applicationNotResponding
    case serverError
    case custom(String)

    public init?(rawValue: String) {
        switch rawValue {
        case "failGeneration": self = .failGeneration
        case "failPresentPaywall": self = .failPresentPaywall
        case "failPayment": self = .failPayment
        case "coldStartTimeout": self = .coldStartTimeout
        case "applicationNotResponding": self = .applicationNotResponding
        case "serverError": self = .serverError
        default: self = .custom(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .failGeneration: return "failGeneration"
        case .failPresentPaywall: return "failPresentPaywall"
        case .failPayment: return "failPayment"
        case .coldStartTimeout: return "coldStartTimeout"
        case .applicationNotResponding: return "applicationNotResponding"
        case .serverError: return "serverError"
        case .custom(let value): return value
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = StormCritEvent(rawValue: rawValue) ?? .custom(rawValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
