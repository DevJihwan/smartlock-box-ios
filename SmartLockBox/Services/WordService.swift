//
//  WordService.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation

// MARK: - Word Model
struct Word: Codable, Identifiable, Equatable {
    let id: Int
    let korean: String
    let english: String
    let category: String
    let difficulty: String

    // Computed property for backward compatibility
    var word: String {
        return korean
    }
}

struct WordDatabase: Codable {
    let words: [Word]
}

// MARK: - WordService
class WordService {
    static let shared = WordService()
    
    private var wordDatabase: [Word] = []
    private var dailyRefreshCount: Int = 0
    private var lastRefreshDate: Date?
    private let maxDailyRefreshes = 3
    
    // UserDefaults keys
    private let refreshCountKey = "wordRefreshCount"
    private let lastRefreshDateKey = "lastRefreshDate"
    
    private init() {
        loadWordDatabase()
        loadRefreshData()
    }
    
    // MARK: - Database Loading
    
    /// Words.json 파일에서 단어 데이터베이스 로드
    private func loadWordDatabase() {
        guard let url = Bundle.main.url(forResource: "Words", withExtension: "json") else {
            print("❌ Words.json 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let database = try decoder.decode(WordDatabase.self, from: data)
            wordDatabase = database.words
            print("✅ 단어 데이터베이스 로드 완료: \(wordDatabase.count)개 단어")
        } catch {
            print("❌ Words.json 파싱 실패: \(error.localizedDescription)")
        }
    }
    
    /// UserDefaults에서 새로고침 데이터 로드
    private func loadRefreshData() {
        dailyRefreshCount = UserDefaults.standard.integer(forKey: refreshCountKey)
        
        if let savedDate = UserDefaults.standard.object(forKey: lastRefreshDateKey) as? Date {
            lastRefreshDate = savedDate
            
            // 날짜가 바뀌었으면 카운트 리셋
            if !Calendar.current.isDateInToday(savedDate) {
                resetDailyRefreshCount()
            }
        }
    }
    
    /// 일일 새로고침 카운트 리셋
    private func resetDailyRefreshCount() {
        dailyRefreshCount = 0
        UserDefaults.standard.set(dailyRefreshCount, forKey: refreshCountKey)
    }
    
    /// 새로고침 카운트 증가
    private func incrementRefreshCount() {
        dailyRefreshCount += 1
        lastRefreshDate = Date()
        
        UserDefaults.standard.set(dailyRefreshCount, forKey: refreshCountKey)
        UserDefaults.standard.set(lastRefreshDate, forKey: lastRefreshDateKey)
    }
    
    // MARK: - Public Methods
    
    /// 랜덤하게 지정된 개수만큼 단어 선택
    /// - Parameter count: 선택할 단어 개수
    /// - Returns: 서로 다른 단어 배열
    func getRandomWords(count: Int) -> [Word] {
        guard wordDatabase.count >= count else {
            print("❌ 단어가 부족합니다. (필요: \(count), 보유: \(wordDatabase.count))")
            return []
        }
        
        var selectedWords: [Word] = []
        var availableWords = wordDatabase.shuffled()
        
        while selectedWords.count < count && !availableWords.isEmpty {
            let word = availableWords.removeFirst()
            // 중복 방지
            if !selectedWords.contains(where: { $0.word == word.word }) {
                selectedWords.append(word)
            }
        }
        
        return selectedWords
    }
    
    /// 랜덤하게 2개의 단어 선택 (하위 호환성)
    /// - Returns: 2개의 서로 다른 단어 배열
    func getRandomTwoWords() -> [Word] {
        return getRandomWords(count: 2)
    }
    
    /// 카테고리별로 단어 필터링
    /// - Parameter category: 카테고리 ("명사", "동사", "형용사", "추상명사")
    /// - Returns: 해당 카테고리의 단어 배열
    func getWordsByCategory(_ category: String) -> [Word] {
        return wordDatabase.filter { $0.category == category }
    }
    
    /// 난이도별로 단어 필터링
    /// - Parameter difficulty: 난이도 ("easy", "medium", "hard")
    /// - Returns: 해당 난이도의 단어 배열
    func getWordsByDifficulty(_ difficulty: String) -> [Word] {
        return wordDatabase.filter { $0.difficulty == difficulty }
    }
    
    /// 새로고침 가능 여부 확인
    /// - Returns: 오늘 새로고침 가능하면 true
    func canRefresh() -> Bool {
        // 날짜가 바뀌었으면 리셋
        if let lastDate = lastRefreshDate, !Calendar.current.isDateInToday(lastDate) {
            resetDailyRefreshCount()
        }
        
        return dailyRefreshCount < maxDailyRefreshes
    }
    
    /// 남은 새로고침 횟수
    var remainingRefreshes: Int {
        return max(0, maxDailyRefreshes - dailyRefreshCount)
    }
    
    /// 단어 새로고침 (일일 제한 적용)
    /// - Returns: 성공 시 true, 제한 초과 시 false
    @discardableResult
    func refreshWords() -> Bool {
        guard canRefresh() else {
            print("⚠️ 오늘의 새로고침 횟수를 모두 사용했습니다.")
            return false
        }
        
        incrementRefreshCount()
        print("✅ 단어 새로고침 완료 (남은 횟수: \(remainingRefreshes))")
        return true
    }
    
    /// 특정 단어 검색
    /// - Parameter query: 검색어
    /// - Returns: 검색어를 포함하는 단어 배열
    func searchWords(query: String) -> [Word] {
        guard !query.isEmpty else { return [] }
        return wordDatabase.filter {
            $0.korean.contains(query) || $0.english.lowercased().contains(query.lowercased())
        }
    }
    
    /// 전체 단어 개수
    var totalWordCount: Int {
        return wordDatabase.count
    }
    
    /// 카테고리별 통계
    var categoryStatistics: [String: Int] {
        var stats: [String: Int] = [:]
        for word in wordDatabase {
            stats[word.category, default: 0] += 1
        }
        return stats
    }
}
