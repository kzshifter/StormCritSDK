import Foundation

/*
 public protocol StormCritSDKConfigurable {
 var token: String { get }
 var baseURLString: String { get }
 }
 */

public struct StormCritSDKConfiguration: Sendable {
    let token: String
    let baseURLString: String
    let endpoint: StormCritNetworkEndpoint
    
    public init(token: String, baseURLString: String, endpoint: StormCritNetworkEndpoint = .crit) {
        self.token = token
        self.baseURLString = baseURLString
        self.endpoint = endpoint
    }
}

//Static Interface:
extension StormCritSDK {
    public static func configure(configuration: StormCritSDKConfiguration) {
        Task {
            await Self.instance.setConfiguration(configuration)
        }
    }
    
    public static func sendEvent(event: StormCritEvent, additionalInfo: [String: String] = [:]) async {
        await Self.instance.sendEventInternal(event: event, additionalInfo: additionalInfo)
    }
}

public actor StormCritSDK {
    
    private var configuration: StormCritSDKConfiguration?
    private var networker: StormCritNetwork?
    
    internal static let instance: StormCritSDK = .init()
    
    private init() {}
    
    private func setConfiguration(_ config: StormCritSDKConfiguration) {
        self.configuration = config
        self.networker = StormCritNetwork(baseURL: config.baseURLString,
                                          endpoint: config.endpoint,
                                          token: config.token)
    }
    
    private func sendEventInternal(event: StormCritEvent, additionalInfo: [String: String]) async {
        guard let networker = self.networker else {
            print("StormCritSDK is not configured. Call configure().")
            return
        }
        
        networker.makeCritRequest(event: event, additionalInfo: additionalInfo)
    }
}
