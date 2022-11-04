import Foundation

/// Iota integration services verifiable credential handling.
public class IotaVerifiableCredentialManager: ObservableObject {
    
    private let iotaIntegrationServices: IotaIntegrationServices
    private let apiManager: ApiManager
    
    /// Initializes the class with the passed iota integration services.
    /// - Parameter iotaIntegrationServices: Iota integration services class for configuration handling.
    public init(iotaIntegrationServices: IotaIntegrationServices) {
        self.iotaIntegrationServices = iotaIntegrationServices

        apiManager = ApiManager(
                schema: iotaIntegrationServices.scheme,
                host: iotaIntegrationServices.host,
                port: iotaIntegrationServices.port,
                path: iotaIntegrationServices.path,
                queryItems: [URLQueryItem(name: "api-key", value: iotaIntegrationServices.apiKey)])
    }
    
    /// Checks a given verifiable credential.
    /// - Parameter vc: Verifiable credential
    /// - Returns: Check (isValid: Bool)
    public func verifyCredential(_ vc: IotaVerifiableCredentialSchema) async throws -> IotaVerifiableCredentialCheck {
        var request: URLRequest = try URLRequest(url: apiManager.generateUrl(forEndpoint: "/verification/check-credential"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try apiManager.encoder.encode(vc)
            request.httpBody = data
        } catch {
            throw APError.encodingError
        }
        
        return try await withCheckedThrowingContinuation({ continuation in
            apiManager.httpRequest(request, model: IotaVerifiableCredentialCheck.self) { result in
                continuation.resume(with: result)
            }
        })
    }
    
}
