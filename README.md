
# ``swift-iota-integration-services``

This package implements the APIs of the IOTA integration services.

Official Iota Github repo: https://github.com/iotaledger/integration-services


## Overview

This package is still under development and should be used for testing purposes only.
Feel free to contribute to this project, fork it or reuse the source code for your own purposes.
If you discover problems, please create an issue with a specific problem description and feel free to submit pull requests with your own code improvements.


## License

![GitHub](https://img.shields.io/github/license/triveme/swift-iota-integration-services)
swift-iota-integration-services can be used, distributed and modified under the EUPL v1.2 license.


## Requirements

swift-iota-integration-services requires Swift5.

macOS, iOS


## Install

You need to add this package via the repo url to your Xcode project before using it.

### Swift Package Manager

```
https://github.com/triveme/swift-iota-integration-services.git
``` 

or add the following line to the dependencies section in your _Package.swift_ file:

```
.package(url: "https://github.com/triveme/swift-iota-integration-services.git", branch: "master")
```


## How to use

### Import the package in your own code

```
import IotaIntegrationServices
```

### Set up the services

```
let urlSchema: String = "https"
let urlHost: String = "demo-integration-services.iota.cafe"
let urlPort: Int = 443
let urlPath: String = "/api/v0.2"
let apiKey: String = "b85e51a2-9981-11ec-8770-4b8f01948e9b"

let iotaIS = IotaIntegrationServices.shared
iotaIS.setup(schema: urlSchema, host: urlHost, port: urlPort, path: urlPath, apiKey: apiKey)
```

### Create your own identity

```
let iotaIdentityBodySchema = iotaIS.identityManager.createIdentityBodySchema(
    username: "john.doe",
    identityClaim: .person(.init(
            type: .person,
            lastName: "Doe",
            firstName: "John",
            birthdate: "1970-01-01")))      
let iotaIdentity = try await iotaIS.identityManager.createIdentity(identity: iotaIdentityBodySchema)
```

### Setup your identity

```
let did = iotaIdentity.id
let pk = iotaIdentity.keys.sign.privateKey
try await iotaIS.identityManager.setupIdentity(did: did, secret: pk)
```

### Get your did document

```
let iotaIdentity = try await iotaIS.identityManager.getIdentity(did: did)
print(iotaIdentity)
```



## Endpoints overview

| **ENDPOINT**                                  | **METHOD** | **SUMMARY**                                                   | **IMPLEMENTED** |
|-----------------------------------------------|------------|---------------------------------------------------------------|-----------------|
| **Authentication**                            |            |                                                               |                 |
| `/authentication/prove-ownership/{id}`        | GET        | Request a nonce which must be signed by the private key       | ✅️              |
| `/authentication/prove-ownership/{id}`        | POST       | Get an authentication token by signing a nonce                | ✅️              |
| `/authentication/verify-jwt`                  | POST       | Verify a signed jwt                                           |                 |
| **Identities**                                |            |                                                               |                 |
| `/identities/create`                          | POST       | Create a new decentralized digital identity (DID)             | ✅               |
| `/identities/search`                          | GET        | Search for identities                                         |                 |
| `/identities/identity/{id}`                   | GET        | Get information about a specific identity                     | ✅               |
| `/identities/identity/{id}`                   | DELETE     | Removes an identity from the Bridge                           |                 |
| `/identities/identity`                        | POST       | Register an existing identity into the Bridge                 |                 |
| `/identities/identity`                        | PUT        | Update claim of a registered identity                         |                 |
| **Verification**                              |            |                                                               |                 |
| `/verification/latest-document/{id}`          | GET        | Get the latest version of an identity document (DID)          |                 |
| `/verification/trusted-roots`                 | POST       | Adds Trusted Root identity identifiers (DIDs)                 |                 |
| `/verification/trusted-roots`                 | GET        | Returns a list of Trusted Root identity identifiers (DIDs)    |                 |
| `/verification/trusted-roots/{trustedRootId}` | DELETE     | Remove Trusted Root identity identifiers (DIDs)               |                 |
| `/verification/create-credential`             | POST       | Verify the authenticity of an identity and issue a credential |                 |
| `/verification/check-credential`              | POST       | Check the verifiable credential of an identity                | ✅               |
| `/verification/revoke-credential`             | POST       | Revoke one specific verifiable credential of an identity      |                 |
| **Misc**                                      |            |                                                               |                 |
| `/info`                                       | GET        | Get information about the server                              |                 |

For a full api reference please have a look at the official documentation: https://wiki.iota.org/integration-services/references/ssi_bridge_api_reference
