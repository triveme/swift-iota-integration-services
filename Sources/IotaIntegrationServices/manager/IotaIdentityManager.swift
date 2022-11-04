import Foundation
import SwiftKeychainWrapper

public enum SetupError: Error {
    case identityNotSetup
    case keychainError(message: String)
    case authenticationFailed(message: String)
    case generic(message: String)
}

/// Iota integration services identity handling.
public class IotaIdentityManager: ObservableObject {
    
    private let iotaIntegrationServices: IotaIntegrationServices
    private let apiManager: ApiManager
    
    @Published public private(set) var iotaIdentityKeys: IotaIdentityKeysSchema? = nil
    @Published public private(set) var iotaIdentity: IotaIdentitySchema? = nil
    public var setupComplete: Bool {
        (iotaIdentityKeys != nil) && (iotaIdentity != nil)
    }
    
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
    
    /// Creates an iota identity body schema.
    /// - Parameters:
    ///   - username: Identity username
    ///   - identityClaim: Identity claim
    /// - Returns: Created identity body schema
    public func createIdentityBodySchema(username: String = UUID().uuidString, identityClaim: IotaIdentityClaim) -> IotaIdentityBodySchema {
        IotaIdentityBodySchema(username: username, claim: identityClaim)
    }
    
    /// Creates a new iota identity.
    /// - Parameter identityBodySchema: Identity body schema
    /// - Returns: Identity keys schema
    public func createIdentity(identityBodySchema: IotaIdentityBodySchema) async throws -> IotaIdentityKeysSchema {
        var request: URLRequest = try URLRequest(url: apiManager.generateUrl(forEndpoint: "/identities/create"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try apiManager.encoder.encode(identityBodySchema)
            request.httpBody = data
        } catch {
            throw APError.encodingError
        }
        
        return try await withCheckedThrowingContinuation({ continuation in
            apiManager.httpRequest(request, model: IotaIdentityKeysSchema.self) { result in
                continuation.resume(with: result)
            }
        })
        
    }
    
    /// Gets an iota identity by did.
    /// - Parameter did: DID of the identity
    /// - Returns: Iota identity
    public func getIdentity(did: String) async throws -> IotaIdentitySchema {
        guard let jwt = iotaIntegrationServices.authManager.iotaJwt?.jwt else {
            throw AuthenticationError.notAuthenticated
        }

        var request: URLRequest = try URLRequest(url: apiManager.generateUrl(forEndpoint: "/identities/identity/\(did)"))
        request.httpMethod = "GET"
        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        return try await withCheckedThrowingContinuation({ continuation in
            apiManager.httpRequest(request, model: IotaIdentitySchema.self) { result in
                continuation.resume(with: result)
            }
        })
    }
    
    /// Sets up and authenticate an identity using the identitys keys.
    /// - Parameter iotaIdentityKeys: Iota identity keys
    public func setupIdentity(iotaIdentityKeys: IotaIdentityKeysSchema) async throws {
        let iotaJwt = try await iotaIntegrationServices.authManager.authenticate(did: iotaIdentityKeys.id, pk: iotaIdentityKeys.keys.sign.privateKey)
        iotaIntegrationServices.authManager.iotaJwt = iotaJwt

        let iotaIdentity = try await getIdentity(did: iotaIdentityKeys.id)

        self.iotaIdentityKeys = iotaIdentityKeys
        self.iotaIdentity = iotaIdentity
    }
    
    /// Re-sets up the identity.
    public func reloadIdentity() async throws {
        guard setupComplete else {
            throw SetupError.identityNotSetup
        }
        
        try await setupIdentity(iotaIdentityKeys: iotaIdentityKeys!)
    }
    
    /// Forgets the set up identity.
    public func forgetIdentity() {
        self.iotaIdentityKeys = nil
        self.iotaIdentity = nil
        self.iotaIntegrationServices.authManager.forgetJwt()
    }
    
    /// Loads an identitys keys from keychain and set it up.
    public func loadIdentity() async throws {
        guard let retrievedString: String = KeychainWrapper.standard.string(forKey: "iota.identity.keys") else {
            throw SetupError.keychainError(message: "Iota identity keys not found in keychain")
        }

        guard let retrievedData = retrievedString.data(using: .utf8) else {
            throw SetupError.keychainError(message: "Could not decode keys")
        }

        let iotaIdentityKeys = try JSONDecoder().decode(IotaIdentityKeysSchema.self, from: retrievedData)
        
        try await setupIdentity(iotaIdentityKeys: iotaIdentityKeys)
    }
    
    /// Persists a loaded identitys keys in keychain.
    public func persistIdentity() throws {
        guard setupComplete else {
            throw SetupError.identityNotSetup
        }

        let keysString = String(decoding: try JSONEncoder().encode(self.iotaIdentityKeys), as: UTF8.self)
        let didSaveSuccessful: Bool = KeychainWrapper.standard.set(keysString, forKey: "iota.identity.keys")
        
        guard didSaveSuccessful else {
            throw SetupError.keychainError(message: "Failed to save keys in keychain")
        }
    }
    
    /// Forgets a persisted identitys keys.
    public func forgetPersistentIdentity() throws {
        forgetIdentity()

        guard KeychainWrapper.standard.removeObject(forKey: "iota.identity.keys") else {
            throw SetupError.keychainError(message: "Failed to remove keys from keychain")
        }
    }
    
}


