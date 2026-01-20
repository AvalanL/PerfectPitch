# Perfect Pitch - Product Requirements Document

## Executive Summary

**Perfect Pitch** is a premium iOS application designed to help musicians develop absolute pitch recognition through scientifically-backed ear training exercises. The app combines gamification mechanics with a beautiful, Airbnb-inspired design to create an engaging and effective learning experience.

---

## Table of Contents

1. [Product Vision](#product-vision)
2. [Target Audience](#target-audience)
3. [Core Features](#core-features)
4. [Gamification System](#gamification-system)
5. [Design System](#design-system)
6. [User Experience](#user-experience)
7. [Technical Requirements](#technical-requirements)
8. [Success Metrics](#success-metrics)

---

## Product Vision

### Mission Statement
To democratize perfect pitch training by creating the most beautiful, engaging, and effective ear training app on the market.

### Problem Statement
- Traditional ear training is tedious and lacks engagement
- Existing apps have outdated, uninspiring interfaces
- Musicians struggle to maintain consistent practice habits
- Progress tracking is often inadequate or non-existent

### Solution
A gamified, beautifully designed iOS app that makes ear training enjoyable, tracks progress meaningfully, and builds lasting practice habits through proven learning techniques.

---

## Target Audience

### Primary Users
- **Aspiring Musicians** (Ages 16-35): Students learning instruments who want to develop their ear
- **Music Students**: Conservatory and university music majors
- **Hobbyist Musicians**: Amateur musicians looking to improve their skills

### Secondary Users
- **Music Teachers**: Using the app as a teaching tool
- **Professional Musicians**: Maintaining and sharpening their skills
- **Producers & Composers**: Improving their ability to identify and recreate sounds

### User Personas

#### Persona 1: "Sarah the Student"
- 22-year-old music major
- Practices piano 2-3 hours daily
- Wants to improve sight-singing and dictation skills
- Tech-savvy, uses iPhone daily
- Motivated by progress tracking and achievements

#### Persona 2: "Marcus the Hobbyist"
- 34-year-old software engineer who plays guitar
- Limited practice time (20-30 mins/day)
- Wants quick, effective exercises during commute
- Values beautiful design and user experience
- Needs motivation to stay consistent

---

## Core Features

### 1. Single Note Training

#### 1.1 Note Identification Mode
- **Description**: Listen to a single note and identify it from options
- **Difficulty Levels**:
  - **Beginner**: White keys only (C major scale), 3 octaves
  - **Intermediate**: All 12 chromatic notes, 4 octaves
  - **Advanced**: All notes, 7 octaves, with varied instruments/timbres
  - **Expert**: Microtonal variations, detuned notes

#### 1.2 Note Comparison Mode
- **Description**: Hear two notes and identify the interval or which is higher/lower
- **Progression**: Start with large intervals, progress to semitones

#### 1.3 Reference Pitch Training
- **Description**: Memorize a reference pitch (typically A440) and use it to identify others
- **Scientific Approach**: Based on research showing reference pitch memorization as pathway to absolute pitch

#### 1.4 Sound Customization
- **Instruments Available**:
  - Piano (default)
  - Sine wave (pure tone)
  - Guitar
  - Violin
  - Synth pads
  - Organ
  - Custom samples (premium)

### 2. Chord Training

#### 2.1 Chord Quality Recognition
- **Description**: Identify chord types by ear
- **Chord Types** (Progressive Unlock):
  - **Level 1**: Major, Minor
  - **Level 2**: Diminished, Augmented
  - **Level 3**: Major 7th, Minor 7th, Dominant 7th
  - **Level 4**: Diminished 7th, Half-diminished, Augmented 7th
  - **Level 5**: 9th, 11th, 13th extensions
  - **Level 6**: Altered chords, suspensions, add chords

#### 2.2 Chord Root Identification
- **Description**: Identify the root note of played chords
- **Combines** single note training with harmonic context

#### 2.3 Chord Progressions
- **Description**: Identify sequences of chords (ii-V-I, I-IV-V, etc.)
- **Genre Contexts**: Jazz, Pop, Classical, Blues

### 3. Interval Training

#### 3.1 Ascending/Descending Intervals
- **All intervals** from minor 2nd to octave
- **Melodic** (sequential) and **Harmonic** (simultaneous)

#### 3.2 Interval Comparison
- **Description**: Compare two intervals and identify which is larger

#### 3.3 Song Association
- **Description**: Learn intervals through famous song openings
- **Examples**: "Here Comes the Bride" (Perfect 4th), "Star Wars" (Perfect 5th)

### 4. Scale & Mode Training

#### 4.1 Scale Identification
- Major, Natural Minor, Harmonic Minor, Melodic Minor
- All 7 modes (Ionian through Locrian)
- Pentatonic scales, Blues scales
- Exotic scales (Whole tone, Diminished, etc.)

#### 4.2 Scale Degree Recognition
- Identify which degree of a scale is being played
- Solfege integration (Do, Re, Mi, etc.)

### 5. Melodic Dictation

#### 5.1 Short Melodies
- **3-5 notes**: Beginner
- **6-10 notes**: Intermediate
- **11+ notes**: Advanced

#### 5.2 Rhythmic Dictation
- Identify rhythmic patterns
- Combined pitch and rhythm challenges

### 6. Daily Challenges

#### 6.1 Daily Training
- **5-minute daily challenges** with curated exercises
- **Streak tracking** for consistency
- **Adaptive difficulty** based on performance

#### 6.2 Weekly Challenges
- Themed challenges (e.g., "Jazz Week", "Classical Week")
- Community leaderboards

---

## Gamification System

### 1. Experience Points (XP) System

#### Earning XP
| Activity | XP Earned |
|----------|-----------|
| Correct answer (easy) | 10 XP |
| Correct answer (medium) | 25 XP |
| Correct answer (hard) | 50 XP |
| Perfect round (no mistakes) | 2x multiplier |
| Daily challenge completion | 100 XP |
| Streak bonus (per day) | +10 XP cumulative |

#### Level Progression
- **Level 1-10**: Beginner (0-5,000 XP)
- **Level 11-25**: Intermediate (5,001-25,000 XP)
- **Level 26-50**: Advanced (25,001-100,000 XP)
- **Level 51-75**: Expert (100,001-250,000 XP)
- **Level 76-100**: Master (250,001-500,000 XP)
- **Level 100+**: Grandmaster (500,001+ XP)

### 2. Achievement System

#### Categories

**Consistency Achievements**
- "First Steps" - Complete first exercise
- "Week Warrior" - 7-day streak
- "Month Master" - 30-day streak
- "Year of the Ear" - 365-day streak

**Skill Achievements**
- "Note Novice" - Identify 100 notes correctly
- "Chord Champion" - Identify 500 chords correctly
- "Interval Intuition" - 50 intervals in a row
- "Perfect Ear" - Complete advanced mode with 95%+ accuracy

**Speed Achievements**
- "Quick Ear" - Answer 10 questions in under 20 seconds
- "Lightning Reflexes" - Sub-1-second correct answer

**Special Achievements**
- "Night Owl" - Practice after midnight
- "Early Bird" - Practice before 6 AM
- "Perfectionist" - 100% accuracy on any full session

### 3. Streak System

#### Daily Streaks
- Visual flame indicator
- Progressive rewards for maintaining streaks
- "Streak Freeze" items (earned or purchased) to protect streaks
- Streak milestones with special badges

#### Practice Reminders
- Customizable notification times
- Smart reminders based on usage patterns
- Gentle encouragement messaging

### 4. Leaderboards

#### Weekly Leaderboards
- Global rankings
- Friends-only rankings
- Regional rankings

#### Categories
- Total XP earned (weekly)
- Longest streak (all-time)
- Accuracy percentage (weekly)
- Speed records

### 5. Unlockable Content

#### Sounds & Instruments
- New instrument timbres unlocked through play
- Premium sounds (orchestral, vintage synths)

#### Themes
- App color themes unlocked at milestones
- Special seasonal themes

#### Challenges
- Advanced training modes unlock progressively
- "Expert" and "Master" difficulties require unlocking

---

## Design System

### Design Philosophy

Inspired by Airbnb's design principles:
1. **Clarity**: Every element serves a purpose
2. **Efficiency**: Minimal steps to accomplish tasks
3. **Beauty**: Aesthetics that inspire and delight
4. **Consistency**: Unified visual language throughout
5. **Warmth**: Human, approachable, and encouraging

### Color Palette

#### Primary Colors
```
Primary Gradient Start: #6366F1 (Indigo 500)
Primary Gradient End:   #8B5CF6 (Violet 500)
Primary Solid:          #7C3AED (Violet 600)
```

#### Secondary Colors
```
Success:    #10B981 (Emerald 500)
Warning:    #F59E0B (Amber 500)
Error:      #EF4444 (Red 500)
Info:       #3B82F6 (Blue 500)
```

#### Neutral Colors
```
Background Primary:   #FFFFFF
Background Secondary: #F9FAFB (Gray 50)
Background Tertiary:  #F3F4F6 (Gray 100)

Text Primary:    #111827 (Gray 900)
Text Secondary:  #6B7280 (Gray 500)
Text Tertiary:   #9CA3AF (Gray 400)

Border Light:    #E5E7EB (Gray 200)
Border Medium:   #D1D5DB (Gray 300)
```

#### Dark Mode Colors
```
Background Primary:   #111827 (Gray 900)
Background Secondary: #1F2937 (Gray 800)
Background Tertiary:  #374151 (Gray 700)

Text Primary:    #F9FAFB (Gray 50)
Text Secondary:  #9CA3AF (Gray 400)
Text Tertiary:   #6B7280 (Gray 500)
```

#### Accent Colors for Notes (Chromatic)
```
C:  #EF4444 (Red)
C#: #F97316 (Orange)
D:  #F59E0B (Amber)
D#: #EAB308 (Yellow)
E:  #84CC16 (Lime)
F:  #22C55E (Green)
F#: #14B8A6 (Teal)
G:  #06B6D4 (Cyan)
G#: #3B82F6 (Blue)
A:  #6366F1 (Indigo)
A#: #8B5CF6 (Violet)
B:  #D946EF (Fuchsia)
```

### Typography

#### Font Family
- **Primary**: SF Pro Display (iOS system font)
- **Monospace**: SF Mono (for musical notation, numbers)

#### Type Scale
```
Display Large:   34pt / Bold    (Main headlines)
Display Medium:  28pt / Bold    (Section headers)
Title Large:     22pt / Semibold (Card titles)
Title Medium:    17pt / Semibold (Subsection headers)
Body Large:      17pt / Regular  (Primary body text)
Body Medium:     15pt / Regular  (Secondary body text)
Caption:         13pt / Regular  (Labels, hints)
Caption Small:   11pt / Medium   (Badges, tags)
```

#### Line Heights
- Headlines: 1.2
- Body: 1.5
- Captions: 1.4

### Spacing System

Based on 4pt grid:
```
space-1:  4pt
space-2:  8pt
space-3:  12pt
space-4:  16pt
space-5:  20pt
space-6:  24pt
space-8:  32pt
space-10: 40pt
space-12: 48pt
space-16: 64pt
```

### Border Radius

```
radius-sm:   8pt  (Small buttons, tags)
radius-md:   12pt (Cards, inputs)
radius-lg:   16pt (Large cards, modals)
radius-xl:   24pt (Bottom sheets)
radius-full: 9999pt (Pills, avatars)
```

### Shadows (Light Mode)

```
shadow-sm:
  0 1px 2px rgba(0, 0, 0, 0.05)

shadow-md:
  0 4px 6px -1px rgba(0, 0, 0, 0.1),
  0 2px 4px -1px rgba(0, 0, 0, 0.06)

shadow-lg:
  0 10px 15px -3px rgba(0, 0, 0, 0.1),
  0 4px 6px -2px rgba(0, 0, 0, 0.05)

shadow-xl:
  0 20px 25px -5px rgba(0, 0, 0, 0.1),
  0 10px 10px -5px rgba(0, 0, 0, 0.04)
```

### Iconography

- **Style**: SF Symbols (iOS native)
- **Weight**: Regular for UI, Semibold for emphasis
- **Sizes**:
  - Small: 16pt
  - Medium: 20pt
  - Large: 24pt
  - XL: 32pt

### Animation Principles

#### Timing
```
duration-fast:   150ms (Micro-interactions)
duration-normal: 250ms (Standard transitions)
duration-slow:   350ms (Emphasized transitions)
duration-slower: 500ms (Page transitions)
```

#### Easing
```
ease-out:     cubic-bezier(0, 0, 0.2, 1)    - Elements entering
ease-in:      cubic-bezier(0.4, 0, 1, 1)    - Elements leaving
ease-in-out:  cubic-bezier(0.4, 0, 0.2, 1)  - Moving elements
spring:       damping: 15, stiffness: 150    - Playful interactions
```

---

## User Experience

### Information Architecture

```
Perfect Pitch App
├── Home (Tab 1)
│   ├── Daily Challenge Card
│   ├── Continue Training Card
│   ├── Quick Stats
│   └── Recommended Exercises
│
├── Train (Tab 2)
│   ├── Single Notes
│   │   ├── Note ID
│   │   ├── Note Comparison
│   │   └── Reference Pitch
│   ├── Chords
│   │   ├── Chord Quality
│   │   ├── Chord Roots
│   │   └── Progressions
│   ├── Intervals
│   │   ├── Identify
│   │   ├── Compare
│   │   └── Song Reference
│   ├── Scales & Modes
│   │   ├── Scale ID
│   │   └── Scale Degrees
│   └── Melodic Dictation
│       ├── Pitch
│       └── Rhythm
│
├── Progress (Tab 3)
│   ├── Overview Stats
│   ├── Skill Breakdown
│   ├── History Graph
│   └── Achievements
│
├── Leaderboard (Tab 4)
│   ├── Global
│   ├── Friends
│   └── Regional
│
└── Profile (Tab 5)
    ├── Account
    ├── Settings
    ├── Subscription
    └── Help & Support
```

### Screen Designs

---

#### 1. Home Screen

**Layout Description**:

```
┌─────────────────────────────────────┐
│  ← Safe Area                        │
│                                     │
│  Good morning, Sarah ☀️              │
│  Level 23 • 12,450 XP               │
│                                     │
│  ┌─────────────────────────────────┐│
│  │ 🔥 DAILY CHALLENGE              ││
│  │                                 ││
│  │ Today's Focus: Chord Quality    ││
│  │ ██████████░░░░░░░ 60%           ││
│  │                                 ││
│  │ [Continue Challenge →]          ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │ 🎯 STREAK                       ││
│  │                                 ││
│  │      🔥 14 Days                 ││
│  │   Keep it going!                ││
│  │                                 ││
│  └─────────────────────────────────┘│
│                                     │
│  Quick Practice                     │
│                                     │
│  ┌──────────┐ ┌──────────┐         │
│  │ 🎵       │ │ 🎹       │         │
│  │ Notes    │ │ Chords   │         │
│  │ 5 min    │ │ 5 min    │         │
│  └──────────┘ └──────────┘         │
│                                     │
│  ┌──────────┐ ┌──────────┐         │
│  │ ↕️       │ │ 🎼       │         │
│  │ Intervals│ │ Scales   │         │
│  │ 5 min    │ │ 5 min    │         │
│  └──────────┘ └──────────┘         │
│                                     │
│  This Week's Stats                  │
│  ┌─────────────────────────────────┐│
│  │ Accuracy: 87% ↑3%               ││
│  │ Sessions: 12                    ││
│  │ Time: 2h 34m                    ││
│  └─────────────────────────────────┘│
│                                     │
├─────────────────────────────────────┤
│  🏠    🎯    📊    🏆    👤         │
│  Home  Train Progress Lead Profile  │
└─────────────────────────────────────┘
```

**Design Notes**:
- Personalized greeting with time-of-day awareness
- Large, tappable cards with generous padding (16pt+)
- Subtle gradient backgrounds on feature cards
- Progress indicators with smooth animations
- Airbnb-style rounded corners (16pt radius)
- Soft shadows for depth hierarchy

---

#### 2. Training Selection Screen

**Layout Description**:

```
┌─────────────────────────────────────┐
│  Train                              │
│  Choose your exercise               │
│                                     │
│  ┌─────────────────────────────────┐│
│  │                                 ││
│  │  🎵 SINGLE NOTES                ││
│  │                                 ││
│  │  Master individual pitch        ││
│  │  recognition                    ││
│  │                                 ││
│  │  ●●●●○ Intermediate             ││
│  │                                 ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │                                 ││
│  │  🎹 CHORDS                      ││
│  │                                 ││
│  │  Identify chord qualities       ││
│  │  and progressions               ││
│  │                                 ││
│  │  ●●●○○ Beginner                 ││
│  │                                 ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │                                 ││
│  │  ↕️ INTERVALS                    ││
│  │                                 ││
│  │  Learn the distance between     ││
│  │  any two notes                  ││
│  │                                 ││
│  │  ●●●●● Advanced                 ││
│  │                                 ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │                                 ││
│  │  🎼 SCALES & MODES              ││
│  │                                 ││
│  │  Recognize scales and their     ││
│  │  characteristic sounds          ││
│  │                                 ││
│  │  ●●○○○ Beginner                 ││
│  │                                 ││
│  └─────────────────────────────────┘│
│                                     │
├─────────────────────────────────────┤
│  🏠    🎯    📊    🏆    👤         │
└─────────────────────────────────────┘
```

**Design Notes**:
- Full-width cards like Airbnb listing cards
- Subtle category illustrations or icons
- Progress indicator dots showing current skill level
- Cards have light hover/press states
- Vertical scroll with momentum

---

#### 3. Exercise Screen (Note Identification)

**Layout Description**:

```
┌─────────────────────────────────────┐
│  ✕                        ⚙️ 🔊     │
│                                     │
│  Question 7 of 20                   │
│  ████████████░░░░░░░░░░ 35%         │
│                                     │
│                                     │
│                                     │
│           ┌─────────────┐           │
│           │             │           │
│           │     🔊      │           │
│           │             │           │
│           │   Tap to    │           │
│           │   replay    │           │
│           │             │           │
│           └─────────────┘           │
│                                     │
│                                     │
│  What note is this?                 │
│                                     │
│                                     │
│  ┌───────┐ ┌───────┐ ┌───────┐     │
│  │       │ │       │ │       │     │
│  │   C   │ │   D   │ │   E   │     │
│  │       │ │       │ │       │     │
│  └───────┘ └───────┘ └───────┘     │
│                                     │
│  ┌───────┐ ┌───────┐ ┌───────┐     │
│  │       │ │       │ │       │     │
│  │   F   │ │   G   │ │   A   │     │
│  │       │ │       │ │       │     │
│  └───────┘ └───────┘ └───────┘     │
│                                     │
│         ┌───────────────┐           │
│         │       B       │           │
│         └───────────────┘           │
│                                     │
│  Streak: 🔥 4                       │
│                                     │
└─────────────────────────────────────┘
```

**Design Notes**:
- Distraction-free interface
- Large, easily tappable answer buttons (minimum 48pt height)
- Sound visualization animation when audio plays
- Progress bar with smooth animation
- Immediate visual feedback on selection
- Color-coded correct/incorrect states

---

#### 4. Answer Feedback Screen (Correct)

**Layout Description**:

```
┌─────────────────────────────────────┐
│  ✕                        ⚙️ 🔊     │
│                                     │
│  Question 7 of 20                   │
│  ████████████░░░░░░░░░░ 35%         │
│                                     │
│                                     │
│           ┌─────────────┐           │
│           │             │           │
│           │     ✓       │           │
│           │   Green     │           │
│           │   Circle    │           │
│           │             │           │
│           └─────────────┘           │
│                                     │
│         ✨ Correct! ✨               │
│                                     │
│            + 25 XP                  │
│                                     │
│  The note was:                      │
│                                     │
│         ┌───────────────┐           │
│         │               │           │
│         │   E4 (329Hz)  │           │
│         │               │           │
│         └───────────────┘           │
│                                     │
│  Did you know?                      │
│  E4 is the highest string on a     │
│  standard guitar in standard       │
│  tuning.                            │
│                                     │
│                                     │
│  ┌─────────────────────────────────┐│
│  │         Continue →              ││
│  └─────────────────────────────────┘│
│                                     │
└─────────────────────────────────────┘
```

**Design Notes**:
- Celebratory animation (confetti for streaks, checkmark bounce)
- XP gain animation (numbers floating up)
- Educational factoid to reinforce learning
- Auto-advance option in settings
- Green success color (#10B981)

---

#### 5. Answer Feedback Screen (Incorrect)

**Layout Description**:

```
┌─────────────────────────────────────┐
│  ✕                        ⚙️ 🔊     │
│                                     │
│  Question 7 of 20                   │
│  ████████████░░░░░░░░░░ 35%         │
│                                     │
│                                     │
│           ┌─────────────┐           │
│           │             │           │
│           │     ✗       │           │
│           │    Red      │           │
│           │   Circle    │           │
│           │             │           │
│           └─────────────┘           │
│                                     │
│         Not quite                   │
│                                     │
│                                     │
│  You answered: D                    │
│  Correct answer: E                  │
│                                     │
│     ┌─────────┐   ┌─────────┐      │
│     │   🔊    │   │   🔊    │      │
│     │  D (You)│   │E (Correct)│     │
│     │  Tap    │   │  Tap    │      │
│     └─────────┘   └─────────┘      │
│                                     │
│  Tip: E is a whole step higher     │
│  than D. Try singing the interval  │
│  to feel the distance.             │
│                                     │
│                                     │
│  ┌─────────────────────────────────┐│
│  │         Continue →              ││
│  └─────────────────────────────────┘│
│                                     │
└─────────────────────────────────────┘
```

**Design Notes**:
- Non-punishing, encouraging tone
- Comparison listening to hear the difference
- Helpful tip for improvement
- Red color is muted (#EF4444 at 80% opacity)
- No harsh sounds or animations

---

#### 6. Session Complete Screen

**Layout Description**:

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│           ┌─────────────┐           │
│           │             │           │
│           │     🏆      │           │
│           │   Trophy    │           │
│           │  Animation  │           │
│           │             │           │
│           └─────────────┘           │
│                                     │
│       Session Complete!             │
│                                     │
│  ┌─────────────────────────────────┐│
│  │                                 ││
│  │   Score: 85%                    ││
│  │   17 / 20 correct               ││
│  │                                 ││
│  │   ⭐⭐⭐ 3 Stars                 ││
│  │                                 ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │  + 425 XP                       ││
│  │  🔥 Streak: 5 (New record!)     ││
│  │  ⏱️ Time: 3:24                   ││
│  └─────────────────────────────────┘│
│                                     │
│       New Achievement! 🎉          │
│  ┌─────────────────────────────────┐│
│  │  🎯 "Quick Ear"                 ││
│  │  Answer 10 questions in         ││
│  │  under 20 seconds               ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │       Practice Again            ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │         Done                    ││
│  └─────────────────────────────────┘│
│                                     │
└─────────────────────────────────────┘
```

**Design Notes**:
- Celebratory animations (stars, confetti)
- Clear statistics display
- Achievement pop-up animation
- Share functionality for achievements
- Star rating encourages replaying for perfection

---

#### 7. Progress Dashboard

**Layout Description**:

```
┌─────────────────────────────────────┐
│  Progress                           │
│                                     │
│  ┌─────────────────────────────────┐│
│  │          LEVEL 23               ││
│  │   ████████████████░░░ 78%       ││
│  │   12,450 / 16,000 XP            ││
│  └─────────────────────────────────┘│
│                                     │
│  Overall Accuracy                   │
│  ┌─────────────────────────────────┐│
│  │         ┌─────┐                 ││
│  │         │ 84% │                 ││
│  │         └─────┘                 ││
│  │   [    Line Graph    ]          ││
│  │   Last 30 days                  ││
│  └─────────────────────────────────┘│
│                                     │
│  Skills Breakdown                   │
│                                     │
│  Notes      ████████████░░░ 89%    │
│  Chords     █████████░░░░░░ 72%    │
│  Intervals  ███████████░░░░ 85%    │
│  Scales     ██████░░░░░░░░░ 58%    │
│                                     │
│  Total Practice Time                │
│  ┌─────────────────────────────────┐│
│  │   This Week: 4h 23m             ││
│  │   All Time: 47h 12m             ││
│  └─────────────────────────────────┘│
│                                     │
│  Achievements (24/50)      View All │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐      │
│  │ 🎯 │ │ 🔥 │ │ ⚡ │ │ 🌟 │      │
│  └────┘ └────┘ └────┘ └────┘      │
│                                     │
├─────────────────────────────────────┤
│  🏠    🎯    📊    🏆    👤         │
└─────────────────────────────────────┘
```

**Design Notes**:
- Clean data visualization
- Airbnb-style horizontal bar graphs
- Interactive charts (tap to see details)
- Achievement badges with hover states
- Weekly/Monthly/All-time toggle

---

#### 8. Settings Screen

**Layout Description**:

```
┌─────────────────────────────────────┐
│  ← Settings                         │
│                                     │
│  SOUND                              │
│  ┌─────────────────────────────────┐│
│  │  Instrument          Piano  ▶  ││
│  ├─────────────────────────────────┤│
│  │  Volume              ████░░░░  ││
│  ├─────────────────────────────────┤│
│  │  Auto-play next          🔘 On ││
│  └─────────────────────────────────┘│
│                                     │
│  TRAINING                           │
│  ┌─────────────────────────────────┐│
│  │  Questions per session   20  ▶ ││
│  ├─────────────────────────────────┤│
│  │  Show note names        🔘 On  ││
│  ├─────────────────────────────────┤│
│  │  Octave range        C3-C6  ▶  ││
│  ├─────────────────────────────────┤│
│  │  Include sharps/flats   🔘 On  ││
│  └─────────────────────────────────┘│
│                                     │
│  NOTIFICATIONS                      │
│  ┌─────────────────────────────────┐│
│  │  Daily reminder         🔘 On  ││
│  ├─────────────────────────────────┤│
│  │  Reminder time       8:00 AM ▶ ││
│  ├─────────────────────────────────┤│
│  │  Streak warnings        🔘 On  ││
│  └─────────────────────────────────┘│
│                                     │
│  APPEARANCE                         │
│  ┌─────────────────────────────────┐│
│  │  Theme                 Auto  ▶ ││
│  ├─────────────────────────────────┤│
│  │  App icon           Default  ▶ ││
│  └─────────────────────────────────┘│
│                                     │
└─────────────────────────────────────┘
```

**Design Notes**:
- Grouped settings like iOS native
- Clear section headers
- Toggle switches with smooth animations
- Picker views for selections
- Haptic feedback on interactions

---

### Micro-interactions & Animations

#### 1. Sound Wave Visualization
- When a note plays, display an animated waveform
- Colors correspond to the note being played
- Subtle pulse animation while audio is active

#### 2. Answer Selection
- Button scales down slightly on press (0.96x)
- Correct: Green fill with checkmark, gentle bounce
- Incorrect: Red fill with shake animation, X mark

#### 3. XP Gain
- Numbers float upward and fade out
- "+25 XP" with subtle sparkle effect
- Level-up triggers full-screen celebration

#### 4. Streak Animation
- Flame icon flickers dynamically
- Number increments with spring animation
- Record-breaking streaks get special effects

#### 5. Navigation Transitions
- Horizontal slide for drill-down navigation
- Bottom sheet slides for modals
- Cross-fade for tab switches

#### 6. Loading States
- Skeleton screens match final layout
- Subtle shimmer animation
- Never block interaction for more than 200ms

---

## Technical Requirements

### Platform Requirements
- **iOS Version**: iOS 15.0+
- **Devices**: iPhone (optimized for all sizes)
- **iPad**: Adaptive layout support (future phase)

### Technology Stack

#### Frontend
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI (primary), UIKit (where needed)
- **Architecture**: MVVM with Combine
- **State Management**: SwiftUI @Observable / Combine

#### Audio
- **Framework**: AVFoundation
- **Audio Engine**: AVAudioEngine for low-latency playback
- **Sample Format**: 44.1kHz / 16-bit WAV for instruments
- **Synthesis**: AudioKit for pure tone generation

#### Backend
- **Platform**: Firebase / Supabase
- **Authentication**: Sign in with Apple, Email/Password
- **Database**: Cloud Firestore / PostgreSQL
- **Analytics**: Firebase Analytics, Mixpanel

#### Audio Content
- **Instrument Samples**: Pre-recorded, high-quality samples
- **File Size**: Approximately 50MB for base instruments
- **Additional Packs**: Downloaded on-demand

### Performance Requirements
- **Audio Latency**: < 20ms from tap to sound
- **App Launch**: < 2 seconds cold start
- **Frame Rate**: 60 FPS minimum for animations
- **Offline Mode**: Full functionality without internet
- **Battery**: Minimal impact during training sessions

### Accessibility
- **VoiceOver**: Full support for blind users
- **Dynamic Type**: Support for all text sizes
- **Color Blind Mode**: Alternative color schemes
- **Haptic Feedback**: Audio cues reinforced with haptics
- **Reduce Motion**: Simplified animations option

### Security & Privacy
- **Data Storage**: Core Data for local, encrypted in transit
- **Authentication**: Keychain for credentials
- **Privacy**: No audio recording, no microphone required
- **GDPR/CCPA**: Full compliance with data export/deletion

---

## Monetization Strategy

### Freemium Model

#### Free Tier
- Single note training (basic)
- 3 exercises per day limit
- Basic progress tracking
- Ads between sessions

#### Premium Tier ($9.99/month or $59.99/year)
- Unlimited exercises
- All training modes unlocked
- Advanced analytics
- All instruments & sounds
- Ad-free experience
- Priority support
- Exclusive achievements
- Early access to new features

#### Lifetime Purchase ($149.99)
- All premium features forever
- All future updates included

### In-App Purchases
- Additional instrument sound packs ($2.99 each)
- Streak freeze items ($0.99 for 3)
- Cosmetic themes ($1.99 each)

---

## Success Metrics

### Key Performance Indicators (KPIs)

#### Engagement Metrics
| Metric | Target |
|--------|--------|
| Daily Active Users (DAU) | 50,000+ |
| Monthly Active Users (MAU) | 200,000+ |
| DAU/MAU Ratio | > 25% |
| Average Session Duration | > 5 minutes |
| Sessions per User per Day | > 1.5 |
| Day 1 Retention | > 40% |
| Day 7 Retention | > 20% |
| Day 30 Retention | > 10% |

#### Learning Metrics
| Metric | Target |
|--------|--------|
| Average Accuracy Improvement (30 days) | > 15% |
| Users reaching "Intermediate" level | > 30% |
| Daily Challenge Completion Rate | > 60% |

#### Business Metrics
| Metric | Target |
|--------|--------|
| Conversion to Premium | > 5% |
| Monthly Recurring Revenue | Growth > 10% MoM |
| App Store Rating | > 4.7 stars |
| Customer Acquisition Cost | < $3 |
| Lifetime Value | > $25 |

---

## Development Phases

### Phase 1: MVP (Months 1-3)
- Core note identification training
- Basic gamification (XP, levels)
- User authentication
- Progress tracking
- iOS app launch

### Phase 2: Expansion (Months 4-6)
- Chord training mode
- Interval training mode
- Achievement system
- Leaderboards
- Premium subscription

### Phase 3: Enhancement (Months 7-9)
- Scale & mode training
- Melodic dictation
- Social features (friends, challenges)
- Additional instruments
- iPad optimization

### Phase 4: Growth (Months 10-12)
- Advanced analytics
- Personalized training plans
- Community features
- API for teachers
- Localization (10+ languages)

---

## Appendix

### A. Competitive Analysis

| App | Strengths | Weaknesses |
|-----|-----------|------------|
| Perfect Ear | Comprehensive | Dated UI, complex |
| Tenuto | Music theory focus | iOS only, limited gamification |
| EarMaster | Professional features | Desktop-first, expensive |
| Functional Ear Trainer | Scientific approach | Minimal UI, niche |
| Tonegym | Modern, gamified | Web-based, less mobile-focused |

**Our Differentiation**: Best-in-class mobile UX with Airbnb-quality design, scientifically-backed training methods, and engaging gamification.

### B. Research References

1. Absolute pitch training research by Diana Deutsch
2. Spaced repetition learning (Ebbinghaus)
3. Gamification in education (Deterding et al.)
4. Mobile learning effectiveness studies

### C. Glossary

- **Absolute/Perfect Pitch**: Ability to identify a note without reference
- **Relative Pitch**: Ability to identify notes relative to a reference
- **Interval**: Distance between two notes
- **Chord Quality**: Type of chord (major, minor, etc.)
- **Timbre**: Tone color or quality of a sound

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2024-01-19 | Product Team | Initial PRD |

---

*This PRD is a living document and will be updated as the product evolves.*
