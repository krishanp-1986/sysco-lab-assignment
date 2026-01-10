//
//  JsonUtilsTest.swift
//  Syscolabs-star-war-planetTests
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import XCTest
import Quick
import Nimble
@testable import Syscolabs_star_war_planet

class JsonUtilsTests: QuickSpec {
    override class func spec() {
       let bundle = Bundle(for: JsonUtilsTests.self)
    describe("json utility") {
      context("for valid json") {
        it("should convert into decodable") {
            let decoded = JsonUtils.convertJsonInto(type: [String: String].self,
                                                           fileName: "valid-json-response",
                                                           bundle: bundle, inDirectory: nil)
          expect(decoded).toNot(beNil())
          expect(decoded?.keys.count) == 2
        }
      }
      
      context("for valid json file") {
        it("should return planets response dto") {
            let decoded = JsonUtils.convertJsonInto(type: [Planet].self,
                                                           fileName: "planets",
                                                           bundle: bundle,
                                                           inDirectory: nil)
          expect(decoded).toNot(beNil())
        }
      }
      
      
      context("for empty json") {
        it("should convert into decodable ") {
          let decoded = JsonUtils.convertJsonInto(type: [String: String].self,
                                                           fileName: "empty-response",
                                                           bundle: bundle, inDirectory: nil)
          expect(decoded).toNot(beNil())
          expect(decoded?.keys).to(beEmpty())
        }
      }
      
      context("for invalid json") {
        it("should return nil") {
            let decoded = JsonUtils.convertJsonInto(type: [String: String].self,
                                                           fileName: "invalid-json",
                                                           bundle: bundle, inDirectory: nil)
          expect(decoded).to(beNil())
        }
      }
      
    }
  }
}


