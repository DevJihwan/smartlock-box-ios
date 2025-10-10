//
//  UnlockChallengeViewModel.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import Combine

class UnlockChallengeViewModel: ObservableObject {
    @Published var challenge: UnlockChallenge
    @Published var isEvaluating = false
    @Published var challengeResult: ChallengeResult?
    @Published var remainingRefreshCount = 3
    @Published var remainingAttempts = 10
    
    private let wordService = WordService.shared
    private let aiService = AIEvaluationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let words = wordService.getRandomWords(count: 2)
        self.challenge = UnlockChallenge(word1: words[0], word2: words[1])
    }
    
    func refreshWords() {
        guard remainingRefreshCount > 0 else { return }
        
        let words = wordService.getRandomWords(count: 2)
        challenge = UnlockChallenge(word1: words[0], word2: words[1])
        remainingRefreshCount -= 1
    }
    
    func submitChallenge(completion: @escaping (Bool) -> Void) {
        guard challenge.isValid else {
            completion(false)
            return
        }
        
        guard remainingAttempts > 0 else {
            completion(false)
            return
        }
        
        isEvaluating = true
        remainingAttempts -= 1
        
        // ChatGPT와 Claude 동시 평가
        let chatGPTPublisher = aiService.evaluateWithChatGPT(sentence: challenge.attempt, word1: challenge.word1, word2: challenge.word2)
        let claudePublisher = aiService.evaluateWithClaude(sentence: challenge.attempt, word1: challenge.word1, word2: challenge.word2)
        
        Publishers.Zip(chatGPTPublisher, claudePublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionStatus in
                self?.isEvaluating = false
                if case .failure = completionStatus {
                    completion(false)
                }
            }, receiveValue: { [weak self] chatGPTResult, claudeResult in
                self?.challengeResult = ChallengeResult(
                    chatGPTResult: chatGPTResult,
                    claudeResult: claudeResult
                )
                completion(self?.challengeResult?.isSuccess ?? false)
            })
            .store(in: &cancellables)
    }
}
