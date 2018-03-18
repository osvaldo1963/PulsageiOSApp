import UIKit
import Parse

struct ParseData {
    
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
    /*
    public func LoadChallengesAndVideos(ClassName: String, Result: @escaping (_ challengeid:String, _ userForChallenge: PFObject, _ title: String, _ back:[PFObject]) -> Void) {
        let query = PFQuery(className: ClassName)
        query.cachePolicy = .networkElseCache
        query.whereKey("block", notEqualTo: true)
        query.findObjectsInBackground { (data, error) in
            guard let datad = data , datad.count != 0 else {return}
            
            for each in datad {
                guard let title = each["title"] as? String,
                      let id = each.objectId, title != "", id != "",
                      let useridFormChalleng = each["user"] as? String, useridFormChalleng != "" else {return}
                let query = PFQuery(className: "Videos")
                query.cachePolicy = .networkElseCache
                query.whereKey("challengeid", equalTo: id)
                query.limit = 1
                query.whereKey("block", notEqualTo: true)
                query.findObjectsInBackground { (data, error) in
                    guard let datab = data, datab.count != 0 else {return}
                    self.UserQuery(id: useridFormChalleng, Result: { (user) in
                        Result(id, user, title, datab)
                    })
                }
            }
            
        }
    }
 
    */
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
