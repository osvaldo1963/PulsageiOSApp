import UIKit
import CoreData
import Parse
import AVKit
import Parse
import AVFoundation
import FBSDKCoreKit
import UserNotifications
import NotificationBannerSwift
import AWSCore
import AWSPinpoint
import AWSMobileClient



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var pinpoint: AWSPinpoint?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        self.setParse()
        self.facebookSdkSetUp()
        self.notificationSettings(application: application)
        
        AWSMobileClient.sharedInstance().interceptApplication(application,didFinishLaunchingWithOptions: launchOptions)
        self.pinpoint =  AWSPinpoint(configuration: AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions))
        
        
        application.applicationIconBadgeNumber = 0
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: SplashAnimation())
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let install = PFInstallation.current()
        install?.setDeviceTokenFrom(deviceToken)
        install?.saveInBackground(block: { (success, error) in
            if error == nil {
                
            }
        })
        PFPush.subscribeToChannel(inBackground: "globalChannel") { (success, error) in
            if error == nil {
                if success {
                    //channel connected successfuly
                } else {
                    
                }
            }
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
     
    }
    
    //Mark: Parse Settings
    func setParse() {
        let confiParse = ParseClientConfiguration {
            (parse) in
            parse.applicationId = "iGQKoGJQTo3AUXSG4v1LMEXS0r9RRn9ecnpuJuuG"
            parse.clientKey = "1qrhLziRnAqMYnS08HOTMGACzx9nbuH0HrnM26NM"
            //parse.isLocalDatastoreEnabled = true
            parse.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: confiParse)
    }
    //=======================================
    
    //Mark: Facebook sdk setup
    func facebookSdkSetUp() {
        FBSDKAppLinkUtility.fetchDeferredAppLink { (url, error) in
            if error == nil {
                guard let Url = url else {return}
                UIApplication.shared.canOpenURL(Url)
            } else {
                guard let err = error else {return}
              
            }
        }
    }
    //========================================

    func notificationSettings(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) { (authorized, error) in
            if authorized {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            
            }
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("url \(url)")
        print("url path \(url.path)")
        print("url host \(url.host)")

        guard let urlPath = url.path as? String else {return true}
        if urlPath == "/video" {
            print("it detects inner path")
            UIApplication.shared.statusBarStyle = .lightContent
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            window?.rootViewController = UINavigationController(rootViewController: VideoPlayer())
            return true
        }
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
 
    internal var shouldRotate = false
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        /*
         Mark: put this code in the view controller you want rotation
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = true
        */
        return shouldRotate ? .allButUpsideDown : .portrait
    }
    
    var timing = 0
    
    //Mark:this function upload video to parse server
    func submitVideos(videoUrl: URL, user: PFObject, name: String, descript: String, challenge: PFObject?) {
        let url = videoUrl
        //let userid = user
        
        if url.absoluteString != "" {
            do {
                let filedat = try Data(contentsOf: url)
                let pffile = PFFile(name: "video.mp4", data: filedat)
                pffile?.saveInBackground({ (finished, error) in
                    if finished {
                        let imageData = UIImagePNGRepresentation(self.createThumbnailOfVideoFromFileURL(videoURL: url)!)
                        let parseImageFile = PFFile(name: "thumb.png", data: imageData!)
                        parseImageFile?.saveInBackground(block: { (success, error) in
                            if success {
                                let query = PFObject(className: "Videos")
                                query["name"] = name
                                query["description"] = "\(descript)"
                                query["video"] = pffile
                                query["User"] = user
                                query["views"] = 0
                                //code change
                                if challenge != nil {
                                    query["Challenges"] = challenge
                                } else {
                                    query["Challenges"] = PFObject(withoutDataWithClassName: "Challenges", objectId: "nil")
                              
                                }
                                //code change
                                if let hashs = descript.gethashtags() {
                                    query["hashtags"] = self.sendAshTags(hashTags: hashs)
                                } else {
                                    query["hashtags"] = []
                                }
                                query["thumbnail"] = parseImageFile
                                query.saveInBackground(block: { (result, error) in
                                    if result {
                                        let successBanner = NotificationBanner(title: "Video Finish Uploading", subtitle: "Your video is done uploading", leftView: nil, rightView: nil, style: .success, colors:nil)
                                        successBanner.show()
                                        successBanner.onTap = {
                                            print("si sriber")
                                        }
                                    } else {
                                        let errorBanner = NotificationBanner(title: "Problem while Uploading Video", subtitle: "check your internet connection", leftView: nil, rightView: nil, style: .danger, colors:nil)
                                        errorBanner.show()
                                    }
                                })
                            }
                        })
                    }
                }, progressBlock: { (timing) in
                    var timer = 1
                    //Mark: When video started uploading
                    if Int(timing) == 1  {
                        let banner = NotificationBanner(title: "Video is Uploading!!")
                        banner.show()
                        timer = timer + 1
                    } 
                
                })
            } catch {
                let alert = UIAlertController(title: "Error", message: "it was an error uploding video", preferredStyle: .alert)
                let  actionbtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(actionbtn)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //Mark: this function creates the thumbnails for each videos
    func createThumbnailOfVideoFromFileURL(videoURL: URL) -> UIImage? {
        
        let asset = AVAsset(url: videoURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(1), 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            // Set a default image if Image is not acquired
        }
        return nil
    }
    
    func sendAshTags(hashTags: [String]) -> [String] {
        //var holder: [String] = []
        
        let map = hashTags.map { (hash) -> String in
            //var holder: [String] = []
            let query = PFQuery(className: "hashtag")
            query.whereKey("tittle", equalTo: hash.dropFirst())
            do {
                let check = try query.getFirstObject()
                guard let object  = check.objectId else {return String()}
                return object
                
            } catch {
                
                let insert = PFObject(className: "hashtag")
                insert["tittle"] = hash.dropFirst()
                insert.saveEventually({ (success, error) in
                    print("is beign saved")
                })
                
                let query = PFQuery(className: "hashtag")
                query.whereKey("tittle", equalTo: hash.dropFirst())
                do {
                    let check = try query.getFirstObject()
                    guard let object  = check.objectId else {return String()}
                    return object
                } catch {
                    return "is is empty "
                }
                
            }
          
        }
        /*
        for hash in hashTags {
            let query = PFQuery(className: "hashtag")
            query.whereKey("tittle", equalTo: hash.dropFirst())
            do {
                let check = try query.getFirstObject()
                if let object  = check.objectId {
                    holder.append(object)
                }
                
            } catch {
                print(hash)
                let insert = PFObject(className: "hashtag")
                insert["tittle"] = hash.dropFirst()
                insert.saveEventually()
                if let id = insert.objectId {
                    holder.append(id)
                }
                
                   
            }
        }
        */
        return map
    }
    //=================================================================
    
    /* Mark:
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
     */
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "pulsageApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
 
                fatalError("Unresolved error \(error), \(error.userInfo)")
                */
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}



