import Foundation

/// Iota integration services configuration handling.
public class IotaIntegrationServices: ObservableObject {
    
    public static var shared = IotaIntegrationServices()
    
    public lazy var authManager = IotaAuthenticationManager(iotaIntegrationServices: self)
    public lazy var identityManager = IotaIdentityManager(iotaIntegrationServices: self)
    public lazy var credentialManager = IotaVerifiableCredentialManager(iotaIntegrationServices: self)
    
    private(set) var scheme: String
    private(set) var host: String
    private(set) var port: Int
    private(set) var path: String
    private(set) var apiKey: String
    
    private init() {
        self.scheme = ""
        self.host = ""
        self.port = 0
        self.path = ""
        self.apiKey = ""
    }
    
    /// Configures the iota integration services package.
    /// - Parameters:
    ///   - schema: URL schema
    ///   - host: URL host
    ///   - port: URL port
    ///   - path: URL API path
    ///   - apiKey: API key
    public func setup(schema: String, host: String, port: Int, path: String, apiKey: String) {
        self.scheme = schema
        self.host = host
        self.port = port
        self.path = path
        self.apiKey = apiKey
    }
    
}
