//
//  UnlockChallenge.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation

struct UnlockChallenge {
    let word1: String
    let word2: String
    var attempt: String = ""
    
    var wordCount: Int {
        return attempt.count
    }
    
    var isValid: Bool {
        return wordCount >= 10 && 
               attempt.contains(word1) && 
               attempt.contains(word2)
    }
}

enum AIEvaluationResult {
    case pending
    case evaluating
    case pass(feedback: String)
    case fail(feedback: String)
}

struct ChallengeResult {
    let chatGPTResult: AIEvaluationResult
    let claudeResult: AIEvaluationResult
    
    var isSuccess: Bool {
        if case .pass = chatGPTResult, case .pass = claudeResult {
            return true
        }
        return false
    }
}
