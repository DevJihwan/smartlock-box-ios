//
//  UnlockChallengeView_New.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-16.
//  New design matching MainView_New aesthetic
//

import SwiftUI
import UIKit

struct UnlockChallengeView_New: View {
    @EnvironmentObject var appState: AppStateManager
    @StateObject private var viewModel = UnlockChallengeViewModel()
    @State private var showResult = false

    var body: some View {
        ZStack {
            // Background - matching main screen gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if viewModel.isEvaluating {
                EvaluatingView_New()
            } else if let result = viewModel.challengeResult, showResult {
                ResultView_New(result: result, onDismiss: {
                    handleResultDismiss(success: result.isSuccess)
                })
            } else {
                ChallengeInputView_New(
                    viewModel: viewModel,
                    unlockTime: appState.unlockTime,
                    onSubmit: handleSubmit,
                    onCancel: handleCancel
                )
            }
        }
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

struct ChallengeInputView_New: View {
    @ObservedObject var viewModel: UnlockChallengeViewModel
    let unlockTime: Date?
    let onSubmit: () -> Void
    let onCancel: () -> Void
    @State private var isInputFocused: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 54)

            // Title
            titleSection

            Spacer().frame(height: 24)

            // Icon
            iconSection

            Spacer().frame(height: 32)

            // Description
            descriptionSection

            Spacer().frame(height: 40)

            // Word bubbles
            wordBubblesSection

            Spacer().frame(height: 40)

            // Input section
            inputSection

            Spacer().frame(height: 24)

            // Submit button
            submitButton

            Spacer().frame(height: 16)

            // Requirement text
            requirementText

            Spacer()
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Title

    private var titleSection: some View {
        Text("창의력 챌린지")
            .font(.system(size: 16))
            .foregroundColor(Color(hex: "333333"))
    }

    // MARK: - Icon

    private var iconSection: some View {
        ZStack {
            // Outer circle (light blue)
            Circle()
                .fill(Color(red: 0.68, green: 0.85, blue: 0.95))
                .frame(width: 80, height: 80)

            // Bulb body
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 40))
                .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))
        }
    }

    // MARK: - Description

    private var descriptionSection: some View {
        VStack(spacing: 4) {
            Text("다음 두 단어를 사용하여")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "333333"))

            Text("창의적인 문장을 만들어보세요")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "333333"))
        }
    }

    // MARK: - Word Bubbles

    private var wordBubblesSection: some View {
        HStack(spacing: 24) {
            // Word 1
            wordBubble(text: viewModel.challenge.word1)

            // Word 2
            wordBubble(text: viewModel.challenge.word2)
        }
    }

    private func wordBubble(text: String) -> some View {
        Text(text)
            .font(.system(size: 28))
            .foregroundColor(.black)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: "EBF5FF"))
            )
    }

    // MARK: - Input

    private var inputSection: some View {
        ZStack(alignment: .topLeading) {
            // Background with border
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color(red: 0.4, green: 0.7, blue: 1.0), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
                .frame(height: 180)

            VStack(alignment: .leading, spacing: 0) {
                // Custom TextView
                SubmittableTextView_New(
                    text: $viewModel.challenge.attempt,
                    isFocused: $isInputFocused,
                    onSubmit: {
                        if viewModel.challenge.isValid {
                            onSubmit()
                        }
                    }
                )
                .frame(height: 140)
                .padding(.top, 16)
                .padding(.horizontal, 16)

                // Placeholder
                if viewModel.challenge.attempt.isEmpty {
                    Text("당신의 창의적인 문장을 입력하세요...")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "999999"))
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .allowsHitTesting(false)
                        .offset(y: -140)
                }

                // Character count
                HStack {
                    Spacer()
                    Text("\(viewModel.challenge.attempt.count)/100")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "CCCCCC"))
                        .padding(.trailing, 16)
                        .padding(.bottom, 8)
                }
            }
        }
    }

    // MARK: - Submit Button

    private var submitButton: some View {
        Button(action: {
            if viewModel.challenge.isValid {
                onSubmit()
            }
        }) {
            Text("AI에게 평가받기")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            viewModel.challenge.isValid ?
                            Color(red: 0.4, green: 0.7, blue: 1.0) :
                            Color.gray.opacity(0.3)
                        )
                )
        }
        .disabled(!viewModel.challenge.isValid)
    }

    // MARK: - Requirement Text

    private var requirementText: some View {
        Text("두 단어를 모두 사용한 10자 이상의 문장이 필요합니다")
            .font(.system(size: 12))
            .foregroundColor(Color(hex: "999999"))
            .multilineTextAlignment(.center)
    }

}

// MARK: - Evaluating View

struct EvaluatingView_New: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Loading indicator
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color(red: 0.4, green: 0.7, blue: 1.0))

            VStack(spacing: 12) {
                Text("AI가 평가 중입니다")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex: "333333"))

                Text("창의적인 답변인지 확인하고 있어요")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "666666"))
            }

            Spacer()
        }
        .padding(40)
    }
}

// MARK: - Result View

struct ResultView_New: View {
    let result: ChallengeResult
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Result icon
            resultIcon

            // Result title
            resultTitle

            // Evaluation results
            evaluationResults

            Spacer()

            // Dismiss button
            dismissButton
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }

    private var resultIcon: some View {
        ZStack {
            Circle()
                .fill(result.isSuccess ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                .frame(width: 100, height: 100)

            Image(systemName: result.isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(result.isSuccess ? .green : .red)
        }
    }

    private var resultTitle: some View {
        Text(result.isSuccess ? "해제 성공!" : "해제 실패")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(Color(hex: "333333"))
    }

    private var evaluationResults: some View {
        VStack(spacing: 16) {
            EvaluationResultRow_New(title: "ChatGPT 평가", result: result.chatGPTResult)
            EvaluationResultRow_New(title: "Claude 평가", result: result.claudeResult)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
        )
    }

    private var dismissButton: some View {
        Button(action: onDismiss) {
            Text(result.isSuccess ? "메인으로 돌아가기" : "다시 도전하기")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(result.isSuccess ? Color.green : Color(red: 0.4, green: 0.7, blue: 1.0))
                )
        }
    }
}

// MARK: - Evaluation Result Row

struct EvaluationResultRow_New: View {
    let title: String
    let result: AIEvaluationResult

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(hex: "333333"))
                Spacer()
                resultBadge
            }

            feedbackText
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "F5F5F5"))
        )
    }

    @ViewBuilder
    private var resultBadge: some View {
        if case .pass = result {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 14))
                Text("PASS")
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(.green)
        } else if case .fail = result {
            HStack(spacing: 4) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14))
                Text("FAIL")
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(.red)
        }
    }

    @ViewBuilder
    private var feedbackText: some View {
        if case .pass(let feedback) = result {
            Text(feedback)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "666666"))
        } else if case .fail(let feedback) = result {
            Text(feedback)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "666666"))
        }
    }
}

// MARK: - Submittable TextView

struct SubmittableTextView_New: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    var onSubmit: () -> Void

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        textView.font = .systemFont(ofSize: 15)
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
            if text == "\n" {
                onSubmit()
                return false
            }
            return true
        }
    }
}

// MARK: - Previews

struct UnlockChallengeView_New_Previews: PreviewProvider {
    static var previews: some View {
        UnlockChallengeView_New()
            .environmentObject(AppStateManager())
    }
}
