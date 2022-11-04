import XCTest
import IotaIntegrationServices

final class IotaVerifiableCredentialManagerTest: XCTestCase {

    var iotaIS = IotaIntegrationServices.shared
    var testHelper = try! TestHelper()
    
    override func setUpWithError() throws {    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetVerifiableCredentials() async throws {
        try await iotaIS.identityManager.setupIdentity(iotaIdentityKeys: testHelper.userIdentity)
        let iotaIdentity = try await iotaIS.identityManager.getIdentity(did: testHelper.userIdentity.id)
        XCTAssertNotNil(iotaIdentity.verifiableCredentials)
    }
    
    func testDecodeEmailCredential() throws {
        let jsonData = try TestHelper.readJsonFile(forName: "emailVC")
        let emailCredential: IotaVerifiableCredentialSchema = try JSONDecoder().decode(IotaVerifiableCredentialSchema.self, from: jsonData)
        
        XCTAssertNotNil(emailCredential)
    }

    func testDecodePaymentCredential() throws {
        let jsonData = try TestHelper.readJsonFile(forName: "paymentVC")
        let paymentCredential: IotaVerifiableCredentialSchema = try JSONDecoder().decode(IotaVerifiableCredentialSchema.self, from: jsonData)

        XCTAssertNotNil(paymentCredential)
    }

}
