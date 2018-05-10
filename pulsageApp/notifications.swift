import UIKit
import Parse

class notifications: PulsageViewController {
    
    let tableviewcellId = "cellid"
    var dataHolder = [PFObject]()
    
    fileprivate lazy var refreshController: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Updating Data")
        refresh.addTarget(self, action: #selector(self.getGlobalNotifications), for: .valueChanged)
        return refresh
    }()
    
    private lazy var globalNotifications: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("General", for: .normal)
        button.addTarget(self, action: #selector(self.getGlobalNotifications), for: .touchUpInside)
        return button
    }()
    
    private lazy var myNotifications: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("Personal", for: .normal)
        button.addTarget(self, action: #selector(self.getMyNotofications), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackview: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var tableview: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
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
        self.getGlobalNotifications()
    }
    
    private func navProps() {
        
    }
    
    private func subviews() {
        self.view.addSubview(self.stackview)
        self.stackview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        self.stackview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 5).isActive = true
        self.stackview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -5).isActive = true
        self.stackview.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.stackview.addArrangedSubview(self.globalNotifications)
        self.stackview.addArrangedSubview(self.myNotifications)
        
        self.view.addSubview(self.tableview)
        self.tableview.topAnchor.constraint(equalTo: self.stackview.bottomAnchor, constant: 5).isActive = true
        self.tableview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.tableview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func getGlobalNotifications() {
        self.navigationController?.navigationBar.topItem?.title = "Notifications"
        self.getNotofications(equal: "channel", to: "global")
        
    }
    
    @objc private func getMyNotofications() {
        self.navigationController?.navigationBar.topItem?.title = "My Notifications"
        guard let currentUserId = PFUser.current()?.objectId else {return}
        self.getNotofications(equal: "channel", to: currentUserId)
    }
    
    @objc private func getNotofications(equal: String, to: String) {
        self.navigationController?.navigationBar.topItem?.title = "Notifications"
        PFCloud.callFunction(inBackground: "notifications", withParameters: ["class":"pushNotifications", "equal": equal, "to": to]) { (data, error) in
            if error == nil {
               
                self.dataHolder.removeAll(keepingCapacity: false)
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                guard let back = data as? [PFObject] else {
                    self.dataHolder = [PFObject()]
                    return
                }
                self.dataHolder = back
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    self.refreshController.endRefreshing()
                }
            
            } else {
                self.simpleAlert(Message: "We are having problems getting data. Please check your internet connection", title: "Error")
            }
 
        }
    }
}

extension notifications: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
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
                    cell.usernameBtn.setTitle("\(result.handle)", for: .normal)
                    
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}
