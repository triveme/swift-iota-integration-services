import XCTest
import IotaIntegrationServices

final class IotaAuthenticationManagerTest: XCTestCase {

    let iotaIS = IotaIntegrationServices.shared
    var testHelper = try! TestHelper()

    override func setUpWithError() throws {    }

    override func tearDownWithError() throws {}

    func testAuthentication() async throws {
        let iotaJwt = try await iotaIS.authManager.authenticate(iotaIdentityKeys: testHelper.adminIdentity)
        XCTAssertNotNil(iotaJwt.jwt)
    }

}