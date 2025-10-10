//
//  AIEvaluationService.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import Combine

class AIEvaluationService {
    static let shared = AIEvaluationService()
    
    private let openAIAPIKey = "" // TODO: 환경변수로 관리
    private let anthropicAPIKey = "" // TODO: 환경변수로 관리
    
    private init() {}
    
    func evaluateWithChatGPT(sentence: String, word1: String, word2: String) -> AnyPublisher<AIEvaluationResult, Error> {
        // TODO: OpenAI API 호출 구현
        // 임시 목 응답
        return Future<AIEvaluationResult, Error> { promise in
            // 시뮬레이션: 2초 후 결과 반환
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let isPass = Bool.random()
                if isPass {
                    promise(.success(.pass(feedback: "창의적이고 감성적인 표현")))
                } else {
                    promise(.success(.fail(feedback: "단순한 단어 나열")))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func evaluateWithClaude(sentence: String, word1: String, word2: String) -> AnyPublisher<AIEvaluationResult, Error> {
        // TODO: Anthropic Claude API 호출 구현
        // 임시 목 응답
        return Future<AIEvaluationResult, Error> { promise in
            // 시뮬레이션: 2초 후 결과 반환
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let isPass = Bool.random()
                if isPass {
                    promise(.success(.pass(feedback: "두 단어의 조화로운 활용")))
                } else {
                    promise(.success(.fail(feedback: "의미적 연관성 부족")))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func callOpenAIAPI(sentence: String, word1: String, word2: String) async throws -> AIEvaluationResult {
        // OpenAI API 호출 로직
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = """
        다음 문장을 평가해주세요:
        문장: "\(sentence)"
        필수 단어: "\(word1)", "\(word2)"
        
        평가 기준:
        1. 두 단어가 모두 포함되어 있는가?
        2. 창의적이고 독창적인가?
        3. 문법적으로 올바른가?
        4. 의미적으로 연관성이 있는가?
        
        PASS 또는 FAIL로 판정하고, 간단한 피드백을 주세요.
        """
        
        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "system", "content": "당신은 창의력을 평가하는 전문가입니다."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        // TODO: API 호출 및 응답 파싱
        throw NSError(domain: "AIEvaluationService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }
    
    private func callClaudeAPI(sentence: String, word1: String, word2: String) async throws -> AIEvaluationResult {
        // Anthropic Claude API 호출 로직
        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(anthropicAPIKey, forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        let prompt = """
        다음 문장을 평가해주세요:
        문장: "\(sentence)"
        필수 단어: "\(word1)", "\(word2)"
        
        평가 기준:
        1. 두 단어가 모두 포함되어 있는가?
        2. 창의적이고 독창적인가?
        3. 문법적으로 올바른가?
        4. 의미적으로 연관성이 있는가?
        
        PASS 또는 FAIL로 판정하고, 간단한 피드백을 주세요.
        """
        
        let body: [String: Any] = [
            "model": "claude-3-opus-20240229",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 1024
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        // TODO: API 호출 및 응답 파싱
        throw NSError(domain: "AIEvaluationService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }
}
