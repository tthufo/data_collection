import UIKit
import Flutter
import VRP
import AVKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let vrp = FlutterMethodChannel(name: "vmg.ekyc/VRP",
                                               binaryMessenger: controller.binaryMessenger)
    
               vrp.setMethodCallHandler({
                   [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
               
               guard call.method == "VRP" else {
                result(FlutterMethodNotImplemented)
                return
               }
                   guard let args = call.arguments as? [String : Any] else {return}
                   let option = args["option"] as! String
                   self?.callForVRP(result: result, option: option)
           })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    private func option(option: String) -> VRP.Mode {
        return option == "0" ? .STANDARD : option == "1" ? .ADVANCE_1 : option == "2" ? .ADVANCE_2 : .ADVANCE_3
    }
    
    private func callForVRP(result: @escaping FlutterResult, option: String) {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        let nav = VRP.viewController(mode: self.option(option: option), lang: .VI)

        switch cameraAuthorizationStatus {
        case .denied:
            result(self.toString(["Thông báo": "Quyền truy cập Máy ảnh bị hạn chế"]))
            break
        case .authorized:
            Threads.performTaskInMainQueue {
                self.window.rootViewController!.present(nav, animated: true)
                nav.callback = { (action, data) -> Void in
                    if action == 1 {
                        result(self.resultString(data as? [AnyHashable : Any]))
                    }
                }
            }
            break
        case .restricted:
            result(self.toString(["Thông báo": "Quyền truy cập Máy ảnh bị hạn chế"]))
            break

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    Threads.performTaskInMainQueue {
                        self.window.rootViewController!.present(nav, animated: true)
                        nav.callback = { (action, data) -> Void in
                            if action == 1 {
                                result(self.resultString(data as? [AnyHashable : Any]))
                            }
                        }
                    }
                } else {
                    result(self.toString(["Thông báo": "Quyền truy cập Máy ảnh bị hạn chế"]))
                }
            }
        @unknown default:
            break
            
        }
    }
}


class Threads {

  static let concurrentQueue = DispatchQueue(label: "AppNameConcurrentQueue", attributes: .concurrent)
  static let serialQueue = DispatchQueue(label: "AppNameSerialQueue")

  class func performTaskInMainQueue(task: @escaping ()->()) {
    DispatchQueue.main.async {
      task()
    }
  }

  class func performTaskInBackground(task:@escaping () throws -> ()) {
    DispatchQueue.global(qos: .background).async {
      do {
        try task()
      } catch let error as NSError {
        print("error in background thread:\(error.localizedDescription)")
      }
    }
  }

  class func perfromTaskInConcurrentQueue(task:@escaping () throws -> ()) {
    concurrentQueue.async {
      do {
        try task()
      } catch let error as NSError {
        print("error in Concurrent Queue:\(error.localizedDescription)")
      }
    }
  }

  class func perfromTaskInSerialQueue(task:@escaping () throws -> ()) {
    serialQueue.async {
      do {
        try task()
      } catch let error as NSError {
        print("error in Serial Queue:\(error.localizedDescription)")
      }
    }
  }

  class func performTaskAfterDealy(_ timeInteval: TimeInterval, _ task:@escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: (.now() + timeInteval)) {
      task()
    }
  }
}

