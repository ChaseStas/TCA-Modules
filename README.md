# TCA-Modules
Modules to use with The Composable Architecture
You can run Examples project to see how it works.

## Apphud

| Name  | Description |
| ------------- | ------------- |
| delegate |  Subscribe to delegate changes  |
| hasActiveSubscription  | True if has active subscription |
| isNonRenewingPurchaseActive  |  True if has non renewing purchase |
| paywalls  | Return array of ApphudPaywall |
| purchase  | Purchase ApphudProduct product |
| restore  | Restore purchase |
| setIDFA  | Set IDFA for Apphud |
| start  | Call on launch to initialize Apphud |
| submitPushNotificationsToken  | Submit push notification token to Apphud |
| subscribeToReceivePaywalls  | Subscribe to notification to receive paywall updates |

## IDFA

| Name  | Description |
| ------------- | ------------- |
| request | Request ATT on iOS 14.5 and above  |
| status  | Return current status for ATT |

## RemoteNotificationClient

| Name  | Description |
| ------------- | ------------- |
| isRegister | Check if is registered for remote notifications  |
| register  | Register for remote notifications via UIApplication |
| unregister  | Register for remote notifications via UIApplication |

## UserNotificationClient

| Name  | Description |
| ------------- | ------------- |
| add | Add UNNotificationRequest  |
| delegate  | UNUserNotificationCenter delegate  |
| getNotificationSettings  |  |
| removeDeliveredNotificationsWithIdentifiers  |  |
| removePendingNotificationRequestsWithIdentifiers  |  |
| requestAuthorization  | Request authorization for notifications |

## UIClient

Module to communicate with UI and UIKit functionality 

| Name  | Description |
| ------------- | ------------- |
| copyToClipboard | Copy string to clipboard  |
| dismissKeyboard  | Dismiss keyboard if opened |
| openURL  | Open URL inside application in Safari controller or redirects to default browser |
| openReviewInAppStore  | Open App store app with review page |
| presentShareActivity | Present UIActivityViewController |
| rateUs  | Present system 'rate us' view |
| showToast  | Present toast |
| vibrate  | Play vibration with selected type |
