// iOS Share Extension for receiving audio files
// TODO: Configure in Xcode:
// 1. Add a new "Share Extension" target named "ShareExtension"
// 2. Set the App Group to "group.com.mellivora.encore"
// 3. Configure the Bundle ID: com.mellivora.encore.ShareExtension

import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = extensionItem.attachments else {
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }

        for attachment in attachments {
            if attachment.hasItemConformingToTypeIdentifier(UTType.audio.identifier) {
                attachment.loadItem(forTypeIdentifier: UTType.audio.identifier, options: nil) { [weak self] (data, error) in
                    guard let url = data as? URL else { return }

                    // Copy file to shared App Group container
                    let fileManager = FileManager.default
                    if let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.mellivora.encore") {
                        let destURL = groupURL.appendingPathComponent(url.lastPathComponent)
                        try? fileManager.copyItem(at: url, to: destURL)

                        // Store the path for the main app to pick up
                        let defaults = UserDefaults(suiteName: "group.com.mellivora.encore")
                        var pendingFiles = defaults?.stringArray(forKey: "pending_audio_imports") ?? []
                        pendingFiles.append(destURL.path)
                        defaults?.set(pendingFiles, forKey: "pending_audio_imports")
                    }

                    self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                }
            }
        }
    }

    override func configurationItems() -> [Any]! {
        return []
    }
}
