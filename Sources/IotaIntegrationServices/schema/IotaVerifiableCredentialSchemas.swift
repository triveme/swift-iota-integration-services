import Foundation

/// Schema for iota verifiable credential types.
public enum IotaVerifiableCredentialType: String, Codable {
    case verifiableCredential = "VerifiableCredential"
    case basicIdentityCredential = "BasicIdentityCredential"
    case verifiedIdentityCredential = "VerifiedIdentityCredential"
    case verifiedEmailCredential = "VerifiedEmailCredential"
    case digitalCarKeyCredential = "DigitalCarKeyCredential"
    case citybotAccessCredential = "CitybotAccessCredential"
    case verifiedPaymentMethodCredential = "VerifiedPaymentMethodCredential"
}

/// Schema for iota verifiable credential subject types.
public enum IotaVerifiableCredentialSubjectSchema: Codable, Hashable {
    case verifiedIdentity(IotaVerifiedIdentityVCSubjectSchema)
    case verifiedEmail(IotaEmailVCSubjectSchema)
    case digitalCarKey(IotaDigitalCarKeyVCSubjectSchema)
    case citybotAccess(IotaCitybotAccessVCSubjectSchema)
    case verifiedPaymentMethod(IotaVerifiedPaymentMethodVCSubjectSchema)
    case generic(IotaGenericVCSubjectSchema)
    
    /// Schema for iota verifiable credential subject context types.
    public enum IotaVerifiableCredentialSubjectContext: String, Codable {
        case schema = "https://schema.org/"
        case generic
    }
    
    /// Schema for iota verifiable credential object of type `VerifiedIdentityCredential`.
    public struct IotaVerifiedIdentityVCSubjectSchema: Codable, Hashable {
        public var id: String
        public var context: IotaVerifiableCredentialSubjectContext
        public var type: IotaIdentityType
        public var initiator: String
        public var lastName: String
        public var firstName: String
        public var address: String
        public var birthDate: String
        public var nationality: String
        public var birthPlace: String
        public var expiry: String
        public var info: String?
        
        public init(id: String, context: IotaVerifiableCredentialSubjectContext, type: IotaIdentityType, initiator: String, lastName: String, firstName: String, address: String, birthDate: String, nationality: String, birthPlace: String, expiry: String, info: String? = nil) {
            self.id = id
            self.context = context
            self.type = type
            self.initiator = initiator
            self.lastName = lastName
            self.firstName = firstName
            self.address = address
            self.birthDate = birthDate
            self.nationality = nationality
            self.birthPlace = birthPlace
            self.expiry = expiry
            self.info = info
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(context)
            hasher.combine(type)
            hasher.combine(initiator)
            hasher.combine(lastName)
            hasher.combine(firstName)
            hasher.combine(address)
            hasher.combine(birthDate)
            hasher.combine(nationality)
            hasher.combine(birthPlace)
            hasher.combine(expiry)
            hasher.combine(info)
        }

        private enum CodingKeys : String, CodingKey {
            case id, context = "@context", type, initiator, lastName, firstName, address, birthDate, nationality, birthPlace, expiry, info
        }
    }

    /// Schema for iota verifiable credential object of type `VerifiedEmailCredential`.
    public struct IotaEmailVCSubjectSchema: Codable, Hashable {
        public var id: String
        public var context: IotaVerifiableCredentialSubjectContext
        public var type: IotaIdentityType
        public var initiator: String
        public var email: String
        public var info: String?

        public init(id: String, context: IotaVerifiableCredentialSubjectContext, type: IotaIdentityType, initiator: String, email: String, info: String? = nil) {
            self.id = id
            self.context = context
            self.type = type
            self.initiator = initiator
            self.email = email
            self.info = info
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(context)
            hasher.combine(type)
            hasher.combine(initiator)
            hasher.combine(email)
            hasher.combine(info)
        }

        private enum CodingKeys : String, CodingKey {
            case id, context = "@context", type, initiator, email, info
        }
    }

    /// Schema for iota verifiable credential object of type `DigitalCarKeyCredential`.
    public struct IotaDigitalCarKeyVCSubjectSchema: Codable, Hashable {
        public var id: String
        public var context: IotaVerifiableCredentialSubjectContext
        public var type: IotaIdentityType
        public var initiator: String
        public var vin: String
        public var licensePlate: String
        public var features: [String]?
        public var info: String?

        public init(id: String, context: IotaVerifiableCredentialSubjectContext, type: IotaIdentityType, initiator: String, vin: String, licensePlate: String, features: [String]? = nil, info: String? = nil) {
            self.id = id
            self.context = context
            self.type = type
            self.initiator = initiator
            self.vin = vin
            self.licensePlate = licensePlate
            self.features = features
            self.info = info
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(context)
            hasher.combine(type)
            hasher.combine(initiator)
            hasher.combine(vin)
            hasher.combine(licensePlate)
            hasher.combine(features)
            hasher.combine(info)
        }

        private enum CodingKeys : String, CodingKey {
            case id, context = "@context", type, initiator, vin, licensePlate, features, info
        }
    }

    /// Schema for iota verifiable credential object of type `CitybotAccessCredential`.
    public struct IotaCitybotAccessVCSubjectSchema: Codable, Hashable {
        public var id: String
        public var context: IotaVerifiableCredentialSubjectContext
        public var type: IotaIdentityType
        public var initiator: String
        public var citybotId: String
        public var features: [String]?
        public var info: String?

        public init(id: String, context: IotaVerifiableCredentialSubjectContext, type: IotaIdentityType, initiator: String, citybotId: String, features: [String]? = nil, info: String? = nil) {
            self.id = id
            self.context = context
            self.type = type
            self.initiator = initiator
            self.citybotId = citybotId
            self.features = features
            self.info = info
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(context)
            hasher.combine(type)
            hasher.combine(initiator)
            hasher.combine(citybotId)
            hasher.combine(features)
            hasher.combine(info)
        }

        private enum CodingKeys : String, CodingKey {
            case id, context = "@context", type, initiator, citybotId, features, info
        }
    }

    /// Schema for iota verifiable credential object of type `VerifiedPaymentMethodCredential`.
    public struct IotaVerifiedPaymentMethodVCSubjectSchema: Codable, Hashable {
        public var id: String
        public var context: IotaVerifiableCredentialSubjectContext
        public var type: IotaIdentityType
        public var initiator: String
        public var method: String
        public var detail: IotaVerifiedPaymentMethodVCDetailSchema
        public var info: String?
        
        public enum IotaVerifiedPaymentMethodVCMethodSchema: String, Codable, Hashable {
            case creditcard = "creditcard"
        }
        
        public struct IotaVerifiedPaymentMethodVCDetailSchema: Codable, Hashable {
            public var type: String
            public var number: String
            public var cvc: Int
            public var expiry: String
            
            public enum IotaVerifiedPaymentMethodVCDetailTypeSchema: String, Codable, Hashable {
                case mastercard = "mastercard"
                case visa = "visa"
                case amex = "amex"
            }
            
            public init(type: String, number: String, cvc: Int, expiry: String) {
                self.type = type
                self.number = number
                self.cvc = cvc
                self.expiry = expiry
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(type)
                hasher.combine(number)
                hasher.combine(cvc)
                hasher.combine(expiry)
            }
        }
        
        public init(id: String, context: IotaVerifiableCredentialSubjectContext, type: IotaIdentityType, initiator: String, method: String, detail: IotaVerifiedPaymentMethodVCDetailSchema, info: String? = nil) {
            self.id = id
            self.context = context
            self.type = type
            self.initiator = initiator
            self.method = method
            self.detail = detail
            self.info = info
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(context)
            hasher.combine(type)
            hasher.combine(initiator)
            hasher.combine(method)
            hasher.combine(detail)
            hasher.combine(info)
        }

        private enum CodingKeys : String, CodingKey {
            case id, context = "@context", type, initiator, method, detail, info
        }
    }

    /// Schema for iota verifiable credential object of generic type.
    public struct IotaGenericVCSubjectSchema: Codable, Hashable {
        public var id: String
        public var context: IotaVerifiableCredentialSubjectContext
        public var type: IotaIdentityType
        public var initiator: String

        public init(id: String, context: IotaVerifiableCredentialSubjectContext, type: IotaIdentityType, initiator: String) {
            self.id = id
            self.context = context
            self.type = type
            self.initiator = initiator
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(context)
            hasher.combine(type)
            hasher.combine(initiator)
        }

        private enum CodingKeys : String, CodingKey {
            case id, context = "@context", type, initiator
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let subject = try? container.decode(IotaVerifiedIdentityVCSubjectSchema.self) {
            self = .verifiedIdentity(subject)
            return
        }
        if let subject = try? container.decode(IotaEmailVCSubjectSchema.self) {
            self = .verifiedEmail(subject)
            return
        }
        if let subject = try? container.decode(IotaDigitalCarKeyVCSubjectSchema.self) {
            self = .digitalCarKey(subject)
            return
        }
        if let subject = try? container.decode(IotaCitybotAccessVCSubjectSchema.self) {
            self = .citybotAccess(subject)
            return
        }
        if let subject = try? container.decode(IotaVerifiedPaymentMethodVCSubjectSchema.self) {
            self = .verifiedPaymentMethod(subject)
            return
        }
        if let subject = try? container.decode(IotaGenericVCSubjectSchema.self) {
            self = .generic(subject)
            return
        }
        throw DecodingError.typeMismatch(
            IotaVerifiableCredentialSubjectSchema.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Type is not matched", underlyingError: nil))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .verifiedIdentity(let subject):
            try container.encode(subject)
        case .verifiedEmail(let subject):
            try container.encode(subject)
        case .digitalCarKey(let subject):
            try container.encode(subject)
        case .citybotAccess(let subject):
            try container.encode(subject)
        case .verifiedPaymentMethod(let subject):
            try container.encode(subject)
        case .generic(let subject):
            try container.encode(subject)
        }
    }
}

/// Schema for iota verifiable credential status object.
public struct IotaVerifiableCredentialStatusSchema: Codable, Hashable {
    public var id: String
    public var type: String
    public var revocationBitmapIndex: String
}

/// Schema for iota verifiable credential object.
public struct IotaVerifiableCredentialSchema: Codable, Identifiable, Hashable, Equatable {
    public var context: IotaVerifiableCredentialContext
    public var id: String
    public var type: [IotaVerifiableCredentialType]
    public var credentialSubject: IotaVerifiableCredentialSubjectSchema
    public var issuer: String
    public var issuanceDate: String
    public var credentialStatus: IotaVerifiableCredentialStatusSchema
    public var proof: IotaIdentityProof
    
    public enum IotaVerifiableCredentialContext: String, Codable {
        case w3cCredentialV1 = "https://www.w3.org/2018/credentials/v1"
        case generic
    }
    
    public init(context: IotaVerifiableCredentialContext, id: String, type: [IotaVerifiableCredentialType], credentialSubject: IotaVerifiableCredentialSubjectSchema, issuer: String, issuanceDate: String, credentialStatus: IotaVerifiableCredentialStatusSchema, proof: IotaIdentityProof) {
        self.context = context
        self.id = id
        self.type = type
        self.credentialSubject = credentialSubject
        self.issuer = issuer
        self.issuanceDate = issuanceDate
        self.credentialStatus = credentialStatus
        self.proof = proof
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(context)
        hasher.combine(id)
        hasher.combine(type)
        hasher.combine(credentialSubject)
        hasher.combine(issuer)
        hasher.combine(issuanceDate)
        hasher.combine(credentialStatus)
        hasher.combine(proof)
    }
    
    private enum CodingKeys : String, CodingKey {
        case context = "@context", id, type, credentialSubject, issuer, issuanceDate, credentialStatus, proof
    }
}

/// Schema for iota verifiable credential check object.
public struct IotaVerifiableCredentialCheck: Codable {
    public var isVerified: Bool
}

/// Schema for iota verifiable credential request object.
public struct IotaVerifiableCredentialRequestSchema: Codable, Equatable, Identifiable, Hashable {
    public var id: String
    public var did: String
    public var packlist: [String]
    public var callbackUrl: String
    
    public init(id: String, did: String, packlist: [String], callbackUrl: String) {
        self.id = id
        self.did = did
        self.packlist = packlist
        self.callbackUrl = callbackUrl
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(did)
        hasher.combine(packlist)
        hasher.combine(callbackUrl)
    }
}

/// Schema for iota verifiable credential sharable object.
public struct IotaVerifiableCredentialSharable: Codable, Equatable, Hashable {
    public var holder: String
    public var identityClaim: IotaIdentityClaim?
    public var verifiableCredentials: [IotaVerifiableCredentialSchema]?
    
    public init(holder: String, identityClaim: IotaIdentityClaim? = nil, verifiableCredentials: [IotaVerifiableCredentialSchema]? = nil) {
        self.holder = holder
        self.identityClaim = identityClaim
        self.verifiableCredentials = verifiableCredentials
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(holder)
        hasher.combine(identityClaim)
        hasher.combine(verifiableCredentials)
    }
}
