//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/19/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit
import Hero

class FeedViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var selectedCell: Int?
    
    var firstPost = [Post]()
    var restofPosts = [Post]()
    var posts = [Post]()
    var currentUser: UserModel?
    
    override func viewDidLoad() {
        getCurrentUser()
        self.hero.isEnabled  = true
        getPosts()
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setUpNavBar()
        self.setUpCollectionView()
    }
    
    func getCurrentUser() {
        UserAuthHelper.getCurrentUser { (user) in
            FirebaseAPIClient.fetchUser(id: user.uid, withBlock: { (dict) in
                let name = dict["name"] as! String
                let email = dict["email"] as! String
                let username = dict["username"] as! String
                self.currentUser = UserModel(name: name, username: username, email: email, id: user.uid)
            })
        }
    }
    
    func getPosts() {
        
        FirebaseAPIClient.fetchPosts { (post) in
            if self.firstPost.count == 0 {
                self.firstPost.append(post)
            } else {
                let temp = self.firstPost[0]
                self.firstPost[0] = post
                self.restofPosts.append(temp)
                self.restofPosts.sort(by: { (x, y) -> Bool in
                    return x.date! < y.date!
                })
                self.posts = self.firstPost + self.restofPosts
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setUpNavBar() {
        let barColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 19)!, NSAttributedStringKey.foregroundColor : UIColor.white]
        
        let image = UIImage(named: "logout")
        let logoutButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(logout))
        
        let plusImage = UIImage(named: "plus")
        let plusButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(newPost))
        
        self.navigationItem.title = "Feed"
        self.navigationItem.leftBarButtonItem = logoutButton
        self.navigationItem.rightBarButtonItem = plusButton
        
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (self.navigationController?.navigationBar.frame.height)!), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FeedViewCell.self, forCellWithReuseIdentifier: "feedCell")
        view.addSubview(collectionView)
    }
    
    @objc func logout() {
        UserAuthHelper.logOut {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func newPost() {
        performSegue(withIdentifier: "newsocial", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let destVC = segue.destination as! DetailViewController
            let imgHero = "image" + "\(selectedCell!)"
            let eventHero = "event" + "\(selectedCell!)"
            let nameHero = "name" + "\(selectedCell!)"
            let RSVPHero = "RSVP" + "\(selectedCell!)"
            let dateHero = "date" + "\(selectedCell!)"
            let starHero = "star" + "\(selectedCell!)"
            destVC.post = posts[selectedCell!]
            destVC.currentUser = self.currentUser
            destVC.setUpView()
            destVC.image.hero.id = imgHero
            destVC.eventLabel.hero.id = eventHero
            destVC.nameLabel.hero.id = nameHero
            destVC.dateLabel.hero.id = dateHero
            destVC.RSVP.hero.id = RSVPHero
            destVC.starImage.hero.id = starHero
        } else {
            let destVC = segue.destination as! NewSocialViewController
            destVC.currentUser = self.currentUser
        }
        
    }
    
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedViewCell
        for var x: UIView in cell.contentView.subviews {
            x.removeFromSuperview()
        }
        cell.awakeFromNib()
        let post = posts[indexPath.item]
        StorageHelper.getProfilePic(id: post.id!, withBlock: { (image) in
            post.image = image
            cell.image.image = self.posts[indexPath.item].image!
        })
        FirebaseAPIClient.fetchInterested(postID: post.id!) { (userID) in
            if userID == self.currentUser?.id {
                post.userInterested = true
                let image = UIImage(named: "star2")
                cell.starImageView.image = image
            }
        }
        FirebaseAPIClient.fetchRSVP(postID: post.id!) { (rsvpNum) in
            cell.RSVP.text = "\(rsvpNum)"
            post.RSVP = rsvpNum
        }
        cell.nameLabel.text = post.personName
        cell.eventLabel.text = post.eventName
        cell.RSVP.text = "\(post.RSVP!)"
        cell.date.text = post.date
        
        if post.userInterested! {
            let image = UIImage(named: "star2")
            cell.starImageView.image = image
        }
        
        cell.image.hero.id = "image" + "\(indexPath.item)"
        cell.nameLabel.hero.id = "name" + "\(indexPath.item)"
        cell.eventLabel.hero.id = "event" + "\(indexPath.item)"
        cell.date.hero.id = "date" + "\(indexPath.item)"
        cell.RSVP.hero.id = "RSVP" + "\(indexPath.item)"
        cell.starImageView.hero.id = "star" + "\(indexPath.item)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width - 20, height: 150)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath.item
        self.performSegue(withIdentifier: "toDetail", sender: self)
    }
    
}
    

