import UIKit
import Parse

class CreateBussinesProfile: UIViewController {
    
    fileprivate var dataHolder = [PFObject]()
    
    fileprivate lazy var table: UITableView = {
        let tb = UITableView()
        tb.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tb.delegate = self
        tb.dataSource = self
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.table)
        self.view.backgroundColor = .white
        if PFUser.current() == nil {
            let loginPresentation = UINavigationController(rootViewController: Presentation())
            self.present(loginPresentation, animated: true, completion: nil)
        } else {
            self.getData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        self.NavigationControllerProps()
        if PFUser.current() != nil {
            self.getData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    fileprivate func NavigationControllerProps() {
        let navigationCon = self.navigationController
        navigationCon?.navigationBar.topItem?.title =  "Profiles"
        
        let createBtn = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(self.CreateBussinessAccount))
        self.navigationItem.setRightBarButtonItems([createBtn], animated: true)
        
    }
    
    @objc fileprivate func CreateBussinessAccount(){
        
    }
    
    fileprivate func getData() {
        self.dataHolder.removeAll(keepingCapacity: false)
        
        guard let currentUser = PFUser.current()?.objectId else {return}
        let query = PFQuery(className: "SponsorAccounts")
        query.whereKey("admin", equalTo: currentUser)
        query.findObjectsInBackground { (result, error) in
            guard let companies = result else {return}
            for company in companies {
                print(company)
                self.dataHolder.append(company)
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
                
            }
        }
    }
}

extension CreateBussinesProfile: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataHolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        let companie = self.dataHolder[indexPath.row]
        guard let name = companie["companyName"] as? String else {return UITableViewCell()}
        cell.textLabel?.text = name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
}
