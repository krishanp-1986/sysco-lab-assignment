//
//  DataProviderTests.swift
//  Syscolabs-star-war-planetTests
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import XCTest
import Quick
import Nimble
@testable import Syscolabs_star_war_planet

final class DataProviderTests: AsyncSpec {
    
    override class func spec() {
        describe("DefaultDataProvider") {
            var sut: DefaultDataProvider!
            context("When API returns success") {
                it("Should decode empty response") {
                    let apiTarget = StubbedApiTarget(localJsonResourceName: "empty-response")
                    sut = .init()
                    let response: Response<[String: String]> = try await sut.execute(apiTarget: apiTarget)
                    expect(response.value).toNot(beNil())
                    expect(response.value).to(beEmpty())
                }
                
                it("Should decode valid response") {
                    let apiTarget = StubbedApiTarget(localJsonResourceName: "valid-json-response")
                    sut = .init()
                    let response: Response<[String: String]> = try await sut.execute(apiTarget: apiTarget)
                    debugPrint("Response Value: \(response.value)")
                    expect(response.value).toNot(beNil())
                    expect(response.value).toNot(beEmpty())
                    expect(response.value) == ["key1": "value1", "key2": "value2"]
                }
                
                it("Should return error for invalid jsons") {
                    let apiTarget = StubbedApiTarget(localJsonResourceName: "invalid-json")
                    sut = .init()
                    await expect {
                        let _: Response<[String: String]> = try await sut.execute(apiTarget: apiTarget)
                      }.to(throwError { error in
                          expect(error).to(matchError(NetworkingError.invalidData))
                      })
                }
            }
            
            context("When API Fails") {
                beforeEach {
                    URLProtocol.registerClass(TestURLProtocol.self)
                }
                afterEach {
                    URLProtocol.unregisterClass(TestURLProtocol.self)
                }
                
                it(" With Response Should return Networking error) ") {
                    TestURLProtocol.loadingHandler = { request in
                        let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
                        return (response, .init(), nil)
                    }
                    let apiTarget = StubbedApiTarget(localJsonResourceName: nil, stubbingbehaviour: .none)
                    sut = .init()
                    
                    await expect {
                        let _: Response<[String: String]> = try await sut.execute(apiTarget: apiTarget)
                      }.to(throwError { error in
                          expect(error).to(matchError(NetworkingError.error(NSError(
                            domain: "",
                            code: 400,
                            userInfo: nil
                        ))))
                      })
                }
            }
            
        }
    }
}

final class TestBundle {
    static let bundle = Bundle(for: TestBundle.self)
}

struct StubbedApiTarget: APITarget {
    
    init(localJsonResourceName: String?, stubbingbehaviour: StubbingBehaviour = .immediate) {
        self.localJsonResourceName = localJsonResourceName
        self.stubbingBehaviour = stubbingbehaviour
    }
    
    var request: URLRequest = .init(url: URL(string: "mock-request")!)
    var httpMethod: HttpMethod = .get
    
    var stubbingBehaviour: StubbingBehaviour
    var localJsonResourceName: String?
    
    var bundle: Bundle {
        TestBundle.bundle
    }
    
    var directory: String? = nil
}
