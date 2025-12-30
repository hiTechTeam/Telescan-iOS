//
//  FetchServiceTests.swift
//  TelescaniOS
//

import Testing
import Foundation
import CryptoKit
@testable import Telescan

@Suite("FetchService – basic tests (no mocks)")
struct FetchServiceTests {
    
    @Test("Singleton returns the same instance")
    func singletonReturnsSameInstance() {
        let instanceA = FetchService.fetch
        let instanceB = FetchService.fetch
        
        #expect(instanceA === instanceB)
    }
    @Test("SHA256 produces correct hash")
    func sha256ProducesExpectedHash() {
        let input = "test"
        let expected =
        "9f86d081884c7d659a2feaa0c55ad015" +
        "a3bf4f1b2b0b822cd15d6c15b0f00a08"
        
        let result = FetchService.fetch.sha256(input)
        
        #expect(result == expected)
    }
    @Test("SHA256 is deterministic")
    func sha256IsDeterministic() {
        let input = "hello world"
        
        let hash1 = FetchService.fetch.sha256(input)
        let hash2 = FetchService.fetch.sha256(input)
        
        #expect(hash1 == hash2)
    }
    @Test("SHA256 produces different hashes for different inputs")
    func sha256DifferentInputs() {
        let hash1 = FetchService.fetch.sha256("hello")
        let hash2 = FetchService.fetch.sha256("world")
        
        #expect(hash1 != hash2)
    }
    @Test("SHA256 of empty string is valid")
    func sha256EmptyString() {
        let result = FetchService.fetch.sha256("")
        
        #expect(result.count == 64)
    }
    @Test("SHA256 output contains only hex characters")
    func sha256IsHexString() {
        let hash = FetchService.fetch.sha256("hex-test")
        
        let hexChars = CharacterSet(charactersIn: "0123456789abcdef")
        let hashChars = CharacterSet(charactersIn: hash)
        
        #expect(hexChars.isSuperset(of: hashChars))
    }
}
