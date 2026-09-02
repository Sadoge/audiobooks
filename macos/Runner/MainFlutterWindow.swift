import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController
    self.minSize = NSSize(width: 720, height: 600)
    self.setContentSize(NSSize(width: 1100, height: 760))
    self.center()
    self.tabbingMode = .disallowed

    RegisterGeneratedPlugins(registry: flutterViewController)
    // The shared library folder is asked for here rather than through the
    // general file picker, which cannot hold onto a security-scoped folder.
    ShelfFolderBridge.register(
      with: flutterViewController.registrar(forPlugin: "ShelfFolderBridge"))

    super.awakeFromNib()
  }
}
