---
name: Apply Design System
description: Instructions for styling UI components using Filmania's Aura Cinema Design System.
---

# Apply Filmania Design System

When building UI for Filmania, you must strictly adhere to the "Aura Cinema" / "The Digital Curator" design system. The app uses a "No-Line Philosophy".

## 1. Core Principles
- **No-Line Philosophy:** NEVER use 1px dividers or borders! Create separation using 8px whitespace or tonal and background color shifts.
- **Intentional Asymmetry:** The design favors asymmetrical spacing for an editorial look.
- **Fluid Depth:** Emphasize layering. Background -> Surface -> Cards -> Floating Modals.

## 2. Colors
- **NEVER** use `Theme.of(context).colorScheme` or hardcoded hex colors (e.g. `Colors.black`, `Colors.white`).
- **ALWAYS** use `AppColors.of(context)` for any color binding.
- Example: `AppColors.of(context).primary` for buttons/highlights, `AppColors.of(context).background` for scaffolding.

## 3. Spacing and Border Radius
- **NEVER** use raw doubles for paddings unless mathematically necessary.
- **ALWAYS** use `AppSpacing` tokens. Example: `AppSpacing.md` (16dp), `AppSpacing.lg` (24dp).
- **Border Radius:** Default radius for cards/buttons is 24dp. Use `AppSpacing.radius` instead of hardcoding. 

## 4. Typography
- The app uses **Manrope** for Headlines (Bold 700/800) and **Inter** for Body text (Medium 400/500/600).
- Extract text styles from context using custom extensions if available, or maintain hierarchy cleanly without messy inline styles.

## 5. Hero CTAs (Signature Style)
Primary buttons use a "lit-from-within" gradient. Implement a BoxDecoration with:
- Linear Gradient (topLeft to bottomRight).
- BoxShadow with a large blur radius (e.g. 32px) and low opacity (4%-20% depending on mode).
