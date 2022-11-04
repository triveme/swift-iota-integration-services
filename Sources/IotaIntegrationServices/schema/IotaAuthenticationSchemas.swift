import Foundation

/// Schema for iota nonce object.
public struct IotaNonceSchema: Codable {
    public var nonce: String
    
    public init(_ nonce: String) {
        self.nonce = nonce
    }
}

/// Schema for iota signed nonce object.
public struct IotaProveOwnershipPostBodySchema: Codable {
    public var signedNonce: String
    
    public init(_ signedNonce: String) {
        self.signedNonce = signedNonce
    }
}

/// Schema for iota jwt object.
public struct IotaJWT: Codable {
    public var jwt: String
    
    public init(jwt: String) {
        self.jwt = jwt
    }
}
