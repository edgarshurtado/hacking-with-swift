//
//  GameStatus.swift
//  p12-challenge03-word-scramble
//
//  Created by Edgar Sánchez Hurtado on 28/5/24.
//

import Foundation

struct GameStatus: Codable {
    var currentWord: String
    var usedWords: [String] = []
}
