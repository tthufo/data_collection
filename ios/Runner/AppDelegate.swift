import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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

