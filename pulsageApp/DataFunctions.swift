import UIKit
import Parse

struct DataFunctions {
    /*
    func test(number: Int, completition: (PFObject) -> ()) {
        completition(PFObject())
    }
    */
    
    public func videos(user: PFObject, completition: @escaping ([PFObject?]) -> ()) {
        //self.currentData.removeAll(keepingCapacity: false)
        let videosQuery = PFQuery(className: "Videos")
        videosQuery.whereKey("User", equalTo: user)
        videosQuery.findObjectsInBackground(block: {
            (result, error) in
            if error == nil {
                guard let videos = result else {return}
                completition(videos)
            } else {
                completition([nil])
            }
        })
    }
    
    public func challenges(user: PFObject, completition: @escaping([PFObject?]) -> ()) {
        //self.currentData.removeAll(keepingCapacity: false)
        let challengeQuery = PFQuery(className: "Challenges")
        challengeQuery.whereKey("User", equalTo: user)
        challengeQuery.findObjectsInBackground { (result, error) in
            if error == nil {
                guard let challenges = result else {return}
                completition(challenges)
            } else {
                completition([nil])
            }
        }
    }
}


