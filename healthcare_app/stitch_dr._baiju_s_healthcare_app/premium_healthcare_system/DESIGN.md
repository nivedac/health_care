---
name: Premium Healthcare System
colors:
  surface: '#f8f9fa'
  surface-dim: '#d9dadb'
  surface-bright: '#f8f9fa'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f5'
  surface-container: '#edeeef'
  surface-container-high: '#e7e8e9'
  surface-container-highest: '#e1e3e4'
  on-surface: '#191c1d'
  on-surface-variant: '#3f4941'
  inverse-surface: '#2e3132'
  inverse-on-surface: '#f0f1f2'
  outline: '#6f7a70'
  outline-variant: '#becabe'
  surface-tint: '#006d3d'
  primary: '#006a3b'
  on-primary: '#ffffff'
  primary-container: '#268451'
  on-primary-container: '#f6fff4'
  inverse-primary: '#7ed99e'
  secondary: '#56615c'
  on-secondary: '#ffffff'
  secondary-container: '#dae5df'
  on-secondary-container: '#5c6762'
  tertiary: '#296743'
  on-tertiary: '#ffffff'
  tertiary-container: '#43815b'
  on-tertiary-container: '#f6fff5'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#9af6b8'
  primary-fixed-dim: '#7ed99e'
  on-primary-fixed: '#00210f'
  on-primary-fixed-variant: '#00522d'
  secondary-fixed: '#dae5df'
  secondary-fixed-dim: '#bec9c3'
  on-secondary-fixed: '#141e1a'
  on-secondary-fixed-variant: '#3f4945'
  tertiary-fixed: '#b0f1c3'
  tertiary-fixed-dim: '#95d5a8'
  on-tertiary-fixed: '#00210f'
  on-tertiary-fixed-variant: '#0e5130'
  background: '#f8f9fa'
  on-background: '#191c1d'
  surface-variant: '#e1e3e4'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  container-margin: 24px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style

The design system is engineered for a premium healthcare experience that balances clinical precision with human-centric warmth. The brand personality is authoritative yet approachable, evoking feelings of safety, clarity, and vitality.

The visual style is a hybrid of **High-End Minimalism** and **Modern Functionalism**, drawing inspiration from the structured hierarchy of Material 3 and the refined aesthetics of Apple Health. It utilizes a "Sanctuary" approach: maximizing white space to reduce cognitive load for patients and practitioners. Glassmorphism is applied selectively to overlays and modals to maintain spatial awareness and a sense of lightweight agility.

## Colors

The palette is anchored by **Emerald Green**, symbolizing health and growth. 

- **Primary:** Used for key actions, active states, and brand indicators.
- **Secondary:** A soft tint of the primary green used for subtle backgrounds, chips, and progress bars.
- **Neutral/Surface:** A range of soft greys and pure whites are used to differentiate content layers without creating harsh visual breaks.
- **Functional:** Success (Emerald), Warning (Amber), and Error (Crimson) follow standard medical conventions but are adjusted for high legibility against white backgrounds.

## Typography

This design system utilizes **Inter** exclusively to ensure maximum readability and a technical, yet clean appearance. 

- **Hierarchy:** Dramatic scale differences between display titles and body text help users scan medical data quickly.
- **Weight:** Semi-bold (600) is used for headers to establish firm anchors, while Regular (400) is used for all instructional and data-entry text to avoid visual clutter.
- **Letter Spacing:** Tightened slightly on larger headers for a premium, editorial feel, and tracked out on small labels for accessibility.

## Layout & Spacing

The layout follows a **Fluid Grid** model with a 12-column structure for desktop and a 4-column structure for mobile. 

- **Rhythm:** An 8px linear scale (with 4px increments for micro-adjustments) governs all padding and margins.
- **Mobile:** Margins are set to 24px to provide "breathing room" at the edges of the device, reinforcing the premium feel.
- **Safe Areas:** Healthcare data is often dense; use vertical stacks of 32px to separate distinct medical categories (e.g., Vitals vs. Medications).

## Elevation & Depth

This design system employs a **Layered Tonal** strategy combined with **Glassmorphism**.

- **Surfaces:** Level 0 is the neutral background (#F9FAFB). Level 1 is a pure white card.
- **Shadows:** Use extremely soft, long-range ambient shadows (Blur: 20px-40px, Opacity: 4-6%) to make cards appear to float gently above the surface. Avoid harsh, dark shadows.
- **Glassmorphism:** Navigation bars and floating modals utilize a `backdrop-filter: blur(20px)` with a semi-transparent white tint (70-80% opacity) to maintain context of the underlying content.
- **Floating Action Buttons (FAB):** Following Material 3, the FAB occupies the highest elevation level with a slightly more pronounced shadow to signify primary interaction.

## Shapes

The shape language is defined by **Large Radii (20px)**. This softness counters the clinical nature of healthcare, making the interface feel more human and less "institutional."

- **Cards & Modals:** Use the standard 20px (`rounded-lg` equivalent in this system).
- **Buttons:** Use fully pill-shaped (100px) profiles for primary actions to distinguish them from content containers.
- **Inputs:** Follow a softer 12px radius to balance the structural requirements of text entry.

## Components

### Buttons
- **Primary:** Pill-shaped, Emerald Green background, white text. No border.
- **Secondary:** Emerald Green text, Soft Grey background (#F3F4F6), pill-shaped.
- **FAB:** Material 3 style, large square with high rounding, Emerald Green background, placed in the bottom-right for primary medical logging.

### Input Fields
- **Style:** Outlined with a 1px border (#E5E7EB). On focus, the border transitions to 2px Emerald Green with a subtle outer glow.
- **Validation:** Clear, icon-based indicators for medical data accuracy.

### Cards
- **Structure:** White background, 20px corners, soft ambient shadow. 
- **Content:** Information is grouped logically with 16px internal padding. 

### Overlays & Modals
- **Treatment:** Full-screen or centered modals use glassmorphism backgrounds to dim the rest of the UI while keeping the user oriented.

### Animations
- **Transitions:** Use 300ms "Ease-Out-Expo" for page transitions.
- **Micro-interactions:** Subtle 2% scale-up on button press. 
- **Feedback:** Use "Subtle Pulses" for active monitoring states (e.g., a heart rate reading or an uploading lab result).