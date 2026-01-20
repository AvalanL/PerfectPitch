import SwiftUI

// MARK: - Colors
// A rich, vibrant color palette inspired by premium music apps like Spotify, Apple Music, and Headspace
// Moving away from flat white to warm, tinted backgrounds with depth

extension Color {
    // MARK: - Primary Brand Colors
    /// Deep violet - our signature color
    static let primaryViolet = Color(hex: "7C3AED")
    /// Rich indigo for gradients
    static let primaryIndigo = Color(hex: "4F46E5")
    /// Vibrant purple accent
    static let primaryPurple = Color(hex: "8B5CF6")
    /// Electric blue for highlights
    static let electricBlue = Color(hex: "3B82F6")

    // MARK: - Gradient Colors
    static let primaryGradientStart = Color(hex: "6366F1")
    static let primaryGradientEnd = Color(hex: "A855F7")
    static let warmGradientStart = Color(hex: "F59E0B")
    static let warmGradientEnd = Color(hex: "EF4444")
    static let coolGradientStart = Color(hex: "06B6D4")
    static let coolGradientEnd = Color(hex: "3B82F6")

    // MARK: - Semantic Colors
    static let success = Color(hex: "10B981")
    static let successLight = Color(hex: "D1FAE5")
    static let warning = Color(hex: "F59E0B")
    static let warningLight = Color(hex: "FEF3C7")
    static let error = Color(hex: "EF4444")
    static let errorLight = Color(hex: "FEE2E2")
    static let info = Color(hex: "3B82F6")
    static let infoLight = Color(hex: "DBEAFE")

    // MARK: - Light Mode Backgrounds (Warm tinted, not pure white)
    /// Main background - warm cream tint
    static let backgroundPrimary = Color(hex: "FAFAF9")
    /// Card background - soft warm white
    static let backgroundSecondary = Color(hex: "F5F5F4")
    /// Elevated surface - pure white for contrast
    static let backgroundElevated = Color(hex: "FFFFFF")
    /// Subtle tinted background
    static let backgroundTertiary = Color(hex: "E7E5E4")
    /// Accent background - soft purple tint
    static let backgroundAccent = Color(hex: "F5F3FF")
    /// Warm gradient background
    static let backgroundWarm = Color(hex: "FFFBEB")

    // MARK: - Dark Mode Backgrounds (Rich, not pure black)
    /// Main dark background - deep blue-black
    static let darkBackgroundPrimary = Color(hex: "0F0D1A")
    /// Card background - elevated dark
    static let darkBackgroundSecondary = Color(hex: "1A1625")
    /// Elevated surface
    static let darkBackgroundElevated = Color(hex: "252136")
    /// Subtle dark surface
    static let darkBackgroundTertiary = Color(hex: "2D2640")
    /// Accent dark background
    static let darkBackgroundAccent = Color(hex: "1E1B4B")

    // MARK: - Text Colors
    /// Primary text - rich black, not pure black
    static let textPrimary = Color(hex: "1C1917")
    /// Secondary text - warm gray
    static let textSecondary = Color(hex: "57534E")
    /// Tertiary/disabled text
    static let textTertiary = Color(hex: "A8A29E")
    /// Inverted text for dark backgrounds
    static let textOnDark = Color(hex: "FAFAF9")
    /// Subtle text on dark
    static let textOnDarkSecondary = Color(hex: "A8A29E")

    // MARK: - Dark Mode Text
    static let darkTextPrimary = Color(hex: "FAFAF9")
    static let darkTextSecondary = Color(hex: "A8A29E")
    static let darkTextTertiary = Color(hex: "78716C")

    // MARK: - Border Colors
    static let borderLight = Color(hex: "E7E5E4")
    static let borderMedium = Color(hex: "D6D3D1")
    static let borderFocus = Color(hex: "8B5CF6")
    static let darkBorderLight = Color(hex: "2D2640")
    static let darkBorderMedium = Color(hex: "3D3654")

    // MARK: - Note Colors (Chromatic - Rich & Vibrant)
    static let noteC = Color(hex: "EF4444")      // Red
    static let noteCSharp = Color(hex: "F97316") // Orange
    static let noteD = Color(hex: "F59E0B")      // Amber
    static let noteDSharp = Color(hex: "EAB308") // Yellow
    static let noteE = Color(hex: "84CC16")      // Lime
    static let noteF = Color(hex: "22C55E")      // Green
    static let noteFSharp = Color(hex: "14B8A6") // Teal
    static let noteG = Color(hex: "06B6D4")      // Cyan
    static let noteGSharp = Color(hex: "3B82F6") // Blue
    static let noteA = Color(hex: "6366F1")      // Indigo
    static let noteASharp = Color(hex: "8B5CF6") // Violet
    static let noteB = Color(hex: "D946EF")      // Fuchsia

    // MARK: - Special Colors
    /// Gold for achievements
    static let gold = Color(hex: "F59E0B")
    /// Silver for secondary achievements
    static let silver = Color(hex: "9CA3AF")
    /// Bronze for tertiary achievements
    static let bronze = Color(hex: "D97706")
    /// Streak flame color
    static let streakOrange = Color(hex: "F97316")
    static let streakRed = Color(hex: "EF4444")

    // MARK: - Hex Initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    // MARK: - Note Color Helper
    static func noteColor(for note: Note) -> Color {
        switch note.pitchClass {
        case .C: return .noteC
        case .CSharp: return .noteCSharp
        case .D: return .noteD
        case .DSharp: return .noteDSharp
        case .E: return .noteE
        case .F: return .noteF
        case .FSharp: return .noteFSharp
        case .G: return .noteG
        case .GSharp: return .noteGSharp
        case .A: return .noteA
        case .ASharp: return .noteASharp
        case .B: return .noteB
        }
    }

    static func noteColor(for pitchClass: PitchClass) -> Color {
        switch pitchClass {
        case .C: return .noteC
        case .CSharp: return .noteCSharp
        case .D: return .noteD
        case .DSharp: return .noteDSharp
        case .E: return .noteE
        case .F: return .noteF
        case .FSharp: return .noteFSharp
        case .G: return .noteG
        case .GSharp: return .noteGSharp
        case .A: return .noteA
        case .ASharp: return .noteASharp
        case .B: return .noteB
        }
    }
}

// MARK: - Gradients
extension LinearGradient {
    /// Primary brand gradient - violet to purple
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "6366F1"), Color(hex: "A855F7")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Vibrant gradient for highlights
    static let vibrantGradient = LinearGradient(
        colors: [Color(hex: "8B5CF6"), Color(hex: "EC4899")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Warm gradient for streaks and achievements
    static let warmGradient = LinearGradient(
        colors: [Color(hex: "F59E0B"), Color(hex: "EF4444")],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Cool gradient for info states
    static let coolGradient = LinearGradient(
        colors: [Color(hex: "06B6D4"), Color(hex: "3B82F6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Success gradient
    static let successGradient = LinearGradient(
        colors: [Color(hex: "10B981"), Color(hex: "059669")],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Streak flame gradient
    static let streakGradient = LinearGradient(
        colors: [Color(hex: "F97316"), Color(hex: "EF4444")],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Card subtle gradient
    static let cardGradient = LinearGradient(
        colors: [
            Color.primaryGradientStart.opacity(0.08),
            Color.primaryGradientEnd.opacity(0.03)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Dark mode card gradient
    static let darkCardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.08),
            Color.white.opacity(0.02)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Background ambient gradient (subtle)
    static let ambientGradient = LinearGradient(
        colors: [
            Color(hex: "F5F3FF"),
            Color(hex: "FAFAF9")
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Dark ambient gradient
    static let darkAmbientGradient = LinearGradient(
        colors: [
            Color(hex: "1E1B4B"),
            Color(hex: "0F0D1A")
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Gold achievement gradient
    static let goldGradient = LinearGradient(
        colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Silver achievement gradient
    static let silverGradient = LinearGradient(
        colors: [Color(hex: "E5E7EB"), Color(hex: "9CA3AF")],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Bronze achievement gradient
    static let bronzeGradient = LinearGradient(
        colors: [Color(hex: "FBBF24"), Color(hex: "D97706")],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Radial Gradients
extension RadialGradient {
    /// Glow effect gradient
    static func glowGradient(color: Color) -> RadialGradient {
        RadialGradient(
            colors: [color.opacity(0.4), color.opacity(0)],
            center: .center,
            startRadius: 0,
            endRadius: 100
        )
    }

    /// Spotlight gradient for focus states
    static let spotlightGradient = RadialGradient(
        colors: [Color.white.opacity(0.15), Color.clear],
        center: .top,
        startRadius: 0,
        endRadius: 300
    )
}

// MARK: - Typography
struct PPFont {
    // Display - Large headlines
    static func displayLarge() -> Font { .system(size: 34, weight: .bold, design: .rounded) }
    static func displayMedium() -> Font { .system(size: 28, weight: .bold, design: .rounded) }

    // Title - Section headers
    static func titleLarge() -> Font { .system(size: 22, weight: .semibold, design: .rounded) }
    static func titleMedium() -> Font { .system(size: 17, weight: .semibold, design: .rounded) }
    static func titleSmall() -> Font { .system(size: 15, weight: .semibold, design: .rounded) }

    // Body - Primary text
    static func bodyLarge() -> Font { .system(size: 17, weight: .regular) }
    static func bodyMedium() -> Font { .system(size: 15, weight: .regular) }
    static func bodySmall() -> Font { .system(size: 13, weight: .regular) }

    // Caption - Labels, hints
    static func caption() -> Font { .system(size: 13, weight: .regular) }
    static func captionSmall() -> Font { .system(size: 11, weight: .medium) }

    // Mono - Numbers, code
    static func mono() -> Font { .system(size: 17, weight: .medium, design: .monospaced) }
    static func monoLarge() -> Font { .system(size: 28, weight: .bold, design: .monospaced) }
}

// MARK: - Spacing
struct PPSpacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
    static let huge: CGFloat = 48
    static let massive: CGFloat = 64
}

// MARK: - Corner Radius
struct PPRadius {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let full: CGFloat = 9999
}

// MARK: - Shadows
extension View {
    func ppShadowSmall() -> some View {
        self.shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
            .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
    }

    func ppShadowMedium() -> some View {
        self.shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    func ppShadowLarge() -> some View {
        self.shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }

    func ppShadowGlow(color: Color = .primaryPurple) -> some View {
        self.shadow(color: color.opacity(0.3), radius: 12, x: 0, y: 4)
            .shadow(color: color.opacity(0.2), radius: 24, x: 0, y: 8)
    }

    func ppShadowColored(_ color: Color) -> some View {
        self.shadow(color: color.opacity(0.25), radius: 8, x: 0, y: 4)
            .shadow(color: color.opacity(0.15), radius: 16, x: 0, y: 8)
    }
}

// MARK: - Animations
extension Animation {
    static let ppSpring = Animation.spring(response: 0.35, dampingFraction: 0.7)
    static let ppBounce = Animation.spring(response: 0.4, dampingFraction: 0.6)
    static let ppSnappy = Animation.spring(response: 0.25, dampingFraction: 0.8)
    static let ppFast = Animation.easeOut(duration: 0.15)
    static let ppNormal = Animation.easeOut(duration: 0.25)
    static let ppSlow = Animation.easeOut(duration: 0.35)
    static let ppSmooth = Animation.easeInOut(duration: 0.3)
}

// MARK: - View Extensions
extension View {
    /// Apply a gradient background with rounded corners
    func gradientBackground(_ gradient: LinearGradient = .primaryGradient, cornerRadius: CGFloat = PPRadius.lg) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(gradient)
        )
    }

    /// Apply a tinted card style
    func tintedCard(color: Color = .primaryPurple, cornerRadius: CGFloat = PPRadius.lg) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(color.opacity(0.15), lineWidth: 1)
                )
        )
    }

    /// Apply elevated card style
    func elevatedCard(cornerRadius: CGFloat = PPRadius.lg) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.backgroundElevated)
        )
        .ppShadowMedium()
    }

    /// Apply the primary gradient as text color
    func gradientForeground(_ gradient: LinearGradient = .primaryGradient) -> some View {
        self.overlay(gradient)
            .mask(self)
    }
}

// MARK: - Color Scheme Aware Colors
struct AdaptiveColor {
    let light: Color
    let dark: Color

    func color(for scheme: ColorScheme) -> Color {
        scheme == .dark ? dark : light
    }
}

extension Color {
    static func adaptive(light: Color, dark: Color) -> Color {
        // This would need @Environment access, so we use a different approach
        light // Default to light, use AdaptiveColor for true adaptation
    }
}

// MARK: - Theme
struct PPTheme {
    // Backgrounds
    static func background(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .darkBackgroundPrimary : .backgroundPrimary
    }

    static func secondaryBackground(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .darkBackgroundSecondary : .backgroundSecondary
    }

    static func elevatedBackground(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .darkBackgroundElevated : .backgroundElevated
    }

    // Text
    static func primaryText(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .darkTextPrimary : .textPrimary
    }

    static func secondaryText(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .darkTextSecondary : .textSecondary
    }

    // Borders
    static func border(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .darkBorderLight : .borderLight
    }
}
