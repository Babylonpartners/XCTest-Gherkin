//
//  XCTestCase+Screenshots.swift
//  Pods-XCTest-Gherkin_Example
//
//  Created by Ilya Puchka on 31/10/2019.
//

import Foundation
import XCTest

private(set) var automaticScreenshotsBehaviour: AutomaticScreenshotsBehaviour = .none
private(set) var automaticScreenshotsQuality: XCTAttachment.ImageQuality = .medium
private(set) var automaticScreenshotsLifetime: XCTAttachment.Lifetime = .deleteOnSuccess

public struct AutomaticScreenshotsBehaviour: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let onFailure     = AutomaticScreenshotsBehaviour(rawValue: 1 << 0)
    public static let beforeStep    = AutomaticScreenshotsBehaviour(rawValue: 1 << 1)
    public static let afterStep     = AutomaticScreenshotsBehaviour(rawValue: 1 << 2)
    public static let none: AutomaticScreenshotsBehaviour = []
    public static let all: AutomaticScreenshotsBehaviour = [.onFailure, .beforeStep, .afterStep]
}

@available(iOS 9.0, OSX 10.11, *)
extension XCTestCase {

    /// Set behaviour for automatic screenshots (default is `.none`), their quality (default is `.medium`) and lifetime (default is `.deleteOnSuccess`)
    public static func setAutomaticScreenshotsBehaviour(
        _ behaviour: AutomaticScreenshotsBehaviour,
        quality: XCTAttachment.ImageQuality = .medium,
        lifetime: XCTAttachment.Lifetime = .deleteOnSuccess
    ) {
        automaticScreenshotsBehaviour = behaviour
        automaticScreenshotsQuality = quality
        automaticScreenshotsLifetime = lifetime
    }

    func attachScreenshot() {
        // if tests have no host app there is no point in making screenshots
        guard Bundle.main.bundlePath.hasSuffix(".app") else { return }

        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot, quality: automaticScreenshotsQuality)
        attachment.lifetime = automaticScreenshotsLifetime
        add(attachment)
    }
}

