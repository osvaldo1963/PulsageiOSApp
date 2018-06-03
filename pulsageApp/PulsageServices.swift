import UIKit
import Alamofire
import Parse
import NotificationBannerSwift
import AVFoundation

extension String {
    var videoUrl: String {
        return "https://pulsage.nyc3.digitaloceanspaces.com/\(self).mp4"
    }
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}

struct PulsageServices {
    
    public var videoUrl: URL?
    public var user: PFObject?
    public var name: String?
    public var descript: String?
    public var challenge: PFObject?
    
    private let parsefunctions = ParseFunctions()
    
    public func uploadVideo(completition: @escaping (_ result: Any?,_ error: Error?) ->()) {
        let banner = NotificationBanner(title: "Video is Uploading!!")
        banner.show()
        DispatchQueue.global(qos: .background).async {
            do {
                guard let videourl = self.videoUrl else {return}
                let videoName = String.random(length: 11)
                let videoData = try Data(contentsOf: videourl)
                let serverurl = "https://mighty-refuge-37669.herokuapp.com/upload"
                let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]

                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(videoData, withName: "upload", fileName: "\(videoName).mp4", mimeType: "\(videoName).mp4")
                }, usingThreshold: UInt64.init(), to: serverurl, method: .post, headers: headers) { (result) in
                    switch result{
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            guard let result = response.result.value as? String else {return}
                            if result == "good" {
                                //create Thumnail & upload it
                                self.uploadThumbnail(videoName: videoName, completition: { (finish, error) in
                                    if error == nil {
                                        guard let completed = finish else {return}
                                        if completed {
                                            let banner = NotificationBanner(title: "Video finish uploading")
                                            banner.show()
                                            self.sendNotification()
                                            completition(response.result.value, nil)
                                        }
                                    }
                                })
                            }
                        }
                    case .failure(let error):
                        completition(nil, error)
                    }
                }
            } catch {}
        }
    }
    
    private func uploadThumbnail(videoName: String, completition: @escaping (_ finish: Bool?, _ error: Error?)->()){
        guard let videourl = self.videoUrl else {return}
        guard let thumbnailReady = self.createThumbnailOfVideoFromFileURL(videoURL: videourl) else {return}
        guard let imageData = UIImagePNGRepresentation(thumbnailReady) else {return}
        
        let parseImageFile = PFFile(name: "thumb.png", data: imageData)
        parseImageFile?.saveInBackground(block: { (success, error) in
            if success {
                let query = PFObject(className: "Videos")
                query["name"] = self.name
                query["description"] = self.descript
                query["videourl"] = videoName.videoUrl
                query["User"] = self.user
                query["views"] = 0
                query["Votes"] = []
                //code change
                if let cha = self.challenge {
                    query["Challenges"] = cha
                } else {
                    query["Challenges"] = PFObject(withoutDataWithClassName: "Challenges", objectId: "nil")
                }
                //code change
                if let hashs = self.descript?.gethashtags() {
                    query["hashtags"] = self.sendAshTags(hashTags: hashs)
                } else {
                    query["hashtags"] = []
                }
                query["thumbnail"] = parseImageFile
                query.saveInBackground(block: { (finish, error) in
                    if error == nil {
                        if finish {
                            completition(true, nil)
                        }
                    } else {
                        completition(false, error)
                    }
                })
            }
        })
    }
    
    private func sendNotification() {
        guard let challengeData = self.challenge else {return}
        guard let senderuserId = self.user?.objectId else {return}
        do {
            let challengeResult = try challengeData.fetch()
            guard let userForChallenge = challengeResult["User"] as? PFObject else {return}
            let userResult = try userForChallenge.fetch()
            
            guard let usercha = userResult["User"] as? PFObject else {return}
            guard let chaDescription = challengeResult["description"] as? String else {return}
            guard let userid = usercha.objectId else {return}
            guard let username = usercha["handle"] as? String else {return}
            self.parsefunctions.sendpushNifications(receiver: userid, message: "\(username) just upload a video in to your challenge \(chaDescription)", sender: senderuserId)
        } catch {}
    }
    
    //Mark: this function creates the thumbnails for each videos
    private func createThumbnailOfVideoFromFileURL(videoURL: URL) -> UIImage? {
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
            //change this to a nil image
            print("thumbnail creator thumnail: \(error)")
        }
        return nil
    }
    
    private func sendAshTags(hashTags: [String]) -> [String] {
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
                insert.saveEventually().waitUntilFinished()
                
                let query = PFQuery(className: "hashtag")
                query.whereKey("tittle", equalTo: hash.dropFirst())
                
                do {
                    let check = try query.getObjectWithId(insert.objectId!)
                    guard let object  = check.objectId else {return String()}
                    return object
                } catch {
                    print("hash tag error: \(error)")
                    return "it is empty"
                }
            }
            
        }
        return map
    }
    
}
