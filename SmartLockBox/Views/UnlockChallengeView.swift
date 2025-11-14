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
            backgroundView
            
            if viewModel.isEvaluating {
                EvaluatingView()
            } else if let result = viewModel.challengeResult, showResult {
                ResultView(result: result, onDismiss: {
                    handleResultDismiss(success: result.isSuccess)
                })
            } else {
                ChallengeInputView(
                    viewModel: viewModel,
                    unlockTime: appState.unlockTime,
                    onSubmit: handleSubmit,
                    onCancel: handleCancel
                )
            }
        }
    }
    
    // MARK: - Background
    
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Action Handlers
    
    private func handleSubmit() {
        viewModel.submitChallenge { success in
            showResult = true
        }
    }
    
    private func handleCancel() {
        appState.cancelUnlockChallenge()
    }
    
    private func handleResultDismiss(success: Bool) {
        if success {
            appState.endUnlockChallenge(success: true)
        } else {
            showResult = false
            viewModel.challengeResult = nil
        }
    }
}

// MARK: - Challenge Input View

struct ChallengeInputView: View {
    @ObservedObject var viewModel: UnlockChallengeViewModel
    let unlockTime: Date?
    let onSubmit: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            headerSection
            wordBubblesSection
            inputSection
            buttonsSection
            remainingAttemptsText
            Spacer()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .font(.system(size: 70))
                .foregroundColor(.white)
                .padding()
                .background(
                    Circle()
                        .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
                )

            Text("🔒 ThinkFree Locked")
                .font(.title.bold())
                .foregroundColor(.primary)

            if let unlockTime = unlockTime {
                let formattedTime = {
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    return formatter.string(from: unlockTime)
                }()

                Text("Locked until \(formattedTime)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Divider()
                .padding(.vertical, 8)

            Text("💡 Creative Unlock")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Create a creative sentence\nusing the two words below:")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 30)
    }
    
    // MARK: - Word Bubbles
    
    private var wordBubblesSection: some View {
        HStack(spacing: 20) {
            WordBubble(word: viewModel.challenge.word1)
            WordBubble(word: viewModel.challenge.word2)
        }
        .padding()
    }
    
    // MARK: - Input
    
    private var inputSection: some View {
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
    }
    
    // MARK: - Buttons
    
    private var buttonsSection: some View {
        VStack(spacing: 12) {
            submitButton
            actionButtons
        }
        .padding(.horizontal)
    }
    
    private var submitButton: some View {
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
    }
    
    private var actionButtons: some View {
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
    
    private var remainingAttemptsText: some View {
        VStack(spacing: 4) {
            Text("⚠️ Daily Limits")
                .font(.caption.bold())
                .foregroundColor(.orange)
            HStack {
                Text("💬 Submissions: \(viewModel.remainingAttempts)/10")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("🔄 Word Changes: \(viewModel.remainingRefreshCount)/3")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Word Bubble

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

// MARK: - Evaluating View

struct EvaluatingView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("🤖 AI가 평가 중입니다")
                .font(.title2)
                .fontWeight(.bold)
            
            evaluationProgress
        }
        .padding(40)
    }
    
    private var evaluationProgress: some View {
        VStack(spacing: 16) {
            evaluationRow(title: "ChatGPT 평가:", status: "진행중...")
            evaluationRow(title: "Claude 평가:", status: "대기중...")
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
    }
    
    private func evaluationRow(title: String, status: String) -> some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            Spacer()
            ProgressView()
            Text(status)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Result View

struct ResultView: View {
    let result: ChallengeResult
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            resultIcon
            resultTitle
            evaluationResults
            resultMessage
            dismissButton
        }
        .padding(40)
    }
    
    private var resultIcon: some View {
        Image(systemName: result.isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
            .font(.system(size: 80))
            .foregroundColor(result.isSuccess ? .green : .red)
    }
    
    private var resultTitle: some View {
        Text(result.isSuccess ? "✅ 해제 성공!" : "❌ 해제 실패")
            .font(.title)
            .fontWeight(.bold)
    }
    
    private var evaluationResults: some View {
        VStack(spacing: 16) {
            EvaluationResultRow(title: "ChatGPT 평가", result: result.chatGPTResult)
            EvaluationResultRow(title: "Claude 평가", result: result.claudeResult)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
    }
    
    private var resultMessage: some View {
        Group {
            if result.isSuccess {
                Text("🔓 자물쇠가 열렸습니다!")
                    .font(.headline)
                    .foregroundColor(.green)
            } else {
                Text("두 AI 모두 통과해야 해제됩니다")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var dismissButton: some View {
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
}

// MARK: - Evaluation Result Row

struct EvaluationResultRow: View {
    let title: String
    let result: AIEvaluationResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .fontWeight(.semibold)
                Spacer()
                resultBadge
            }
            
            feedbackText
        }
    }
    
    @ViewBuilder
    private var resultBadge: some View {
        if case .pass = result {
            Text("PASS ✅")
                .foregroundColor(.green)
        } else if case .fail = result {
            Text("FAIL ❌")
                .foregroundColor(.red)
        }
    }
    
    @ViewBuilder
    private var feedbackText: some View {
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

// MARK: - Previews

struct UnlockChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        UnlockChallengeView()
            .environmentObject(AppStateManager())
    }
}
