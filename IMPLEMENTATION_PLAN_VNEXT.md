# Version Implementation Plan (Splash + Offline Access)

## Scope

This version has 2 goals:

1. Update the app opening experience (current attached design is draft; final design pending).
2. Fix offline behavior so logged-in users can access downloaded sessions without internet.

## Confirmed Product Decisions

1. Opening redesign should include both in-app opening screen and native splash alignment once final design is provided.
2. In offline mode, show only downloaded items.
3. If token expires while offline, keep offline access.
4. Keep analytics behavior unchanged for this release.

## Current Findings

### Opening/Splash flow

- Native launch splash exists on Android/iOS (`launch_background.xml`, `LaunchScreen.storyboard`).
- In-app splash is `SplashPage` and then intro screen is `IntroPage`.
- The attached UI mock appears to target the **intro/opening screen** (content + CTA + video), not only native launch splash.

### Offline behavior

- Downloads are stored and tracked with `flutter_downloader` in `DownloadableProductsRepository`.
- Playback already tries offline path first (`offlineUrl`) for completed downloads.
- Main issue likely occurs earlier: `SessionsCubit.onPageOpened()` always calls remote `getSession()` and emits failure on network errors.
- If session fetch fails, library/session content is not loaded from local Hive cache, so downloaded items are hard/impossible to reach in UI.

## Implementation Plan

## Task 1 - Opening Screen Redesign

### Approach

- Keep native OS launch screen simple/brand-consistent.
- Implement final marketing/opening screen in `IntroPage` (or a dedicated widget used by it), matching final design.
- Preserve current navigation behavior:
  - Logged in -> `HomePage`
  - Logged out -> opening/intro + login/signup actions

### Steps

1. Finalize visual spec (spacing, typography, colors, assets, video behavior, safe-area behavior).
2. Implement UI updates in `lib/app/splash/intro_page.dart` (or split into smaller widgets if needed).
3. If requested, align native launch splash assets:
   - Android: `android/app/src/main/res/drawable*/launch_background.xml`
   - iOS: `ios/Runner/Base.lproj/LaunchScreen.storyboard`
4. Add/adjust basic widget tests for intro CTA visibility and navigation intents.

### Acceptance Criteria

- Opening screen matches approved design.
- CTA actions work (`Create my free account`, `Login`).
- No regression in auth routing from splash to home/intro.

## Task 2 - Offline Access to Downloaded Sessions (Priority)

### Required Behavior

- If user has previously logged in and downloaded sessions, they can open app offline and access/play downloaded items.

### Proposed Fix

1. **Add offline fallback in session loading**
   - In `SessionsCubit` / `SessionsRepository`, on network failure:
     - Load session/library model from Hive boxes (`audioPacks`, `scriptPacks`, `audioWithScriptPacks`, `recentAudios`, `scripts`).
     - Emit `SessionsLoadSuccess` with local data when cache is available.
     - Emit failure only if both network and local cache are unavailable.

2. **Differentiate failure types**
   - Treat connectivity-related failures separately from auth/token failures.
   - Offline/network failure -> fallback to local cache.
   - Invalid auth/token -> keep current failure/logout behavior.

3. **Preserve downloaded accessibility**
   - Ensure product lists shown offline still include downloaded products so existing `useOfflineLinkIfAvailable(...)` path resolves to local file.
   - Keep existing online/offline play gating in list items, but allow downloaded items always.

4. **UX improvements for offline mode**
   - Show non-blocking banner/snackbar: "Offline mode: showing downloaded content."
   - Optional: when item is not downloaded and offline, keep current message.

### Validation / Test Plan

1. Login online with a test account.
2. Download at least 1 audio and 1 script.
3. Fully close app.
4. Disable internet.
5. Open app:
   - Library should load from cache.
   - Downloaded audio should play.
   - Downloaded script should open.
   - Non-downloaded item should not play (expected).
6. Re-enable internet, refresh sessions, ensure normal online behavior remains.

### Risks

- If cache schema is incomplete for reconstructing session, fallback may load partial data.
- Current state management may show transient failure before fallback if not ordered correctly.
- Auth edge case: expired token while offline must not silently mask true auth issues when back online.

## File-Level Change Estimate

- `lib/library/cubit/sessions_cubit.dart` (fallback logic and error branching)
- `lib/library/data/sessions_repository.dart` (optional helper for building session from Hive)
- Potential minor UI messaging updates in library/home views
- `lib/app/splash/intro_page.dart` (final design implementation once approved)

## Open Questions

1. For Task 1, should we update only in-app `IntroPage`, or also native OS launch splash assets?
2. For offline mode, should users see:
   - only downloaded items, or
   - full library list with unavailable items disabled?
3. If token is expired while offline, do you want to keep user in offline mode until they explicitly log out?
4. Should we include analytics events for offline fallback usage in this release?

## Delivery Suggestion

- Phase A (Priority): Offline fallback + validation.
- Phase B: Opening screen redesign after final design handoff.
