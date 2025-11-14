//
//  AIEvaluationService.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import Combine

// MARK: - Models

struct EvaluationResponse: Codable {
    let result: String  // "PASS" or "FAIL"
    let feedback: String
}

enum AIProvider: String {
    case openai = "OpenAI GPT-4"
    case claude = "Anthropic Claude"
}

// MARK: - AIEvaluationService

class AIEvaluationService {
    static let shared = AIEvaluationService()
    
    // API Keys - 실제 사용 시 Config.plist나 환경변수에서 로드
    private var openAIAPIKey: String {
        return getAPIKey(for: "OPENAI_API_KEY") ?? ""
    }
    
    private var anthropicAPIKey: String {
        return getAPIKey(for: "ANTHROPIC_API_KEY") ?? ""
    }
    
    private let timeout: TimeInterval = 30.0
    private let maxRetries = 2
    
    // 일일 평가 제한
    private let maxDailyEvaluations = 10
    private var dailyEvaluationCount: Int {
        get {
            UserDefaults.standard.integer(forKey: "dailyEvaluationCount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "dailyEvaluationCount")
        }
    }
    
    private var lastEvaluationDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastEvaluationDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastEvaluationDate")
        }
    }
    
    private init() {
        checkAndResetDailyCount()
    }
    
    // MARK: - API Key Management

    /// API 키 로드 (Config.xcconfig → Info.plist → 환경변수 순서로 시도)
    private func getAPIKey(for key: String) -> String? {
        print("🔍 [\(key)] API 키 로드 시작...")

        // Priority 1: Info.plist에서 읽기 (xcconfig에서 주입된 값)
        if let plistKey = Bundle.main.object(forInfoDictionaryKey: key) as? String,
           !plistKey.isEmpty && !plistKey.hasPrefix("$") && !plistKey.hasPrefix("{") {
            print("✅ [\(key)] Info.plist에서 API 키 로드 성공")
            print("🔍 [\(key)] 키 시작: \(String(plistKey.prefix(15)))...")
            return plistKey
        }

        // Priority 2: Config.xcconfig 파일에서 직접 읽기
        if let configPath = Bundle.main.path(forResource: "Config", ofType: "xcconfig") {
            do {
                let configContent = try String(contentsOfFile: configPath, encoding: .utf8)
                print("🔍 [\(key)] Config.xcconfig 파일 발견")

                let lines = configContent.components(separatedBy: .newlines)
                for line in lines {
                    let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmedLine.hasPrefix(key) && trimmedLine.contains("=") {
                        let parts = trimmedLine.components(separatedBy: "=")
                        if parts.count >= 2 {
                            let keyValue = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                            if !keyValue.isEmpty {
                                print("✅ [\(key)] Config.xcconfig에서 API 키 로드 성공")
                                print("🔍 [\(key)] 키 시작: \(String(keyValue.prefix(15)))...")
                                return keyValue
                            }
                        }
                    }
                }
                print("❌ [\(key)] Config.xcconfig에서 키를 찾을 수 없음")
            } catch {
                print("❌ [\(key)] Config.xcconfig 읽기 오류: \(error)")
            }
        } else {
            print("❌ [\(key)] Config.xcconfig 파일을 찾을 수 없음")
        }

        // Priority 3: 환경 변수에서 확인
        if let envKey = ProcessInfo.processInfo.environment[key], !envKey.isEmpty {
            print("✅ [\(key)] 환경 변수에서 API 키 로드 성공")
            return envKey
        }

        print("❌ [\(key)] 모든 방법으로 API 키 로드 실패")
        return nil
    }
    
    // MARK: - Daily Limit Management
    
    private func checkAndResetDailyCount() {
        if let lastDate = lastEvaluationDate, !Calendar.current.isDateInToday(lastDate) {
            dailyEvaluationCount = 0
        }
    }
    
    func canEvaluate() -> Bool {
        checkAndResetDailyCount()
        return dailyEvaluationCount < maxDailyEvaluations
    }
    
    var remainingEvaluations: Int {
        checkAndResetDailyCount()
        return max(0, maxDailyEvaluations - dailyEvaluationCount)
    }
    
    private func incrementEvaluationCount() {
        dailyEvaluationCount += 1
        lastEvaluationDate = Date()
    }
    
    // MARK: - Public Evaluation Methods
    
    /// 두 AI 모두로 평가 (이중 검증)
    func evaluateBoth(sentence: String, word1: String, word2: String) async throws -> (openai: AIEvaluationResult, claude: AIEvaluationResult) {
        guard canEvaluate() else {
            throw NSError(
                domain: "AIEvaluationService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "일일 평가 횟수 초과 (최대 \(maxDailyEvaluations)회)"]
            )
        }
        
        // 기본 검증
        guard !sentence.isEmpty, !word1.isEmpty, !word2.isEmpty else {
            throw NSError(
                domain: "AIEvaluationService",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "문장 또는 단어가 비어있습니다"]
            )
        }
        
        guard sentence.count >= 10 else {
            throw NSError(
                domain: "AIEvaluationService",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "문장은 최소 10글자 이상이어야 합니다"]
            )
        }
        
        incrementEvaluationCount()
        
        // 두 AI 동시 평가
        async let openaiResult = evaluateWithOpenAI(sentence: sentence, word1: word1, word2: word2)
        async let claudeResult = evaluateWithClaude(sentence: sentence, word1: word1, word2: word2)
        
        return try await (openaiResult, claudeResult)
    }
    
    // MARK: - OpenAI API
    
    private func evaluateWithOpenAI(sentence: String, word1: String, word2: String) async throws -> AIEvaluationResult {
        guard !openAIAPIKey.isEmpty else {
            // API 키가 없으면 개발 모드로 동작 (랜덤 결과)
            return developmentModeEvaluation(provider: .openai)
        }
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = "POST"
        request.addValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = createEvaluationPrompt(sentence: sentence, word1: word1, word2: word2)
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini", // 저렴하고 빠른 모델 사용
            "messages": [
                ["role": "system", "content": "당신은 창의력을 평가하는 전문가입니다. 주어진 문장의 창의성을 평가하고, PASS 또는 FAIL로 판정합니다. 응답은 반드시 JSON 형식으로 {\"result\": \"PASS\", \"feedback\": \"...\"} 또는 {\"result\": \"FAIL\", \"feedback\": \"...\"}로 작성하세요."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 150
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "AIEvaluationService", code: -4, userInfo: [NSLocalizedDescriptionKey: "잘못된 응답 형식"])
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "AIEvaluationService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API 오류: \(httpResponse.statusCode)"])
        }
        
        return try parseOpenAIResponse(data)
    }
    
    private func parseOpenAIResponse(_ data: Data) throws -> AIEvaluationResult {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let choices = json?["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw NSError(domain: "AIEvaluationService", code: -5, userInfo: [NSLocalizedDescriptionKey: "응답 파싱 실패"])
        }
        
        // JSON 추출 (content에서 JSON 부분만 추출)
        if let jsonData = content.data(using: .utf8),
           let evaluation = try? JSONDecoder().decode(EvaluationResponse.self, from: jsonData) {
            return evaluation.result.uppercased() == "PASS" 
                ? .pass(feedback: evaluation.feedback)
                : .fail(feedback: evaluation.feedback)
        }
        
        // JSON 파싱 실패 시 텍스트 분석
        let upperContent = content.uppercased()
        if upperContent.contains("PASS") {
            return .pass(feedback: content)
        } else {
            return .fail(feedback: content)
        }
    }
    
    // MARK: - Anthropic Claude API
    
    private func evaluateWithClaude(sentence: String, word1: String, word2: String) async throws -> AIEvaluationResult {
        guard !anthropicAPIKey.isEmpty else {
            // API 키가 없으면 개발 모드로 동작
            return developmentModeEvaluation(provider: .claude)
        }
        
        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = "POST"
        request.addValue(anthropicAPIKey, forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        let prompt = createEvaluationPrompt(sentence: sentence, word1: word1, word2: word2)
        
        let body: [String: Any] = [
            "model": "claude-3-haiku-20240307", // 저렴하고 빠른 모델 사용
            "max_tokens": 150,
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "AIEvaluationService", code: -4, userInfo: [NSLocalizedDescriptionKey: "잘못된 응답 형식"])
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "AIEvaluationService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API 오류: \(httpResponse.statusCode)"])
        }
        
        return try parseClaudeResponse(data)
    }
    
    private func parseClaudeResponse(_ data: Data) throws -> AIEvaluationResult {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let content = json?["content"] as? [[String: Any]],
              let firstContent = content.first,
              let text = firstContent["text"] as? String else {
            throw NSError(domain: "AIEvaluationService", code: -5, userInfo: [NSLocalizedDescriptionKey: "응답 파싱 실패"])
        }
        
        // JSON 추출 시도
        if let jsonData = text.data(using: .utf8),
           let evaluation = try? JSONDecoder().decode(EvaluationResponse.self, from: jsonData) {
            return evaluation.result.uppercased() == "PASS"
                ? .pass(feedback: evaluation.feedback)
                : .fail(feedback: evaluation.feedback)
        }
        
        // 텍스트 분석
        let upperText = text.uppercased()
        if upperText.contains("PASS") {
            return .pass(feedback: text)
        } else {
            return .fail(feedback: text)
        }
    }
    
    // MARK: - Helper Methods
    
    private func createEvaluationPrompt(sentence: String, word1: String, word2: String) -> String {
        return """
        다음 문장을 평가해주세요:
        
        문장: "\(sentence)"
        필수 단어: "\(word1)", "\(word2)"
        
        평가 기준:
        1. 두 단어가 모두 문장에 포함되어 있는가?
        2. 문장이 창의적이고 독창적인가?
        3. 문법적으로 올바른가?
        4. 의미적 연관성이 있는가?
        5. 단순한 단어 나열이 아닌, 의미 있는 문장인가?
        
        결과:
        - 모든 기준을 만족하면 "PASS"
        - 하나도 만족하지 못하면 "FAIL"
        
        응답 형식 (JSON):
        {"result": "PASS", "feedback": "구체적인 피드백"}
        또는
        {"result": "FAIL", "feedback": "구체적인 피드백"}
        """
    }
    
    /// 개발 모드 평가 (API 키 없을 때)
    private func developmentModeEvaluation(provider: AIProvider) -> AIEvaluationResult {
        print("⚠️ 개발 모드: \(provider.rawValue) API 키 없음 - 랜덤 결과 반환")
        
        let isPass = Bool.random()
        let feedbacks = isPass
            ? ["창의적이고 감성적인 표현", "두 단어의 조화로운 활용", "독창적인 문장 구성"]
            : ["단순한 단어 나열", "의미적 연관성 부족", "창의성이 부족함"]
        
        let feedback = feedbacks.randomElement() ?? ""
        return isPass ? .pass(feedback: feedback) : .fail(feedback: feedback)
    }
}

// MARK: - Combine Publishers (기존 호환성)

extension AIEvaluationService {
    func evaluateWithChatGPT(sentence: String, word1: String, word2: String) -> AnyPublisher<AIEvaluationResult, Error> {
        return Future { promise in
            Task {
                do {
                    let result = try await self.evaluateWithOpenAI(sentence: sentence, word1: word1, word2: word2)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func evaluateWithClaude(sentence: String, word1: String, word2: String) -> AnyPublisher<AIEvaluationResult, Error> {
        return Future { promise in
            Task {
                do {
                    let result = try await self.evaluateWithClaude(sentence: sentence, word1: word1, word2: word2)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
