import Foundation
import IotaIntegrationServices

class TestHelper {

    let jsonDecoder = JSONDecoder()

    let urlSchema: String = "http"
    let urlHost: String = "localhost"
    let urlPort: Int = 3000
    let urlPath: String = "/api/v0.2"
    let apiKey: String = "4ed59704-9a26-11ec-a749-3f57454709b9"

    let adminIdentity: IotaIdentityKeysSchema
    let bankIdentity: IotaIdentityKeysSchema
    let userIdentity: IotaIdentityKeysSchema

    public init() throws {
        let iotaIS = IotaIntegrationServices.shared
        iotaIS.setup(schema: urlSchema, host: urlHost, port: urlPort, path: urlPath, apiKey: apiKey)

        let adminIdentityJsonData = try TestHelper.readJsonFile(forName: "adminIdentity")
        let bankIdentityJsonData = try TestHelper.readJsonFile(forName: "bankIdentity")
        let userIdentityJsonData = try TestHelper.readJsonFile(forName: "userIdentity")

        self.adminIdentity = try TestHelper.parseIdentity(jsonData: adminIdentityJsonData)
        self.bankIdentity = try TestHelper.parseIdentity(jsonData: bankIdentityJsonData)
        self.userIdentity = try TestHelper.parseIdentity(jsonData: userIdentityJsonData)
    }

    public static func readJsonFile(forName name: String) throws -> Data {
        if let fileUrl = Bundle.module.url(forResource: name, withExtension: "json") {
            let data = try Data(contentsOf: fileUrl)
            return data
        } else {
            throw TestError.resourceNotFound
        }
    }

    public static func parseIdentity(jsonData: Data) throws -> IotaIdentityKeysSchema {
        let decodedData = try JSONDecoder().decode(IotaIdentityKeysSchema.self, from: jsonData)
        return decodedData
    }
}

enum TestError: Error {
    case setupError(message: String)
    case resourceNotFound
}
