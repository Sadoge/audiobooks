import Flutter
import UIKit
import UniformTypeIdentifiers

/// Choosing the shared library folder, and holding onto it.
///
/// A folder the document picker hands over is security scoped. The app may
/// read it only while it holds that scope, and loses the right to it when the
/// process ends unless a bookmark is kept and resolved again on the next
/// launch. A picker that returns nothing but a path — which is what the
/// general-purpose plugin does — gives back a folder that cannot be listed and
/// is gone by morning, so the shared library asks for its folder here instead.
///
/// Only folders are offered. Providers that do not vend directories, which at
/// the time of writing includes Dropbox and Google Drive, will not appear in
/// the picker at all; that is the provider's choice and nothing here can
/// change it.
final class ShelfFolderBridge: NSObject {
  static func register(with registrar: FlutterPluginRegistrar) {
    let bridge = ShelfFolderBridge()
    let channel = FlutterMethodChannel(
      name: "audiobooks/shelf_folder",
      binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      bridge.handle(call, result: result)
    }
    // The registrar holds the channel; the channel holds the bridge.
    objc_setAssociatedObject(
      channel, &ShelfFolderBridge.bridgeKey, bridge, .OBJC_ASSOCIATION_RETAIN)
    registrar.publish(channel)
  }

  private static var bridgeKey: UInt8 = 0

  /// The folder whose scope is currently held, so that it can be let go of
  /// before another is taken. Left claimed for as long as the app runs: the
  /// library lists and copies out of it at any moment.
  private var accessing: URL?
  private var pending: FlutterResult?

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "choose":
      choose(result)
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

  private func choose(_ result: @escaping FlutterResult) {
    // A second picker over the first would strand the first one's reply.
    if let waiting = pending {
      waiting(nil)
    }
    pending = result

    let picker = UIDocumentPickerViewController(
      forOpeningContentTypes: [.folder], asCopy: false)
    picker.delegate = self
    picker.allowsMultipleSelection = false
    guard let presenter = topViewController() else {
      finish(nil)
      return
    }
    presenter.present(picker, animated: true)
  }

  /// Takes hold of a folder and describes it back to Dart.
  private func claim(url: URL, bookmark existing: Data?) -> [String: Any]? {
    release()
    guard url.startAccessingSecurityScopedResource() else { return nil }
    accessing = url

    guard let bookmark = existing ?? (try? url.bookmarkData()) else {
      release()
      return nil
    }
    return [
      "path": url.path,
      "bookmark": FlutterStandardTypedData(bytes: bookmark),
    ]
  }

  /// Takes hold of a folder chosen on an earlier run.
  private func claim(bookmark: Data) -> [String: Any]? {
    var stale = false
    guard
      let url = try? URL(
        resolvingBookmarkData: bookmark,
        options: [],
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

  private func finish(_ value: [String: Any]?) {
    pending?(value)
    pending = nil
  }

  private func topViewController() -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes.compactMap {
      $0 as? UIWindowScene
    }
    let scene =
      scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
    var top =
      scene?.windows.first(where: { $0.isKeyWindow })?.rootViewController
      ?? scene?.windows.first?.rootViewController
    while let presented = top?.presentedViewController {
      top = presented
    }
    return top
  }
}

extension ShelfFolderBridge: UIDocumentPickerDelegate {
  func documentPicker(
    _ controller: UIDocumentPickerViewController,
    didPickDocumentsAt urls: [URL]
  ) {
    guard let url = urls.first else {
      finish(nil)
      return
    }
    finish(claim(url: url, bookmark: nil))
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    finish(nil)
  }
}
