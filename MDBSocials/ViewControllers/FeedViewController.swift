//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/19/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    var collectionView: UICollectionView!

    var posts = [Post]()
    
    override func viewDidLoad() {
        getPosts()
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setUpNavBar()
        self.setUpCollectionView()
    }
    
    func getPosts() {
        FirebaseAPIClient.fetchPosts { (post) in
            self.posts.append(post)
            //arrange based on the date
            self.posts.sort(by: { (x, y) -> Bool in
                return x.date! < y.date!
            })
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
        cell.nameLabel.text = post.personName
        cell.eventLabel.text = post.eventName
        cell.RSVP.text = "\(post.RSVP!)"
        cell.date.text = post.date
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width - 20, height: 150)
        return size
    }
    
}
