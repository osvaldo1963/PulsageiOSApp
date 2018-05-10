import Parse

extension PFFile {
    func getImage() -> URL {
        guard let PicUrl = self.url else {return URL(string: "")!}
        guard let Url = URL(string: PicUrl) else {return URL(string: "")!}
        return Url
    }
}

extension PFObject {
    var handle: String {
        guard let result =  self["handle"] as? String else {return String()}
        return result
    }
}
