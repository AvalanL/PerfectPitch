import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var selectedTab: LeaderboardTab = .global

    enum LeaderboardTab: String, CaseIterable {
        case global = "Global"
        case friends = "Friends"
        case weekly = "Weekly"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with gradient accent
                VStack(alignment: .leading, spacing: PPSpacing.xs) {
                    HStack(spacing: PPSpacing.sm) {
                        Text("Leaderboard")
                            .font(PPFont.displayLarge())
                            .foregroundColor(.textPrimary)

                        Image(systemName: "trophy.fill")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(LinearGradient.goldGradient)
                    }

                    Text("Compete with musicians worldwide")
                        .font(PPFont.bodyLarge())
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, PPSpacing.lg)
                .padding(.top, PPSpacing.lg)
                .padding(.bottom, PPSpacing.md)

                // Tab Selector with animated indicator
                HStack(spacing: 0) {
                    ForEach(LeaderboardTab.allCases, id: \.self) { tab in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = tab
                            }
                        }) {
                            Text(tab.rawValue)
                                .font(PPFont.titleMedium())
                                .foregroundColor(selectedTab == tab ? .primaryPurple : .textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, PPSpacing.md)
                                .background(
                                    VStack {
                                        Spacer()
                                        Capsule()
                                            .fill(selectedTab == tab ? LinearGradient.primaryGradient : LinearGradient(colors: [.clear], startPoint: .leading, endPoint: .trailing))
                                            .frame(height: 3)
                                    }
                                )
                        }
                    }
                }
                .background(Color.backgroundElevated)
                .ppShadowSmall()

                // Leaderboard Content
                ScrollView {
                    VStack(spacing: PPSpacing.md) {
                        // Current User Rank Card
                        currentUserRankCard
                            .padding(.top, PPSpacing.lg)

                        // Top 3 Podium
                        podiumView
                            .padding(.vertical, PPSpacing.lg)

                        // Leaderboard List
                        leaderboardList
                    }
                    .padding(.horizontal, PPSpacing.lg)
                    .padding(.bottom, PPSpacing.huge)
                }
                .background(
                    LinearGradient.ambientGradient
                        .ignoresSafeArea()
                )
            }
            .background(Color.backgroundElevated)
        }
    }

    // MARK: - Current User Rank Card
    private var currentUserRankCard: some View {
        HStack(spacing: PPSpacing.lg) {
            // Rank with glow
            ZStack {
                Circle()
                    .fill(Color.primaryPurple.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .blur(radius: 10)

                Circle()
                    .fill(LinearGradient.primaryGradient)
                    .frame(width: 50, height: 50)

                Text("#42")
                    .font(PPFont.titleMedium())
                    .foregroundColor(.white)
            }

            // User info
            VStack(alignment: .leading, spacing: PPSpacing.xs) {
                Text("YOUR RANK")
                    .font(PPFont.captionSmall())
                    .foregroundColor(.primaryPurple)
                    .tracking(1)

                Text(userManager.currentUser.name)
                    .font(PPFont.titleMedium())
                    .foregroundColor(.textPrimary)

                Text("\(userManager.currentUser.stats.totalXP) XP")
                    .font(PPFont.caption())
                    .foregroundColor(.textTertiary)
            }

            Spacer()

            // Stats
            VStack(alignment: .trailing, spacing: PPSpacing.xs) {
                Text("Level \(userManager.currentUser.level)")
                    .font(PPFont.titleMedium())
                    .foregroundColor(.textPrimary)

                HStack(spacing: 4) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 10, weight: .bold))
                    Text("5 ranks")
                        .font(PPFont.captionSmall())
                }
                .foregroundColor(.success)
                .padding(.horizontal, PPSpacing.sm)
                .padding(.vertical, PPSpacing.xs)
                .background(Color.success.opacity(0.1))
                .cornerRadius(PPRadius.full)
            }
        }
        .padding(PPSpacing.xl)
        .background(
            RoundedRectangle(cornerRadius: PPRadius.xl)
                .fill(Color.backgroundElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: PPRadius.xl)
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryPurple.opacity(0.08), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: PPRadius.xl)
                .stroke(Color.primaryPurple.opacity(0.2), lineWidth: 1)
        )
        .ppShadowLarge()
    }

    // MARK: - Podium View
    private var podiumView: some View {
        HStack(alignment: .bottom, spacing: PPSpacing.md) {
            // 2nd Place
            PodiumItem(
                rank: 2,
                name: "Alex M.",
                xp: 45200,
                level: 35,
                height: 100
            )

            // 1st Place
            PodiumItem(
                rank: 1,
                name: "Sarah K.",
                xp: 52100,
                level: 42,
                height: 130
            )

            // 3rd Place
            PodiumItem(
                rank: 3,
                name: "Mike R.",
                xp: 41800,
                level: 33,
                height: 80
            )
        }
    }

    // MARK: - Leaderboard List
    private var leaderboardList: some View {
        VStack(spacing: PPSpacing.sm) {
            ForEach(4...20, id: \.self) { rank in
                LeaderboardRow(
                    rank: rank,
                    name: sampleNames[rank % sampleNames.count],
                    xp: 40000 - (rank * 500),
                    level: 30 - (rank / 2),
                    isCurrentUser: rank == 10
                )
            }
        }
    }

    private var sampleNames: [String] {
        ["Emma L.", "James T.", "Olivia P.", "Noah B.", "Ava S.", "Liam W.", "Sophia C.", "Mason D.", "Isabella R.", "Ethan H.", "Mia G.", "Lucas F.", "Charlotte N.", "Benjamin A.", "Amelia J.", "Jack M.", "Harper Z."]
    }
}

// MARK: - Podium Item
struct PodiumItem: View {
    let rank: Int
    let name: String
    let xp: Int
    let level: Int
    let height: CGFloat

    var body: some View {
        VStack(spacing: PPSpacing.sm) {
            // Avatar
            ZStack {
                Circle()
                    .fill(avatarGradient)
                    .frame(width: rank == 1 ? 70 : 56, height: rank == 1 ? 70 : 56)

                Text(String(name.prefix(1)))
                    .font(rank == 1 ? PPFont.titleLarge() : PPFont.titleMedium())
                    .foregroundColor(.white)

                // Crown for 1st place
                if rank == 1 {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.warning)
                        .offset(y: -45)
                }
            }

            // Name
            Text(name)
                .font(PPFont.bodyMedium())
                .foregroundColor(.textPrimary)
                .lineLimit(1)

            Text("\(xp) XP")
                .font(PPFont.captionSmall())
                .foregroundColor(.textSecondary)

            // Podium
            ZStack {
                RoundedRectangle(cornerRadius: PPRadius.sm)
                    .fill(podiumColor)
                    .frame(height: height)

                Text("\(rank)")
                    .font(PPFont.displayMedium())
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var avatarGradient: LinearGradient {
        switch rank {
        case 1: return LinearGradient(colors: [Color(hex: "FFD700"), Color(hex: "FFA500")], startPoint: .top, endPoint: .bottom)
        case 2: return LinearGradient(colors: [Color(hex: "C0C0C0"), Color(hex: "A0A0A0")], startPoint: .top, endPoint: .bottom)
        case 3: return LinearGradient(colors: [Color(hex: "CD7F32"), Color(hex: "A0522D")], startPoint: .top, endPoint: .bottom)
        default: return LinearGradient.primaryGradient
        }
    }

    private var podiumColor: LinearGradient {
        switch rank {
        case 1: return LinearGradient(colors: [Color(hex: "FFD700"), Color(hex: "DAA520")], startPoint: .top, endPoint: .bottom)
        case 2: return LinearGradient(colors: [Color(hex: "C0C0C0"), Color(hex: "808080")], startPoint: .top, endPoint: .bottom)
        case 3: return LinearGradient(colors: [Color(hex: "CD7F32"), Color(hex: "8B4513")], startPoint: .top, endPoint: .bottom)
        default: return LinearGradient.primaryGradient
        }
    }
}

// MARK: - Leaderboard Row
struct LeaderboardRow: View {
    let rank: Int
    let name: String
    let xp: Int
    let level: Int
    let isCurrentUser: Bool

    var body: some View {
        HStack(spacing: PPSpacing.md) {
            // Rank with badge
            Text("#\(rank)")
                .font(PPFont.titleMedium())
                .foregroundColor(isCurrentUser ? .primaryPurple : .textSecondary)
                .frame(width: 40, alignment: .leading)

            // Avatar with glow for current user
            ZStack {
                if isCurrentUser {
                    Circle()
                        .fill(Color.primaryPurple.opacity(0.2))
                        .frame(width: 48, height: 48)
                        .blur(radius: 6)
                }

                Circle()
                    .fill(isCurrentUser ? LinearGradient.primaryGradient : LinearGradient(colors: [.backgroundTertiary], startPoint: .top, endPoint: .bottom))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(name.prefix(1)))
                            .font(PPFont.bodyMedium())
                            .foregroundColor(isCurrentUser ? .white : .textSecondary)
                    )
            }

            // Name and level
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(PPFont.bodyMedium())
                    .foregroundColor(isCurrentUser ? .primaryPurple : .textPrimary)

                Text("Level \(level)")
                    .font(PPFont.captionSmall())
                    .foregroundColor(.textTertiary)
            }

            Spacer()

            // XP with badge
            Text("\(xp) XP")
                .font(PPFont.bodyMedium())
                .foregroundColor(.textSecondary)
                .padding(.horizontal, PPSpacing.sm)
                .padding(.vertical, PPSpacing.xs)
                .background(Color.backgroundTertiary.opacity(0.5))
                .cornerRadius(PPRadius.full)
        }
        .padding(PPSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: PPRadius.md)
                .fill(isCurrentUser ? Color.backgroundElevated : Color.backgroundElevated)
                .overlay(
                    isCurrentUser ?
                    RoundedRectangle(cornerRadius: PPRadius.md)
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryPurple.opacity(0.08), Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        ) : nil
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: PPRadius.md)
                .stroke(isCurrentUser ? Color.primaryPurple.opacity(0.3) : Color.borderLight.opacity(0.5), lineWidth: 1)
        )
        .ppShadowSmall()
    }
}

#Preview {
    LeaderboardView()
        .environmentObject(UserManager())
}
