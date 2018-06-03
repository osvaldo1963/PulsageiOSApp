import UIKit
import Parse
import NotificationBannerSwift
import AVFoundation
import Alamofire


struct ParseFunctions {
    
    enum QueryType {
        case getFirstObject
        case findObjects
    }
    
    enum objectType {
        case saveInback
    }
    
    public func SingleUserData(usersId: String, Data: @escaping (PFObject) -> Void)  {
        let query  = PFUser.query()
        query?.whereKey("objectId", equalTo: usersId)
        query?.getFirstObjectInBackground(block: { (result, error) in
            if error == nil {
                guard let user = result else {return}
                Data(user)
            } 
        })
    }
    
    public func sendpushNifications(receiver: String, message: String, sender: String) {
        PFCloud.callFunction(inBackground: "sendpush", withParameters: ["id": receiver, "message": message, "sender": sender]) { (result, error) in
        }
    }
    
    public func unregisterForPush() {
        let token = UserDefaults.standard
        guard let deviceToken = token.object(forKey: "deviceToken") as? Data else {return}
        guard let userid = PFUser.current()?.objectId else {return}
        print(userid)
        
        let install = PFInstallation.current()
        install?.setDeviceTokenFrom(deviceToken)
        install?["channels"] = ["global"]
        install?.saveEventually({ (success, error) in
            if error == nil {
                if success  {
                    print("it wokrkus")
                }
            } else {
                print(error)
            }
        })
        
        PFPush.subscribeToChannel(inBackground: userid) { (success, error) in
            if error != nil {
                print(error.debugDescription)
            }
        }
    }
    
    public func likeButtonAction(sender: CustomBtn) {
        guard let object = sender.object else {return}
        object.fetchInBackground { (result, error) in
            if error == nil {
                guard let data = result else {return}
                guard let arrayVotes = data["Votes"] as? [String] else {return}
                guard let currentUserId = PFUser.current()?.objectId else {return}
                var array = arrayVotes
                if array.contains(currentUserId) {
                    let indexAt = array.index(of: currentUserId)
                    array.remove(at: indexAt!)
                    data["Votes"] = array
                    data.saveEventually()
                    let icon = UIImage(named: "heart")
                    sender.setImage(icon, for: .normal)
                } else {
                    array.append(currentUserId)
                    data["Votes"] = array
                    data.saveEventually()
                    let icon = UIImage(named: "redHart")
                    sender.setImage(icon, for: .normal)
                }
            }
        }
    }
    
    
    
    public func UserQuery(id: String, Result: @escaping (PFObject) -> Void) {
        let object = PFUser.query()
        object?.cachePolicy = .networkElseCache
        object?.getObjectInBackground(withId: id, block: { (result, error) in
            if error == nil {
                guard let user = result else {return}
                Result(user)
                
            } else {
                guard let err = error else {return}
                print(err)
            }
        })
    }
    
    public func ParseQuery(body: [String: Any]?, ClassName: String, Type: QueryType,Result: @escaping ([Any]) -> Void) {
        let query = PFQuery(className: ClassName)
        query.cachePolicy = .networkElseCache
        
        if body != nil {
            guard let BResult = body else {return}
            for(key, value) in BResult {
                query.whereKey(key, equalTo: value)
            }
        }
        
        switch Type {
        case .getFirstObject:
            
            query.getFirstObjectInBackground(block: { (data, error) in
                if error == nil {
                    guard let DataResult = data else {return}
                    Result([DataResult])
                } else {
                    guard let err = error else {return}
                    print(err)
                }
            })
            
        case .findObjects:
            
            query.findObjectsInBackground { (data, error) in
                if error == nil {
                    guard let DataResult = data else {return}
                    Result(DataResult)
                } else {
                    guard let err = error else {return}
                    print(err)
                }
            }
        }
    }
    
    public func ParseObject(body: [String: Any]?, ClassName: String, Type: objectType, Result: @escaping(Any) -> Void) {
        let object = PFObject(className: ClassName)
        if body != nil {
            guard let BResult = body else {return}
            for (key, value) in BResult {
                object[key] = value
            }
        }
        switch Type {
        case .saveInback:
            object.saveInBackground(block: { (success, error) in
                if error == nil {
                    Result(success)
                } else {
                    guard let err = error else {return}
                    print(err)
                }
            })
        }
    }
    
}


