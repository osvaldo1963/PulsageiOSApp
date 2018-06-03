import UIKit
import Parse

class VideoComment: UIViewController {
    
    public var videoObject: PFObject!
    private let cellId = "id"
    private var dataForTable: [PFObject] = []
    
    private lazy var comment: CommentHeader = {
        let vw = CommentHeader()
        vw.commentInput.delegate = self
        vw.commentInput.placeholder = "Comment..."
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    private lazy var table: UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(CommentCell.self, forCellReuseIdentifier: self.cellId)
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addsubview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationProps()
        self.getComments()
        self.currentUserData()
        
    }
    
    private func navigationProps() {
        self.navigationController?.navigationBar.topItem?.title = "Comments"
    }
    
    private func absorvers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.resizeViewForKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc private func resizeViewForKeyboard(notification: Notification) {
        //guard let keyboardFrame = notification.userInfo?[UIKeyboardIsLocalUserInfoKey] as? NSValue else {return}
        
    }
    
    private func addsubview() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.table)
        self.table.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.table.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.table.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.table.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        
        self.view.addSubview(self.comment)
        self.comment.topAnchor.constraint(equalTo: self.table.bottomAnchor).isActive = true
        self.comment.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.comment.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.comment.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func getHeaderData(header: CommentPageHeader) {
        let videoDescription = self.videoObject
        videoDescription?.fetchInBackground(block: { (object, error) in
            if error == nil {
                guard let data = object else {return}
                guard let videoDescription = data["description"] as? String else {return}
                header.comment.text = videoDescription
                header.comment.handleHashtagTap({ (hash) in
                    self.presentHashTag(hashtag: hash)
                })
                
                guard let userData = data["User"] as? PFObject else {return}
                userData.fetchInBackground(block: { (result, error) in
                    if error == nil {
                        guard let user = result else {return}
                        guard let picPorfile = user["profilePicture"] as? PFFile else {return}
                        header.profilePicture.sd_setImage(with: picPorfile.getImage(), completed: nil)
                    }
                })
            }
        })
    }
    
    private func getComments() {
        let query = PFQuery(className: "VideoComments")
        query.whereKey("Video", equalTo: self.videoObject)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (data, error) in
            guard let comments = data else {return}
            self.dataForTable.removeAll(keepingCapacity: false)
            self.dataForTable = comments
            DispatchQueue.main.async {
                self.table.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        }
    }
    
    private func currentUserData() {
        guard let currentUser = PFUser.current() else {return}
        guard let profilePicture = currentUser["profilePicture"] as? PFFile else {return}
        self.comment.profilePicture.sd_setImage(with: profilePicture.getImage(), completed: nil)
    }
    
    private func presentHashTag(hashtag: String) {
        let hastagPage = HashTag()
        hastagPage.hashTagString = hashtag
        self.navigationController?.pushViewController(hastagPage, animated: true)
    }
    
    @objc private func presentprofile(sender: GestureRescognizer) {
        
        guard let data = sender.data else {return}
        let profileTab = ProfileTab()
        profileTab.userObject = data
        self.navigationController?.pushViewController(profileTab, animated: true)
    }
    
}

extension VideoComment: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //=========================================
    //Mark: Header
    //=========================================
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = CommentPageHeader()
            self.getHeaderData(header: header)
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 140
        } else {
            return 0
        }
    }
    
    //=========================================
    //Mark: End Header
    //=========================================
    
    
    //=========================================
    //Mark: Cell
    //=========================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return self.dataForTable.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return UITableViewCell()
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? CommentCell else {
                return UITableViewCell()
            }
            let row = self.dataForTable[indexPath.row]
            guard let commentText = row["comment"] as? String else {return UITableViewCell()}
            cell.commentText.text = commentText
            
            guard let userdata = row["User"] as? PFObject else {return UITableViewCell()}
            userdata.fetchInBackground { (result, error) in
                if error == nil {
                    guard let user = result else {return}
                    guard let picProfile = user["profilePicture"] as? PFFile else {return}
                    cell.profilePicture.sd_setImage(with: picProfile.getImage(), completed: nil)
                    let tapGesture = GestureRescognizer(target: self, action: #selector(self.presentprofile(sender:)))
                    tapGesture.data = user
                    cell.profilePicture.addGestureRecognizer(tapGesture)
                    
                    guard let username = user[" handle"] as? String else {return}
                    cell.linkToProfile.setTitle(username.getTextFromEmail(), for: .normal)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        } else {
            return 90
        }
    }
    
    //=========================================
    //Mark: End Cell
    //=========================================
    
    //=========================================
    //Mark: Footer
    //=========================================
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            return nil
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 0
        }
    }
    //=========================================
    //Mark: End Footer
    //=========================================

}

extension VideoComment: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let user = PFUser.current() else {return false}
        guard let userid = PFUser.current()?.objectId else {return false}
        guard let videoDescription = self.videoObject["description"] as? String else {return false}
        guard let userForVideo = self.videoObject["User"] as? PFObject else {return false}
        guard let userIdForVideo = userForVideo.objectId else {return false}
        guard let userHandle = userForVideo["handle"] as? String else {return false}
        
        if userid != "" {
            if textField.text != ""{
                let query = PFObject(className: "VideoComments")
                query["comment"] = textField.text
                query["User"] = user
                query["Video"] = self.videoObject
                query.saveInBackground { (success, error) in
                    if success {
                        self.getComments()
                        textField.text = ""
                        textField.resignFirstResponder()
                        DispatchQueue.main.async {
                            self.table.reloadSections(IndexSet(integer: 1), with: .automatic)
                        }
                        
                        let parsefunctions = ParseFunctions()
                        parsefunctions.sendpushNifications(receiver: userIdForVideo, message: "\(userHandle) just comment on your video \(videoDescription)", sender: userid)
                        
                    }
                }
            } else {
                textField.endEditing(true)
            }
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -220, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -220, up: false)
    }
    
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        
        let moveDuration = 0.2
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}

