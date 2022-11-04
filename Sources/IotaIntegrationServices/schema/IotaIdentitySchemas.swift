import Foundation

/// Schema for iota identity types.
public enum IotaIdentityType : String, Codable {
    case organization = "Organization"
    case person = "Person"
    case product = "Product"
    case service = "Service"
    case device = "Device"
    case unknown = "Unknown"
}

/// Schema for iota identity body object.
public struct IotaIdentityBodySchema: Codable {
    public var username: String
    public var claim: IotaIdentityClaim?
    
    public init() {
        self.init(username: "", claim: nil)
    }
    
    public init(username: String) {
        self.init(username: username, claim: nil)
    }
    
    public init(username: String, claim: IotaIdentityClaim?) {
        self.username = username
        self.claim = claim
    }
}

/// Schema for iota identity claim types.
public enum IotaIdentityClaim {
    case organization(IotaIdentityOrganizationClaim)
    case person(IotaIdentityPersonClaim)
    case service(IotaIdentityServiceClaim)
    case unknown
}

/// Schema for iota identity claim object.
extension IotaIdentityClaim: Codable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case type = "type"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let singleContainer = try decoder.singleValueContainer()
        
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case IotaIdentityType.organization.rawValue:
            let organizationClaim = try singleContainer.decode(IotaIdentityOrganizationClaim.self)
            self = .organization(organizationClaim)
        case IotaIdentityType.person.rawValue:
            let personClaim = try singleContainer.decode(IotaIdentityPersonClaim.self)
            self = .person(personClaim)
        case IotaIdentityType.service.rawValue:
            let serviceClaim = try singleContainer.decode(IotaIdentityServiceClaim.self)
            self = .service(serviceClaim)
        default:
            self = IotaIdentityClaim.unknown
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()
        
        switch self {
        case .organization(let organizationClaim):
            try singleContainer.encode(organizationClaim)
        case .person(let personClaim):
            try singleContainer.encode(personClaim)
        case .service(let serviceClaim):
            try singleContainer.encode(serviceClaim)
        case .unknown:
            throw EncodingError.invalidValue(self, .init(codingPath: singleContainer.codingPath, debugDescription: "Skip encoding unknown claim"))
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .organization(let claim):
            hasher.combine(claim)
        case .person(let claim):
            hasher.combine(claim)
        case .service(let claim):
            hasher.combine(claim)
        case .unknown:
            break
        }
    }
}

/// Schema for iota identity organization claim object.
public struct IotaIdentityOrganizationClaim: Codable, Hashable {
    public var type: IotaIdentityType
    public var name: String
    public var description: String?
    public var address: String?
    public var image: String?
    public var url: String?
    public var email: String?
    public var brand: String?
    
    public init(name: String, description: String? = nil, address: String? = nil, image: String? = nil, url: String? = nil, email: String? = nil, brand: String? = nil) {
        self.type = .organization
        self.name = name
        self.description = description
        self.address = address
        self.image = image
        self.url = url
        self.email = email
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(address)
        hasher.combine(image)
        hasher.combine(url)
        hasher.combine(email)
        hasher.combine(brand)
    }
}

/// Schema for iota identity person claim object.
public struct IotaIdentityPersonClaim: Codable, Hashable {
    
    public var type: IotaIdentityType
    public var lastName: String?
    public var firstName: String?
    public var birthdate: String?
    
    public init(lastName: String? = nil, firstName: String? = nil, birthdate: String? = nil) {
        self.type = .person
        self.lastName = lastName
        self.firstName = firstName
        self.birthdate = birthdate
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(lastName)
        hasher.combine(firstName)
        hasher.combine(birthdate)
    }
}

/// Schema for iota identity service claim object.
public struct IotaIdentityServiceClaim: Codable, Hashable {
    public var type: IotaIdentityType
    public var name: String
    public var description: String
    public var category: String
    public var url: String
    public var username: String
    
    public init(name: String, description: String, category: String, url: String, username: String) {
        self.type = .service
        self.name = name
        self.description = description
        self.category = category
        self.url = url
        self.username = username
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(category)
        hasher.combine(url)
        hasher.combine(username)
    }
}

/// Schema for iota identity object.
public struct IotaIdentitySchema: Codable {
    public var id: String
    public var username: String
    public var registrationDate: String?
    public var creator: String?
    public var role: String?
    public var claim: IotaIdentityClaim?
    public var hidden: Bool?
    public var isServerIdentity: Bool?
    public var verifiableCredentials: [IotaVerifiableCredentialSchema]?

    public init(id: String, username: String, registrationDate: String? = nil, creator: String? = nil, role: String? = nil, claim: IotaIdentityClaim? = nil, hidden: Bool? = false, isServerIdentity: Bool? = false, verifiableCredentials: [IotaVerifiableCredentialSchema]? = nil) {
        self.id = id
        self.username = username
        self.registrationDate = registrationDate
        self.creator = creator
        self.role = role
        self.claim = claim
        self.hidden = hidden
        self.isServerIdentity = isServerIdentity
        self.verifiableCredentials = verifiableCredentials
    }
}

/// Schema for iota identity document authentication object.
public struct IotaIdentityDocAuthSchema: Codable {
    public var id: String
    public var controller: String
    public var type: String
    public var publicKeyBase58: String
}

/// Schema for iota identity proof object.
public struct IotaIdentityProof: Codable, Hashable {
    public var type: String
    public var verificationMethod: String
    public var signatureValue: String
    
    public init(type: String, verificationMethod: String, signatureValue: String) {
        self.type = type
        self.verificationMethod = verificationMethod
        self.signatureValue = signatureValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(verificationMethod)
        hasher.combine(signatureValue)
    }
}

/// Schema for iota identity document object.
public struct IotaIdentityDocumentSchema: Codable {
    public var id: String
    public var verificationMethod: [IotaIdentityDocAuthSchema]?
    public var previousMessageId: String?
    public var authentication: [IotaIdentityDocAuthSchema]
    public var created: String
    public var updated: String
    public var immutable: Bool?
    public var proof: IotaIdentityProof
}

/// Schema for iota identity key pair object.
public struct IotaIdentityKeyPairSchema: Codable {
    public var type: String
    public var publicKey: String
    public var privateKey: String
    public var encoding: String
    
    private enum CodingKeys : String, CodingKey {
        case type, publicKey = "public", privateKey = "private", encoding
    }
}

/// Schema for iota identity key type object.
public struct IotaCreateIdentityKeyTypeSchema: Codable {
    public var sign: IotaIdentityKeyPairSchema
    public var encrypt: IotaIdentityKeyPairSchema
}

/// Schema for iota identity keys object.
public struct IotaIdentityKeysSchema: Codable {
    public var id: String
    public var keys: IotaCreateIdentityKeyTypeSchema
}
