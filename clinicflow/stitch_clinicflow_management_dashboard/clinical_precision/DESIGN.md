---
name: Clinical Precision
colors:
  surface: '#f7f9fb'
  surface-dim: '#d8dadc'
  surface-bright: '#f7f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f4f6'
  surface-container: '#eceef0'
  surface-container-high: '#e6e8ea'
  surface-container-highest: '#e0e3e5'
  on-surface: '#191c1e'
  on-surface-variant: '#414755'
  inverse-surface: '#2d3133'
  inverse-on-surface: '#eff1f3'
  outline: '#717786'
  outline-variant: '#c1c6d7'
  surface-tint: '#005bc1'
  primary: '#0058bc'
  on-primary: '#ffffff'
  primary-container: '#0070eb'
  on-primary-container: '#fefcff'
  inverse-primary: '#adc6ff'
  secondary: '#505f76'
  on-secondary: '#ffffff'
  secondary-container: '#d0e1fb'
  on-secondary-container: '#54647a'
  tertiary: '#006947'
  on-tertiary: '#ffffff'
  tertiary-container: '#00855b'
  on-tertiary-container: '#f5fff6'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#adc6ff'
  on-primary-fixed: '#001a41'
  on-primary-fixed-variant: '#004493'
  secondary-fixed: '#d3e4fe'
  secondary-fixed-dim: '#b7c8e1'
  on-secondary-fixed: '#0b1c30'
  on-secondary-fixed-variant: '#38485d'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#f7f9fb'
  on-background: '#191c1e'
  surface-variant: '#e0e3e5'
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
  title-lg:
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
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.01em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 40px
  xl: 64px
  gutter: 24px
  margin-desktop: 32px
  margin-mobile: 16px
---

## Brand & Style
The design system is engineered for high-stakes healthcare environments, prioritizing clarity, trust, and cognitive ease. The brand personality is "Quiet Authority"—it provides a professional, clinical atmosphere without the sterility of legacy medical software. 

Drawing from **Minimalism** and **Corporate Modern** styles with an **Apple-inspired aesthetic**, the UI focuses on high-quality typography, generous whitespace, and subtle depth. The goal is to reduce "charting fatigue" for clinicians through a balanced interface that feels more like a refined productivity suite than a complex database.

## Colors
The palette utilizes **Medical Blue** as the primary driver for action and identity, symbolizing stability and expertise. **Slate Gray** provides a sophisticated neutral base for text and secondary interface elements, avoiding the harshness of pure black. 

**Mint Green** is reserved strictly for success states, healthy vitals, and "complete" indicators. The background uses a soft off-white (`#F8FAFC`) to reduce glare during long shifts, while primary surfaces remain pure white to create a clear visual hierarchy of information containers.

## Typography
**Inter** is the sole typeface for this design system to ensure maximum legibility and a systematic, utilitarian feel. The type hierarchy follows a strict scale to manage dense patient data. 

Headlines use semi-bold weights with slight negative letter-spacing for a modern, premium feel. Body text defaults to 14px (`body-md`) for data-heavy tables and 16px (`body-lg`) for patient notes and narratives. Labels use a medium weight and slightly increased tracking to remain legible at small sizes on dashboards.

## Layout & Spacing
The layout employs a **Fluid Grid** model with high-density capabilities. On desktop, a 12-column system is used with 24px gutters. For the clinic management aspect, the "Master-Detail" pattern is the primary layout philosophy—a navigation rail on the left, a list of records in the secondary pane, and full details in the primary central area.

**Breakpoints:**
- **Mobile (<600px):** Single column, 16px margins, bottom navigation.
- **Tablet (600px - 1024px):** 8-column grid, 24px margins, collapsed side rail.
- **Desktop (>1024px):** 12-column grid, 32px margins, expanded side rail.

## Elevation & Depth
In line with Apple-inspired aesthetics, depth is conveyed through **Ambient Shadows** and **Tonal Layers** rather than heavy borders. 

- **Level 0 (Background):** `#F8FAFC` - The canvas.
- **Level 1 (Cards/Surface):** White background with a very soft, diffused shadow: `0px 4px 12px rgba(0, 0, 0, 0.05)`.
- **Level 2 (Modals/Popovers):** White background with a more pronounced shadow: `0px 12px 32px rgba(0, 0, 0, 0.1)`.

Avoid inner shadows or heavy "neomorphic" bevels. Use 1px borders in `#E2E8F0` only for separating list items or defining input fields.

## Shapes
The shape language is "Soft-Modern." Using a base roundedness of 8px (`0.5rem`), the UI feels approachable but professional. 

- **Standard Elements:** 8px (Buttons, Input Fields, Small Cards).
- **Large Containers:** 16px (Patient Folders, Main Dashboard Widgets).
- **Full Rounding:** Used exclusively for Status Pills (e.g., "Active," "Pending") and Avatar frames.

## Components

### Buttons
- **Primary:** Solid Medical Blue, white text, 8px radius. High emphasis.
- **Secondary:** Surface Gray (`#F1F5F9`) with Slate Gray text. Low emphasis.
- **Ghost:** No background, Blue text. Used for less frequent actions like "Cancel."

### Inputs & Form Fields
Fields use an 8px radius with a 1px border (`#CBD5E1`). On focus, the border transitions to Primary Blue with a 2px "glow" shadow. Labels are consistently placed above the input field in `label-md` Slate Gray.

### Cards
Cards are the primary container for patient data. They feature a white background, 16px radius, and the Level 1 Ambient Shadow. Padding inside cards is a generous 24px (`md`) to prevent data crowding.

### Navigation
- **Desktop Rail:** A fixed left-hand rail (80px collapsed / 240px expanded). Uses active state indicators with a subtle blue vertical bar on the leading edge.
- **Chips:** Used for medical tags (e.g., "Allergies," "Chronic"). These are "pill-shaped" with a light tint of the primary or tertiary color.

### List Items
List items (e.g., Patient Search results) use a 1px bottom border separator and high-contrast titles for rapid scanning. Hover states trigger a subtle shift to `#F1F5F9` background color.