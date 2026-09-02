import Cocoa
import FlutterMacOS

/// Choosing the shared library folder, and holding onto it.
///
/// A sandboxed app is granted a folder the listener picks, but only for as
/// long as it holds the scope, and only for this run unless a bookmark is
/// kept. The two entitlements this relies on are declared in
/// `Runner.entitlements`: `files.user-selected.read-write`, without which a
/// book cannot be published into the folder, and `files.bookmarks.app-scope`,
/// without which the folder is forgotten at the next launch.
final class ShelfFolderBridge: NSObject {
  static func register(with registrar: FlutterPluginRegistrar) {
    let bridge = ShelfFolderBridge()
    let channel = FlutterMethodChannel(
      name: "audiobooks/shelf_folder",
      binaryMessenger: registrar.messenger)
    channel.setMethodCallHandler { call, result in
      bridge.handle(call, result: result)
    }
    objc_setAssociatedObject(
      channel, &ShelfFolderBridge.bridgeKey, bridge, .OBJC_ASSOCIATION_RETAIN)
    registrar.publish(channel)
  }

  private static var bridgeKey: UInt8 = 0

  /// The folder whose scope is currently held. Kept for as long as the app
  /// runs: the library lists and copies out of it at any moment.
  private var accessing: URL?

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "choose":
      result(choose())
    case "resolve":
      guard
        let arguments = call.arguments as? [String: Any],
        let bookmark = arguments["bookmark"] as? FlutterStandardTypedData
      else {
        result(nil)
        return
      }
      result(claim(bookmark: bookmark.data))
    case "release":
      release()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func choose() -> [String: Any]? {
    let panel = NSOpenPanel()
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    panel.allowsMultipleSelection = false
    panel.canCreateDirectories = true
    panel.prompt = "Choose"
    panel.message = "Choose the folder your shared library is kept in."

    guard panel.runModal() == .OK, let url = panel.url else { return nil }
    return claim(url: url, bookmark: nil)
  }

  private func claim(url: URL, bookmark existing: Data?) -> [String: Any]? {
    release()
    guard url.startAccessingSecurityScopedResource() else { return nil }
    accessing = url

    let bookmark =
      existing
      ?? (try? url.bookmarkData(
        options: .withSecurityScope,
        includingResourceValuesForKeys: nil,
        relativeTo: nil))
    guard let bookmark else {
      release()
      return nil
    }
    return [
      "path": url.path,
      "bookmark": FlutterStandardTypedData(bytes: bookmark),
    ]
  }

  private func claim(bookmark: Data) -> [String: Any]? {
    var stale = false
    guard
      let url = try? URL(
        resolvingBookmarkData: bookmark,
        options: .withSecurityScope,
        relativeTo: nil,
        bookmarkDataIsStale: &stale)
    else {
      return nil
    }
    // A stale bookmark still opens the folder, but wants replacing: the folder
    // has moved or been renamed since it was written.
    return claim(url: url, bookmark: stale ? nil : bookmark)
  }

  private func release() {
    accessing?.stopAccessingSecurityScopedResource()
    accessing = nil
  }
}
