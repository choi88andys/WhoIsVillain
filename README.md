# Who Is Villain (범인은 바로 너!)

Andygile's first app: a player clock for turn-based board games.
Up to six players, a time limit for each, and a scoreboard of who ran out the clock.

- Released on the App Store in December 2021, retired in 2026.
- SwiftUI, iOS 15 or later, Google Mobile Ads with UMP consent.
- This repository is archived and no longer maintained.

## Links

- About the app: https://andygile.com/whoisvillain/
- Privacy policy and terms: https://andygile.com/whoisvillain/legal/
- 개인정보 처리방침 및 이용약관: https://andygile.com/whoisvillain/legal/ko/

## Known issue

The age question is inverted. Answering "yes, 17 or older" tags ad requests
as under the age of consent, and "no" tags them as adults
(`ContentView.swift`, `BannerView.swift`). It was not fixed before the app
was retired.
