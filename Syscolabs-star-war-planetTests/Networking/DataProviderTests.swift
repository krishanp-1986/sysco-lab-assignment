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

final class DataProviderTests: QuickSpec {
    
    override class func spec() {
        describe("DefaultDataProvider") {
            var sut: DefaultDataProvider!
            context("When API returns success") {
                it("Should decode empty response") {
                    waitUntil(timeout: .seconds(2)) { done in
                        Task {
                            do {
                                let apiTarget = StubbedApiTarget(localJsonResourceName: "empty-response")
                                sut = .init()
                                let response: Response<[String: String]> = try await sut.execute(apiTarget: apiTarget)
                                expect(response.value).toNot(beNil())
                                expect(response.value).to(beEmpty())
                                
                            } catch {
                                fail("Expected success but got error: \(error)")
                            }
                            done()
                        }
                    }
                }
                
                it("Should decode valid response") {
                    waitUntil(timeout: .seconds(1)) { done in
                        Task {
                            do {
                                let apiTarget = StubbedApiTarget(localJsonResourceName: "valid-json-response")
                                sut = .init()
                                let response: Response<[String: String]> = try await sut.execute(apiTarget: apiTarget)
                                debugPrint("Response Value: \(response.value)")
                                expect(response.value).toNot(beNil())
                                expect(response.value).toNot(beEmpty())
                                expect(response.value) == ["key1": "value1", "key2": "value2"]
                                
                            } catch {
                                fail("Expected success but got error: \(error)")
                            }
                            done()
                        }
                    }
                }
                
                it("Should return error for invalid jsons") {
                    waitUntil(timeout: .seconds(1)) { done in
                        Task {
                            do {
                                let apiTarget = StubbedApiTarget(localJsonResourceName: "invalid-json")
                                sut = .init()
                                let response: Response<[String: String]> = try await sut.execute(apiTarget: apiTarget)
                                fail("Expected failure but got success with value: \(response.value)")
                                
                            } catch {
                                expect(error).to(matchError(NetworkingError.invalidData))
                            }
                            done()
                        }
                    }
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
                    
                    waitUntil(timeout: .seconds(2)) { done in
                        Task {
                            do {
                                let apiTarget = StubbedApiTarget(localJsonResourceName: nil, stubbingbehaviour: .none)
                                sut = .init()
                                let response: Response<[String: String]> = try await sut.execute(apiTarget: apiTarget)
                                fail("Expected failure but got success with value: \(response.value)")
                                
                            } catch {
                                expect(error).to(matchError(NetworkingError.error(NSError(
                                    domain: "",
                                    code: 400,
                                    userInfo: nil
                                ))))
                            }
                            done()
                        }
                    }
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
