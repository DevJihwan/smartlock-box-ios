//
//  UnlockChallengeView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct UnlockChallengeView: View {
    @EnvironmentObject var appState: AppStateManager
    @StateObject private var viewModel = UnlockChallengeViewModel()
    @State private var showResult = false
    
    var body: some View {
        ZStack {
            // 배경
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if viewModel.isEvaluating {
                EvaluatingView()
            } else if let result = viewModel.challengeResult, showResult {
                ResultView(result: result, onDismiss: {
                    if result.isSuccess {
                        appState.unlockDevice()
                    } else {
                        showResult = false
                        viewModel.challengeResult = nil
                    }
                })
            } else {
                ChallengeInputView(viewModel: viewModel, onSubmit: {
                    viewModel.submitChallenge { success in
                        showResult = true
                    }
                }, onCancel: {
                    appState.currentState = .locked
                })
            }
        }
    }
}

struct ChallengeInputView: View {
    @ObservedObject var viewModel: UnlockChallengeViewModel
    let onSubmit: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            // 헤더
            VStack(spacing: 8) {
                Image(systemName: "key.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("🗝️ 창의적 해제 도전")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("제시단어 2개를 포함한 창의적인\n문장을 만들어 자물쇠를 풀어보세요!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            // 단어 표시
            HStack(spacing: 20) {
                WordBubble(word: viewModel.challenge.word1)
                WordBubble(word: viewModel.challenge.word2)
            }
            .padding()
            
            // 입력 필드
            VStack(alignment: .leading, spacing: 8) {
                TextEditor(text: $viewModel.challenge.attempt)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.challenge.isValid ? Color.green : Color.gray.opacity(0.3), lineWidth: 2)
                    )
                
                HStack {
                    Text("최소 10글자 이상 (현재: \(viewModel.challenge.wordCount)글자)")
                        .font(.caption)
                        .foregroundColor(viewModel.challenge.wordCount >= 10 ? .green : .secondary)
                    
                    Spacer()
                    
                    if !viewModel.challenge.isValid && viewModel.challenge.wordCount >= 10 {
                        Text("⚠️ 두 단어를 모두 포함해주세요")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal)
            
            // 버튼들
            VStack(spacing: 12) {
                Button(action: onSubmit) {
                    Text("제출하기")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.challenge.isValid ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!viewModel.challenge.isValid)
                
                HStack {
                    Button(action: {
                        viewModel.refreshWords()
                    }) {
                        Text("다른 단어로 변경 (\(viewModel.remainingRefreshCount)회 남음)")
                            .font(.subheadline)
                    }
                    .disabled(viewModel.remainingRefreshCount == 0)
                    
                    Spacer()
                    
                    Button(action: onCancel) {
                        Text("취소")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal)
            
            Text("남은 도전 횟수: \(viewModel.remainingAttempts)회")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct WordBubble: View {
    let word: String
    
    var body: some View {
        Text(word)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
            .shadow(radius: 5)
    }
}

struct EvaluatingView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("🤖 AI가 평가 중입니다")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                HStack {
                    Text("ChatGPT 평가:")
                        .fontWeight(.medium)
                    Spacer()
                    ProgressView()
                    Text("진행중...")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Claude 평가:")
                        .fontWeight(.medium)
                    Spacer()
                    ProgressView()
                    Text("대기중...")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(15)
        }
        .padding(40)
    }
}

struct ResultView: View {
    let result: ChallengeResult
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            // 결과 아이콘
            Image(systemName: result.isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(result.isSuccess ? .green : .red)
            
            Text(result.isSuccess ? "✅ 해제 성공!" : "❌ 해제 실패")
                .font(.title)
                .fontWeight(.bold)
            
            // AI 평가 결과
            VStack(spacing: 16) {
                EvaluationResultRow(title: "ChatGPT 평가", result: result.chatGPTResult)
                EvaluationResultRow(title: "Claude 평가", result: result.claudeResult)
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(15)
            
            if result.isSuccess {
                Text("🔓 자물쇠가 열렸습니다!")
                    .font(.headline)
                    .foregroundColor(.green)
            } else {
                Text("두 AI 모두 통과해야 해제됩니다")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Button(action: onDismiss) {
                Text(result.isSuccess ? "메인으로 돌아가기" : "다시 도전하기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(result.isSuccess ? Color.green : Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
        .padding(40)
    }
}

struct EvaluationResultRow: View {
    let title: String
    let result: AIEvaluationResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .fontWeight(.semibold)
                Spacer()
                if case .pass = result {
                    Text("PASS ✅")
                        .foregroundColor(.green)
                } else if case .fail = result {
                    Text("FAIL ❌")
                        .foregroundColor(.red)
                }
            }
            
            if case .pass(let feedback) = result {
                Text(feedback)
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else if case .fail(let feedback) = result {
                Text(feedback)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct UnlockChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        UnlockChallengeView()
            .environmentObject(AppStateManager())
    }
}
