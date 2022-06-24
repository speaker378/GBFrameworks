//
//  Crypto.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 24.06.2022.
//

import Foundation
import CryptoKit

final class Crypto {
    static func hash(_ string: String) -> String {
        let digest = SHA256.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02x", $0)
        }.joined()
    }
}
