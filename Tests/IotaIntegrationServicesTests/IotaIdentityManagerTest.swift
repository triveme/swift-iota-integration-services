import XCTest
import IotaIntegrationServices

final class IotaIdentityManagerTest: XCTestCase {

    let iotaIS = IotaIntegrationServices.shared
    var testHelper = try! TestHelper()

    override func setUpWithError() throws {    }

    override func tearDownWithError() throws {
        iotaIS.identityManager.forgetIdentity()
    }

    func testCreateIdentity() async throws {
        let iotaIdentityBodySchema = iotaIS.identityManager.createIdentityBodySchema(
                identityClaim: IotaIdentityClaim.organization(.init(name: "test")))
        let iotaIdentity = try await iotaIS.identityManager.createIdentity(identityBodySchema: iotaIdentityBodySchema)

        XCTAssertNotNil(iotaIdentity)
    }

    func testGetIdentity() async throws {
        try await iotaIS.identityManager.setupIdentity(iotaIdentityKeys: testHelper.userIdentity)
        let iotaIdentity = try await iotaIS.identityManager.getIdentity(did: testHelper.userIdentity.id)

        XCTAssertNotNil(iotaIdentity)
    }

    func testSetupComplete() async throws {
        try await iotaIS.identityManager.setupIdentity(iotaIdentityKeys: testHelper.userIdentity)
        XCTAssertTrue(iotaIS.identityManager.setupComplete)
    }
}
