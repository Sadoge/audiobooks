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

    super.awakeFromNib()
  }
}
