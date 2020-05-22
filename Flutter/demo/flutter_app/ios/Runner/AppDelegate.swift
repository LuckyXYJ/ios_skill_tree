import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var methodChannel:FlutterMethodChannel?;
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        GeneratedPluginRegistrant.register(withRegistry: self)
        GeneratedPluginRegistrant.register(with: self)

        let vc = self.window.rootViewController;
        
        methodChannel = FlutterMethodChannel.init(name: "mine_page/method", binaryMessenger: vc as! FlutterBinaryMessenger);
        
        let imageVC = UIImagePickerController.init()
        imageVC.delegate = self;
        
        methodChannel!.setMethodCallHandler { (call, result) in
            if("picture" == call.method) {
                print(call.method, "==========")
                vc?.present(imageVC, animated: true)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        let imagePath = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerImageURL")] as! NSURL;
        
        methodChannel!.invokeMethod("imagePath", arguments: imagePath.path!);
    }
}
