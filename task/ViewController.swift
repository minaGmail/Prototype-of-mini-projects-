//
//  ViewController.swift
//  task
//
//  Created by Mina Gamil  on 12/24/19.
//  Copyright © 2019 Mina Gamil. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    var repoArray = [WelcomeElement]()
    var isLoading:Bool = false
    var currentPage = 1
    var lastPage = 1
    var selectedIndex:Int!
    
    private lazy var searchBar:UISearchBar = {
         let searchBar = UISearchBar()
          searchBar.translatesAutoresizingMaskIntoConstraints = false
          searchBar.barTintColor = .red
          searchBar.isTranslucent = true
          searchBar.barStyle = .default
          searchBar.placeholder = "Type here"
          return searchBar
      }()
      
      private lazy var repo:UITableView = {
         let tableView = UITableView()
          tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
      }()
    
    private lazy var dialog:UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purple
        view.isHidden = true
        return view
    }()
    
    private lazy var dialogText:UILabel = {
       let label = UILabel()
        label.text = "Do you want to go to repository or owner url"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        return label
    }()
    
    private lazy var repoOwnerButtton:UIButton = {
        let repoOwnerButton = UIButton()
        repoOwnerButton.translatesAutoresizingMaskIntoConstraints = false
        repoOwnerButton.setTitle("Repo Owner", for: .normal)
        repoOwnerButton.backgroundColor = .black
        repoOwnerButton.titleLabel?.textColor = .white
        repoOwnerButton.addTarget(self, action: #selector(repoOnwerPressed), for: .touchUpInside)
        return repoOwnerButton
    }()
    
    private lazy var repoButton:UIButton = {
          let repoButton = UIButton()
          repoButton.translatesAutoresizingMaskIntoConstraints = false
          repoButton.setTitle("Repo", for: .normal)
          repoButton.backgroundColor = .black
          repoButton.titleLabel?.textColor = .white
          repoButton.addTarget(self, action: #selector(repoPressed), for: .touchUpInside)
          return repoButton
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        networkRequest()
        tableViewSetup()
        constraintsSetup()
        refreshHadler()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dialog.layer.cornerRadius = dialog.frame.height*0.1
        dialog.clipsToBounds = true
        repoOwnerButtton.layer.cornerRadius = repoOwnerButtton.frame.height/2
        repoOwnerButtton.clipsToBounds = true
        repoButton.layer.cornerRadius = repoButton.frame.height/2
        repoButton.clipsToBounds = true
    }
    
    @objc func repoOnwerPressed(sender:UIButton){
        
        if let url = URL(string:  Api.ownerArray[selectedIndex].htmlURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @objc func repoPressed(sender:UIButton){
        if let url = URL(string:repoArray[selectedIndex].htmlURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func layoutUI(){
        view.addSubview(searchBar)
        view.addSubview(repo)
        view.addSubview(dialog)
        dialog.addSubview(dialogText)
        dialog.addSubview(repoOwnerButtton)
        dialog.addSubview(repoButton)
    }
    
    func constraintsSetup(){
        NSLayoutConstraint.activate([
               searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
               searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               searchBar.widthAnchor.constraint(equalTo: view.widthAnchor),
               searchBar.heightAnchor.constraint(equalToConstant: 50)
           ])
           
           NSLayoutConstraint.activate([
               repo.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
               repo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               repo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               repo.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                  ])
        
        NSLayoutConstraint.activate([
            dialog.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dialog.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dialog.widthAnchor.constraint(equalToConstant: 350),
            dialog.heightAnchor.constraint(equalToConstant: 200)
                       ])
        
        NSLayoutConstraint.activate([
            dialogText.topAnchor.constraint(equalTo: dialog.topAnchor),
            dialogText.widthAnchor.constraint(equalTo: dialog.widthAnchor, multiplier: 0.75),
            dialogText.centerXAnchor.constraint(equalTo: dialog.centerXAnchor),
            dialogText.heightAnchor.constraint(equalTo: dialog.heightAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            repoOwnerButtton.bottomAnchor.constraint(equalTo: dialog.bottomAnchor, constant: -20),
            repoOwnerButtton.trailingAnchor.constraint(equalTo: dialog.trailingAnchor, constant: -25),
            repoOwnerButtton.widthAnchor.constraint(equalToConstant: 100),
            repoOwnerButtton.heightAnchor.constraint(equalToConstant: 40)
        
        ])
        
        NSLayoutConstraint.activate([
                   repoButton.bottomAnchor.constraint(equalTo: dialog.bottomAnchor, constant: -20),
                   repoButton.leadingAnchor.constraint(equalTo: dialog.leadingAnchor, constant: 25),
                   repoButton.widthAnchor.constraint(equalToConstant: 100),
                   repoButton.heightAnchor.constraint(equalToConstant: 40)
               
               ])
    }
    
    func refreshHadler(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        repo.refreshControl = refresh
    }

    @objc func refreshPulled(){
        guard !isLoading else{return}
        isLoading = true
        repo.refreshControl?.endRefreshing()
       networkRequest()
        // clear cache
    }
    
    func tableViewSetup(){
        repo.delegate = self
        repo.dataSource = self
        repo.registerNib(cell: repoCell.self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != dialog {
                dialog.isHidden = true
            }
        }
    }
    
     func networkRequest(){
        Api.parsers(page: 1) { (error, task,lastPage) in
            self.isLoading = false
              if let task = task{
              self.repoArray = task
              self.repo.reloadData()
                self.currentPage = 1
                self.lastPage = lastPage
              }
          }
      }
    
    func loadMore(){
        guard !isLoading else{return}
        guard currentPage < lastPage else{return}
        Api.parsers(page:currentPage+1) { (error, task,lastPage:Int)  in
          self.isLoading = false
            if let task = task{
                self.repoArray.append(contentsOf: task)
                self.currentPage += 1
                self.lastPage = lastPage
            }
        }
        DispatchQueue.main.async {
             self.repo.reloadData()
        }
       
    }
      
    
}

extension ViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as! repoCell
        if repoArray[indexPath.item].fork == false{
            cell.containerView.backgroundColor = .green
            print("okey")
        }else{
             cell.containerView.backgroundColor = .white
            print("no")
        }
        cell.repoName.text = repoArray[indexPath.row].name
        cell.repoOwner.text = repoArray[indexPath.item].fullName
        cell.repoDescription.text = repoArray[indexPath.item].welcomeDescription
        let owner = Api.ownerArray[indexPath.item].avatarURL
        if let imageUrl = owner , let avatarImageUrl = URL(string: imageUrl){
        cell.avatarImage.kf.setImage(with: avatarImageUrl)
        }
        repoOwnerButtton.tag = indexPath.item
        repoButton.tag = indexPath.item
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell \(indexPath.item) selected")
        dialog.isHidden = false
        selectedIndex = indexPath.item
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let task = repoArray.count
        if indexPath.item == task - 1{
            print("func called")
            currentPage += 1
            loadMore()
        }
    }
}



