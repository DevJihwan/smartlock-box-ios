//
//  UpgradePromptView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-03.
//

import SwiftUI
import StoreKit

struct UpgradePromptView: View {
    @Binding var isPresented: Bool
    @ObservedObject var subscriptionManager = SubscriptionManager.shared
    @ObservedObject var storeManager = StoreManager.shared
    @State private var selectedProduct: Product?
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection

                    // Features List
                    featuresSection

                    // Pricing
                    pricingSection

                    // Testimonials
                    testimonialsSection

                    // Call to Action
                    ctaButtons
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationBarItems(trailing: closeButton)
        }
        .alert("error".localized, isPresented: $showError) {
            Button("ok".localized, role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            // Auto-select yearly product by default
            selectedProduct = storeManager.products.first { $0.id.contains("yearly") }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "crown.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)

            Text("upgrade_title".localized)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppColors.text)

            Text("upgrade_subtitle".localized)
                .font(.subheadline)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    // MARK: - Features Section

    private var featuresSection: some View {
        VStack(spacing: 16) {
            featureRow(
                icon: "clock.badge.checkmark.fill",
                text: "upgrade_feature_time_slots".localized,
                color: .blue
            )

            featureRow(
                icon: "chart.bar.fill",
                text: "upgrade_feature_independent_counters".localized,
                color: .green
            )

            featureRow(
                icon: "infinity",
                text: "upgrade_feature_unlimited_unlocks".localized,
                color: .purple
            )

            featureRow(
                icon: "arrow.clockwise.circle.fill",
                text: "upgrade_feature_unlimited_refreshes".localized,
                color: .orange
            )

            featureRow(
                icon: "brain.head.profile",
                text: "upgrade_feature_dual_ai".localized,
                color: .pink
            )

            featureRow(
                icon: "eye.slash.fill",
                text: "upgrade_feature_no_ads".localized,
                color: .red
            )

            featureRow(
                icon: "chart.line.uptrend.xyaxis",
                text: "upgrade_feature_unlimited_stats".localized,
                color: .cyan
            )
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }

    private func featureRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)

            Text(text)
                .font(.body)
                .foregroundColor(AppColors.text)

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(color)
        }
    }

    // MARK: - Pricing Section

    private var pricingSection: some View {
        VStack(spacing: 12) {
            if storeManager.products.isEmpty {
                ProgressView()
                    .padding()
            } else {
                ForEach(storeManager.products, id: \.id) { product in
                    productCard(product: product)
                }
            }
        }
    }

    private func productCard(product: Product) -> some View {
        let isYearly = product.id.contains("yearly")
        let isSelected = selectedProduct?.id == product.id

        return Button(action: {
            selectedProduct = product
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.displayName)
                        .font(.headline)
                        .foregroundColor(AppColors.text)

                    Text(product.displayPrice)
                        .font(.subheadline)
                        .foregroundColor(AppColors.secondaryText)

                    if isYearly {
                        Text("Save 33%!")
                            .font(.caption)
                            .foregroundColor(.green)
                            .fontWeight(.medium)
                    }
                }

                Spacer()

                if isYearly {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(
                isYearly
                    ? LinearGradient(
                        gradient: Gradient(colors: [.purple.opacity(0.3), .blue.opacity(0.3)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    : LinearGradient(
                        gradient: Gradient(colors: [AppColors.cardBackground, AppColors.cardBackground]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.green : (isYearly ? Color.purple : Color.gray.opacity(0.3)), lineWidth: 2)
            )
        }
    }

    // MARK: - Testimonials Section

    private var testimonialsSection: some View {
        VStack(spacing: 12) {
            testimonialCard(text: "upgrade_testimonial_1".localized)
            testimonialCard(text: "upgrade_testimonial_2".localized)
        }
    }

    private func testimonialCard(text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "quote.bubble.fill")
                .font(.title2)
                .foregroundColor(AppColors.accent)

            Text(text)
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
                .italic()
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }

    // MARK: - CTA Buttons

    private var ctaButtons: some View {
        VStack(spacing: 12) {
            // Primary CTA - Start Trial
            Button(action: startTrial) {
                HStack {
                    Image(systemName: "star.fill")
                    Text("upgrade_start_trial".localized)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }

            // Secondary CTA - Maybe Later
            Button(action: { isPresented = false }) {
                Text("upgrade_later".localized)
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Close Button

    private var closeButton: some View {
        Button(action: { isPresented = false }) {
            Image(systemName: "xmark.circle.fill")
                .font(.title3)
                .foregroundColor(AppColors.secondaryText)
        }
    }

    // MARK: - Actions

    private func startTrial() {
        guard let product = selectedProduct ?? storeManager.products.first else {
            errorMessage = "No product selected"
            showError = true
            return
        }

        Task {
            do {
                let transaction = try await storeManager.purchase(product)

                if transaction != nil {
                    // Purchase successful
                    isPresented = false

                    // Show success feedback
                    await MainActor.run {
                        let feedback = UINotificationFeedbackGenerator()
                        feedback.notificationOccurred(.success)
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

// MARK: - Previews

struct UpgradePromptView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradePromptView(isPresented: .constant(true))
            .preferredColorScheme(.light)
    }
}
