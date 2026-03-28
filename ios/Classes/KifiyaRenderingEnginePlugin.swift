import Flutter
import UIKit
import UniformTypeIdentifiers

public class KifiyaRenderingEnginePlugin: NSObject, FlutterPlugin, UIDocumentPickerDelegate {
    var flutterResult: FlutterResult?
    var viewController: UIViewController? {
        return UIApplication.shared.delegate?.window??.rootViewController
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        // Use the same channel name as Android
        let channel = FlutterMethodChannel(name: "kifiya_file_picker", binaryMessenger: registrar.messenger())
        let instance = KifiyaRenderingEnginePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "pickFile":
        flutterResult = result
        let args = call.arguments as? [String: Any]
        let allowedTypes = args?["allowedTypes"] as? [String]
        presentDocumentPicker(allowedTypes: allowedTypes)
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    default:
        result(FlutterMethodNotImplemented)
    }
}


private func presentDocumentPicker(allowedTypes: [String]?) {
    var contentTypes: [UTType] = []

    if let allowedTypes = allowedTypes, !allowedTypes.isEmpty {
        for ext in allowedTypes {
            switch ext.lowercased() {
            case "jpg", "jpeg", "png":
                contentTypes.append(.image)
            case "pdf":
                contentTypes.append(.pdf)
            case "doc", "docx":
                contentTypes.append(.data)
            case "txt":
                contentTypes.append(.plainText)
            default:
                contentTypes.append(.item)
            }
        }
    } else {
        contentTypes = [.item] // all file types
    }

    let picker = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes, asCopy: true)
    picker.delegate = self
    picker.modalPresentationStyle = .formSheet

    DispatchQueue.main.async {
        self.viewController?.present(picker, animated: true, completion: nil)
    }
}


    // MARK: - UIDocumentPickerDelegate

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            flutterResult?(url.path)
        } else {
            flutterResult?(nil)
        }
        flutterResult = nil
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        flutterResult?(nil)
        flutterResult = nil
    }
}
