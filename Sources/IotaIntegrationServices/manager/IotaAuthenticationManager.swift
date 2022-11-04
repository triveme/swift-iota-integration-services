import Foundation
import CryptoKit
import Base58Swift
import ed25519swift
import Logging

public enum AuthenticationError: Error {
    case signingError(message: String)
    case couldNotGetNonce
    case notAuthenticated
}

/// Iota integration services authentication handling.
public class IotaAuthenticationManager: ObservableObject {
    
    private let logger: Logger
    
    private let iotaIntegrationServices: IotaIntegrationServices
    private let apiManager: ApiManager
    
    @Published var iotaJwt: IotaJWT?
    
    /// Initializes the class with the passed iota integration services.
    /// - Parameter iotaIntegrationServices: Iota integration services class for configuration handling.
    public init(iotaIntegrationServices: IotaIntegrationServices) {
        logger = Logger(label: String(describing: IotaAuthenticationManager.self))
        
        self.iotaIntegrationServices = iotaIntegrationServices

        apiManager = ApiManager(
                schema: iotaIntegrationServices.scheme,
                host: iotaIntegrationServices.host,
                port: iotaIntegrationServices.port,
                path: iotaIntegrationServices.path,
                queryItems: [URLQueryItem(name: "api-key", value: iotaIntegrationServices.apiKey)])
    }
    
    /// Requests a challenge from the iota integration services authentication endpoint.
    /// - Parameter identityId: DID of the identity
    /// - Returns: Challenge as nonce (number only used once)
    public func requestChallenge(identityId: String) async throws -> IotaNonceSchema {
        var request: URLRequest = try URLRequest(url: apiManager.generateUrl(forEndpoint: "/authentication/prove-ownership/\(identityId)"))
        request.httpMethod = "GET"
        
        return try await withCheckedThrowingContinuation({ continuation in
            apiManager.httpRequest(request, model: IotaNonceSchema.self) { result in
                continuation.resume(with: result)
            }
        })
    }
    
    /// Hashes the given nonce using sha256.
    /// - Parameter iotaNonce: Nonce (challenge) from authentication endpoint
    /// - Returns: Hashed nonce
    public func hashNonce(_ iotaNonce: IotaNonceSchema) -> String {
        logger.debug("\(iotaNonce.nonce.utf8)")
        let data = Data(iotaNonce.nonce.utf8)
        
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// Signs the given nonce using the given private key using the ED25519 method.
    /// - Parameter hashedNonce: Hashed nonce
    /// - Parameter privateKey: Private key of the did
    /// - Returns: Signed nonce
    public func signNonce(hashedNonce: String, privateKey: String) throws -> String {
        
        // decode private key from base58
        guard let decodedPrivateKey = Base58.base58Decode(privateKey) else {
            throw AuthenticationError.signingError(message: "Private key not encoded in Base58.")
        }
        
        // encode private key to hex
        let encodedPrivateKey = decodedPrivateKey.map { String(format: "%02hhx", $0) }.joined()
        
        // sign nonce with encoded private key
        let signedNonceArray = Ed25519.sign(message: Array(hex: hashedNonce), secretKey: Array(hex: encodedPrivateKey))
        
        // hex array to string
        let signedNonce = signedNonceArray.map { String(format: "%02hhx", $0) }.joined()
        
        return signedNonce
    }
    
    /// Sends the signed nonce to the iota integration services authentication endpoint in order to retrieve a valid token for further authentication.
    /// - Parameters:
    ///   - identityId: DID of the identity
    ///   - signedNonce: Signed nonce
    /// - Returns: Valid JWT (JSON Web Token)
    public func requestJWT(identityId: String, signedNonce: String) async throws -> IotaJWT {
        var request: URLRequest = try URLRequest(url: apiManager.generateUrl(forEndpoint: "/authentication/prove-ownership/\(identityId)"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let data = try apiManager.encoder.encode(IotaProveOwnershipPostBodySchema(signedNonce))
            request.httpBody = data
        } catch {
            throw APError.encodingError
        }
        
        return try await withCheckedThrowingContinuation({ continuation in
            apiManager.httpRequest(request, model: IotaJWT.self) { result in
                continuation.resume(with: result)
            }
        })
    }
    
    /// Authenticates an identity using the did and the private key.
    /// - Parameters:
    ///   - did: DID of the identity
    ///   - pk: Private key of the identity
    /// - Returns: Valid JWT (JSON Web Token)
    public func authenticate(did: String, pk: String) async throws -> IotaJWT {
        logger.debug("Identity ID: \(did)\n")
        
        let iotaNonce = try await requestChallenge(identityId: did)
        let hashedNonce = hashNonce(iotaNonce)
        let signedNonce = try signNonce(hashedNonce: hashedNonce, privateKey: pk)
        let iotaJwt = try await requestJWT(identityId: did, signedNonce: signedNonce)
    
        return iotaJwt
    }
    
    /// Authenticates an identity using the identity keys.
    /// - Parameter iotaIdentityKeys: Keys object of the identity
    /// - Returns: Valid JWT (JSON Web Token)
    public func authenticate(iotaIdentityKeys: IotaIdentityKeysSchema) async throws -> IotaJWT {
        //TODO: Check if jwt is still valid
        return try await authenticate(did: iotaIdentityKeys.id, pk: iotaIdentityKeys.keys.sign.privateKey)
    }
    
    /// Authenticates the already set up identity.
    /// - Returns: Valid JWT (JSON Web Token)
    public func authenticateMe() async throws -> IotaJWT {
        guard iotaIntegrationServices.identityManager.setupComplete else {
            throw SetupError.identityNotSetup
        }
        
        return try await authenticate(iotaIdentityKeys: iotaIntegrationServices.identityManager.iotaIdentityKeys!)
    }
    
    /// Forgets the retrieved JWT (JSON Web Token).
    public func forgetJwt() {
        self.iotaJwt = nil
    }
    
}
