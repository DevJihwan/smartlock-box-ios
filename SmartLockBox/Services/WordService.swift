//
//  WordService.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation

class WordService {
    static let shared = WordService()
    
    private var wordDatabase: [String] = []
    
    private init() {
        loadWordDatabase()
    }
    
    private func loadWordDatabase() {
        // TODO: JSON 파일에서 단어 로드
        // 임시 샘플 단어
        wordDatabase = [
            "바다", "꽃", "책", "노래", "꿈",
            "별", "사랑", "여행", "커피", "비",
            "하늘", "시간", "추억", "길", "창문",
            "음악", "그림", "봄", "가을", "결심",
            "희망", "미래", "열정", "평화", "자유",
            "행복", "친구", "가족", "집", "학교",
            "핸드폰", "컴퓨터", "책상", "거울", "시계",
            "우산", "신발", "오이", "타임머신", "우주"
        ]
    }
    
    func getRandomWords(count: Int) -> [String] {
        guard count <= wordDatabase.count else {
            return Array(wordDatabase.shuffled().prefix(count))
        }
        return Array(wordDatabase.shuffled().prefix(count))
    }
    
    func searchWords(query: String) -> [String] {
        return wordDatabase.filter { $0.contains(query) }
    }
}
