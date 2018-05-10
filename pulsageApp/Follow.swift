import UIKit
import Parse

class Follow: UIViewController {
    
    public var type = ""
    public var dataHolder = [PFObject]()
    public var userObject: PFObject!
    
    private let tableviewcellId = "cellid"
    
    fileprivate lazy var refreshController: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Updating Data")
        refresh.addTarget(self, action: #selector(self.getdata), for: .valueChanged)
        return refresh
    }()
    
    
    private lazy var tableview: UITableView = {
        let table = UITableView()
        table.addSubview(self.refreshController)
        table.delegate = self
        table.dataSource = self
        table.register(UserCell.self, forCellReuseIdentifier: self.tableviewcellId)
        table.allowsSelection = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableview)
        
        self.tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive       = true
        self.tableview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive     = true
        self.tableview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive   = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getdata()
    }
    
    @objc private func getdata() {
        self.dataHolder.removeAll()
        self.tableview.reloadData()
        if self.type == "followers" {
            let query = PFQuery(className: "Follow")
            query.whereKey("Following", equalTo: self.userObject)
            query.findObjectsInBackground { (result, error) in
                if error == nil {
                    guard let follers = result else {return}
                    
                    let back = follers.map({ (object) -> PFObject in
                        guard let data = object["Followers"] as? PFObject else {return PFObject()}
                        return data
                    })
                    self.dataHolder = back
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                        self.refreshController.endRefreshing()
                    }
                }
            }
        } else if self.type == "following" {
            let query = PFQuery(className: "Follow")
            query.whereKey("Followers", equalTo: self.userObject)
            query.findObjectsInBackground { (result, error) in
                if error == nil {
                    guard let follers = result else {return}
                    let back = follers.map({ (object) -> PFObject in
                        guard let data = object["Following"] as? PFObject else {return PFObject()}
                        return data
                    })
                    self.dataHolder = back
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                        self.refreshController.endRefreshing()
                    }
                }
            }
        }
    }
    
}

extension Follow: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataHolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.tableviewcellId, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let forRow = self.dataHolder[indexPath.row]
        forRow.fetchInBackground { (results, error) in
            if error == nil {
                guard let result = results else {return}
                guard let username = result["username"] as? String else {return}
                cell.usernameBtn.setTitle("\(username.getTextFromEmail())", for: .normal)
                
                guard let picFile = result["profilePicture"] as? PFFile else {return}
                guard let picUrl = picFile.url else {return}
                guard let url = URL(string: picUrl) else {return}
                cell.profilePicture.sd_setImage(with: url, completed: nil)
                cell.textback.isHidden = true
            }
        }
                return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let profileTab = ProfileTab()
        profileTab.userObject = self.dataHolder[indexPath.row]
        self.navigationController?.pushViewController(profileTab, animated: true)
    }
    
}
