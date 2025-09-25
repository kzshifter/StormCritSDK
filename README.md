# StormCritSDK 🚀

[![Swift Package Manager](https.img.shields.io/badge/Swift_Package_Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)

`StormCritSDK` is a lightweight Swift package that sends critical in-app events to your backend, which then forwards them as real-time alerts to a Telegram bot.

Never miss a critical payment failure or a major bug again. Get notified instantly where you are most likely to see it.

## How It Works

The SDK is designed to be a simple bridge between your iOS application and a monitoring backend. The typical data flow is:

1.  **Your App**: An important event occurs (e.g., a payment fails).
2.  **StormCritSDK**: You call `StormCritSDK.sendEvent(...)`.
3.  **Your Server**: The SDK sends a request to your configured `baseURLString`.
4.  **Telegram Bot**: Your server processes the request and uses the Telegram Bot API to send a formatted message to a designated chat or channel.

## Features

-   ✅ Get real-time alerts for critical events directly in Telegram.
-   ✅ Simple to integrate and configure.
-   ✅ Asynchronous and thread-safe API using modern Swift Concurrency.
-   ✅ Pre-defined and custom event types.

## Installation

### Swift Package Manager

You can add `StormCritSDK` to your project using Swift Package Manager. In Xcode, select `File` > `Add Packages...` and enter the repository URL:

```
https://github.com/kzshifter/StormCritSDK
```

## Usage

### 1. Configuration

Before sending any events, you must configure the SDK. This is typically done in your `AppDelegate`'s `application(_:didFinishLaunchingWithOptions:)` method or in your `App`'s initializer.

```swift
import StormCritSDK

// ...

StormCritSDK.configure(
    configuration: .init(
        token: "YOUR_API_TOKEN",
        baseURLString: "https://your.server.com"
    )
)
```

#### Configuration Parameters:

-   **`token`**: Your unique API token for authenticating with your backend.
-   **`baseURLString`**: The base URL of your server endpoint that is configured to forward messages to your Telegram bot.
-   **`endpoint`** (optional): The API endpoint path. Defaults to `.crit`.

### 2. Sending Events

Once configured, you can send events from anywhere in your application. These events will be forwarded to your Telegram bot.

#### Sending a Pre-defined Event

Use the static `sendEvent` method to report a standard event.

```swift
StormCritSDK.sendEvent(event: .failPayment)
```

You can also include additional, structured information that can be formatted in your Telegram message.

```swift
StormCritSDK.sendEvent(
    event: .failPayment,
    additionalInfo: ["Reason": "User cancelled", "ProductID": "com.myapp.monthly"]
)
```

#### Sending a Custom Event

If the standard events don't cover your use case, you can define and send your own custom event.

```swift
StormCritSDK.sendEvent(event: .custom("UserLoggedInFromNewDevice"))
```

## Available Events

The SDK provides the following list of pre-defined events (`StormCritEvent`):

-   `.failGeneration`
-   `.failPresentPaywall`
-   `.failPayment`
-   `.coldStartTimeout`
-   `.applicationNotResponding`
-   `.serverError`
-   `.custom(String)` - for any other cases.

## License

This project is distributed under the MIT license. See the `LICENSE` file for more information.
