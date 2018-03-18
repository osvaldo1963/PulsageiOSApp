import UIKit
import Parse

class notifications: UIViewController {
    
    let tableviewcellId = "cellid"
    var dataHolder = [PFObject]()
    
    fileprivate lazy var refreshController: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Updating Data")
        refresh.addTarget(self, action: #selector(self.getNotofications), for: .valueChanged)
        return refresh
    }()
    
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: self.view.frame.size.height / 2 - 20, width: self.view.frame.size.width, height: 30)
        label.textColor = .gray
        label.text = "Notifications"
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var tableview: UITableView = {
        let table = UITableView()
        table.addSubview(self.refreshController)
        table.delegate = self
        table.dataSource = self
        table.register(UserCell.self, forCellReuseIdentifier: self.tableviewcellId)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.subviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getNotofications()
        self.navProps()
    }
    
    private func navProps() {
        self.navigationController?.navigationBar.topItem?.title = "Notifications"
    }
    
    private func subviews() {
        self.view.addSubview(self.tableview)
        self.tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.tableview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc private func getNotofications() {
        
        self.dataHolder.removeAll(keepingCapacity: false)
        PFCloud.callFunction(inBackground: "getdata", withParameters: ["class":"pushNotifications"]) { (data, error) in
            if error == nil {
                guard let back = data as? [PFObject] else {return}
                self.dataHolder = back
               
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    self.refreshController.endRefreshing()
                }
            } else {
                print(error)
            }
        }
        /*
        PFCloud.callFunction(inBackground: "SendPush", withParameters: ["channel": "devChanel", "message": "hey guys check our app", "sender": PFUser.current()?.objectId!]) { (data, error) in
            if error == nil {
                guard let back = data else {return}
                print(back)
            } else {
                print(error)
            }
        }
        */
    }

}

extension notifications: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataHolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.tableviewcellId, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let forRow = self.dataHolder[indexPath.row]
        
        guard let text = forRow["text"] as? String else {return UITableViewCell()}
        cell.textback.text = text
        
        guard let user = forRow["sender"] as? PFObject else  {return UITableViewCell()}
        user.fetchInBackground { (data, error) in
            if error == nil {
                guard let result = data else {return}
                guard let username = result["username"] as? String else {return}
                cell.usernameBtn.setTitle("\(username.getTextFromEmail())", for: .normal)
                
                guard let picFile = result["profilePicture"] as? PFFile else {return}
                guard let picUrl = picFile.url else {return}
                guard let url = URL(string: picUrl) else {return}
                cell.profilePicture.sd_setImage(with: url, completed: nil)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
