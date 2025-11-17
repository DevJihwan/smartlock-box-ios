//
//  UnlockChallengeView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI
import UIKit

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
            gradient: Gradient(colors: [
                Color(red: 0.25, green: 0.71, blue: 0.96), // Light blue
                Color(red: 0.05, green: 0.49, blue: 0.78)  // Darker blue
            ]),
            startPoint: .top,
            endPoint: .bottom
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
    @State private var isInputFocused: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 60)

            headerSection

            Spacer().frame(height: 80)

            wordBubblesSection

            Spacer().frame(height: 32)

            inputSection

            Spacer().frame(height: 20)

            submitHintText

            Spacer()

            autoUnlockText

            Spacer().frame(height: 40)
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 0) {
            // "Think" text
            Text("Think")
                .font(.system(size: 48, weight: .regular))
                .foregroundColor(Color.white.opacity(0.9))

            // Divider line
            Rectangle()
                .fill(Color.white.opacity(0.7))
                .frame(width: 120, height: 1)

            // "Free" text
            Text("Free")
                .font(.system(size: 48, weight: .regular))
                .foregroundColor(Color.white.opacity(0.9))
        }
    }
    
    // MARK: - Word Bubbles

    private var wordBubblesSection: some View {
        HStack(spacing: 20) {
            // Left word with glassmorphism
            Text(viewModel.challenge.word1)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color.white.opacity(0.9))
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(
                    ZStack {
                        // Glassmorphism effect
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.15))
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.ultraThinMaterial)
                            )

                        // Border
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                    }
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)

            Spacer()
                .frame(maxWidth: 80)

            // Right word with glassmorphism
            Text(viewModel.challenge.word2)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color.white.opacity(0.9))
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(
                    ZStack {
                        // Glassmorphism effect
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.15))
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.ultraThinMaterial)
                            )

                        // Border
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                    }
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Input

    private var inputSection: some View {
        ZStack(alignment: .topLeading) {
            // Glassmorphism background with animated focus state
            ZStack {
                // Background blur effect
                RoundedRectangle(cornerRadius: 16)
                    .fill(isInputFocused ? Color.white.opacity(0.25) : Color.white.opacity(0.15))
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )

                // Border with animated color and width
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        isInputFocused ? Color.white.opacity(0.5) : Color.white.opacity(0.3),
                        lineWidth: isInputFocused ? 2 : 1
                    )
            }
            .frame(height: isInputFocused ? 200 : 180)
            .shadow(
                color: isInputFocused ? Color.white.opacity(0.2) : Color.black.opacity(0.1),
                radius: isInputFocused ? 15 : 10,
                x: 0,
                y: isInputFocused ? 6 : 4
            )
            .animation(.easeInOut(duration: 0.2), value: isInputFocused)

            // Custom TextView with Enter key detection
            SubmittableTextView(
                text: $viewModel.challenge.attempt,
                isFocused: $isInputFocused,
                onSubmit: {
                    if viewModel.challenge.isValid {
                        onSubmit()
                    }
                }
            )
            .padding(16)
            .frame(height: isInputFocused ? 200 : 180)

            // Placeholder
            if viewModel.challenge.attempt.isEmpty {
                Text("여기에 생각을 자유롭게...")
                    .font(.system(size: 17))
                    .foregroundColor(Color.white.opacity(0.5))
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .allowsHitTesting(false)
            }
        }
    }
    
    // MARK: - Submit Hint

    private var submitHintText: some View {
        Text("Enter로 제출")
            .font(.system(size: 14))
            .foregroundColor(Color.white.opacity(0.5))
    }

    // MARK: - Auto Unlock Text

    private var autoUnlockText: some View {
        Group {
            if let unlockTime = unlockTime {
                let timeRemaining = calculateTimeRemaining(until: unlockTime)
                Text(timeRemaining)
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.4))
            } else {
                Text("2시간 15분 후 자동 해제")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.4))
            }
        }
    }

    // MARK: - Helper Methods

    private func calculateTimeRemaining(until date: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.hour, .minute], from: now, to: date)

        if let hours = components.hour, let minutes = components.minute {
            if hours > 0 {
                return "\(hours)시간 \(minutes)분 후 자동 해제"
            } else {
                return "\(minutes)분 후 자동 해제"
            }
        }

        return "자동 해제 예정"
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

// MARK: - Submittable TextView

struct SubmittableTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    var onSubmit: () -> Void

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 17)
        textView.returnKeyType = .default
        textView.autocorrectionType = .default
        textView.autocapitalizationType = .sentences
        textView.isScrollEnabled = true
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }

        if isFocused && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFocused && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isFocused: $isFocused, onSubmit: onSubmit)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var isFocused: Bool
        var onSubmit: () -> Void

        init(text: Binding<String>, isFocused: Binding<Bool>, onSubmit: @escaping () -> Void) {
            _text = text
            _isFocused = isFocused
            self.onSubmit = onSubmit
        }

        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            isFocused = true
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            isFocused = false
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // Detect Enter key press (without Shift)
            if text == "\n" {
                // Check if valid, then submit
                onSubmit()
                return false // Don't add newline
            }
            return true
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
