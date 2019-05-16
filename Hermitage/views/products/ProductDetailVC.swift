
//
//  ProductDetailVC.swift
//  Hermitage
//
//  Created by Amit on 13/05/19.
//  Copyright © 2019 iamitkhatkar. All rights reserved.
//

import UIKit
import LBTATools
import FirebaseAuth
import FirebaseFirestore
import SwiftIconFont

class ProductDetailVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
   
    let Store = CartMethods()
    
    let db = Firestore.firestore()
    var productImage = UIImageView()
    var price = UILabel()
    var productTitle = UILabel()
    let cartButton = UIButton()
    let addButton = UIButton()
    let subButton = UIButton()
    let count = UILabel()
    let descLabel = UILabel()
    var productDescription = UILabel()
    let specsLabel = UILabel()
    var specifications = UILabel()
    let countView = UIView()
    let scrollView = UIScrollView()
    var collectionView:UICollectionView!
    
    var imageNames = [#imageLiteral(resourceName: "loginback"),#imageLiteral(resourceName: "intro"),#imageLiteral(resourceName: "firstproduct"),#imageLiteral(resourceName: "secondproduct")]
    var currentImage = 0
    var currentSize = 0
    var sizes: [Any] = []
    var prices: [Any] = []
    
    var currentQty = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Product Detail"
        let cartIcon =  UIImage(from: .iconic, code: "cart", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: cartIcon, style: .plain, target: self, action: #selector(goToCart))
        setViewContent()
        addViews()
        setupViews()
        fetchCart()
//        UserDefaults.standard.removeObject(forKey: "cart")
        
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(ProductSizeCell.self, forCellWithReuseIdentifier: "cellIdentifier")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! ProductSizeCell
        cell.title.text = sizes[indexPath.row] as? String
        if indexPath.row == currentSize {
            cell.wrapper.backgroundColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
            cell.title.textColor = .white
            cell.wrapper.layer.borderColor = UIColor.clear.cgColor
        }else{
            cell.wrapper.backgroundColor = .white
            cell.title.textColor = .black
            cell.wrapper.layer.borderColor = UIColor.gray.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSize = indexPath.row
         price.text = "Price: $\(prices[currentSize])"
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = sizes[indexPath.row] as? String
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: 40)
    }
    
    @objc func goToCart(){
        let Cart = CartVC(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationController?.pushViewController(Cart, animated: true)
    }
    
    
    @objc func onAddtoCart(){
        var array = Store.fetchCart()
        let item = cartModel.init(name: self.productTitle.text!, qty: 1)
        array.append(item)
        saveCart(arr: array)
        fetchCart()
//        let uid = Auth.auth().currentUser?.uid;
//        let docData: [String: Any] = [
//            "name" : self.productTitle.text ?? "",
//            "qty" : 1
//        ]
//        db.collection("users").document("23872").collection("cart").document(self.productTitle.text!).setData(docData, merge: true)
//         DispatchQueue.main.async {
//            self.fetchCart()
//            self.hideCart()
//        }
    }
    
    func saveCart(arr: [cartModel]){
       Store.saveCart(arr: arr)
    }
    
    func fetchCart(){
        let arr = Store.fetchCart()
        let title = self.productTitle.text!
        if(Store.checkifExist(arr: arr, title: title)){
            self.hideCart()
            let item = Store.getItem(arr: arr, title: title)
            self.count.text = String(describing: item.qty)
        }else{
            Store.removeIfEmpty(arr: arr, title: title)
            self.showCart()
        }
//        var cartarray: [cartModel] = []
//        if let cartData = UserDefaults.standard.object(forKey: "cart") as? Data {
//            if let cart = try? JSONDecoder().decode([cartModel].self, from: cartData) {
//               cartarray = cart
//                cartarray.forEach { (item) in
//                    if item.name == self.productTitle.text! {
//                        let qty = item.qty
//                        if(qty > 0){
//                            self.hideCart()
//                            self.count.text = String(describing: qty)
//                        }else{
//                            if let ind =  cartarray.firstIndex(where: {$0.name == item.name}) {
//                                cartarray.remove(at: ind)
//                                saveCart(arr: cartarray)
//                            }
//                            self.showCart()
//                        }
//                    }
//                }
//            }
//        }
//        //        let uid = Auth.auth().currentUser?.uid
//        //        let dbpath =   db.collection("users").document("23872").collection("cart").document(self.productTitle.text!)
//        //      dbpath.getDocument { (document, error) in
//        //                if let document = document, document.exists {
//        //                   let qty = document.data()?["qty"] as! Int
//        //                    self.currentQty = qty
//        //                    if(qty > 0){
//        //                        self.hideCart()
//        //                        self.count.text = String(describing: qty)
//        //                    }else{
//        //                        dbpath.delete()
//        //                        self.showCart()
//        //                    }
//        //            }
//        //        }
//        return cartarray
    }
    
    @objc func onPlusButton(){
        let arr = Store.fetchCart()
        let title = self.productTitle.text!
        Store.addOneItem(arr: arr, title: title)
        fetchCart()
    }
    
    @objc func onSubButton(){
         let arr = Store.fetchCart()
        let title = self.productTitle.text!
        Store.removeOneQty(arr: arr, title: title)
        fetchCart()
    }
    
    func hideCart(){
    self.cartButton.isHidden = true
    self.countView.isHidden = false
    }
    
    func showCart(){
        self.cartButton.isHidden = false
        self.countView.isHidden = true
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var contentRect = CGRect.zero
        for view: UIView in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        contentRect.size.height = contentRect.size.height + 20
        scrollView.contentSize = contentRect.size
    }
    
    
    func addViews(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        
        scrollView.isScrollEnabled = true
        scrollView.addSubview(productImage)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(price)
        scrollView.addSubview(productTitle)
        scrollView.addSubview(cartButton)
        
        
        countView.addSubview(subButton)
        countView.addSubview(count)
        countView.addSubview(addButton)
        
        cartButton.addTarget(self, action: #selector(onAddtoCart), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(onPlusButton), for: .touchUpInside)
        subButton.addTarget(self, action: #selector(onSubButton), for: .touchUpInside)
        
        scrollView.addSubview(countView)
        descLabel.text = "Description"
        scrollView.addSubview(descLabel)
        scrollView.addSubview(productDescription)
        specsLabel.text = "Specifications"
        scrollView.addSubview(specsLabel)
        scrollView.addSubview(specifications)
        view.addSubview(scrollView)
    }
    
    func setViewContent(){
        price.font = price.font.withSize(16)
        price.textColor = UIColor(red:0.21, green:0.77, blue:0.00, alpha:1.0)
        price.text = "Price: $\(prices[currentSize])"
        productTitle.numberOfLines = 0
        
        
        cartButton.backgroundColor = UIColor(red:0.21, green:0.77, blue:0.00, alpha:1.0)
        cartButton.layer.cornerRadius = 20
        cartButton.setTitle("Add to cart", for: .normal)
        cartButton.setTitleColor(.white, for: .normal)
        countView.isHidden = true
        
        addButton.backgroundColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
        addButton.layer.cornerRadius = 40 / 2
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        
        count.text = "0"
        
        subButton.backgroundColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        subButton.layer.cornerRadius = 40 / 2
        subButton.setTitle("-", for: .normal)
        subButton.setTitleColor(.white, for: .normal)
        
        descLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descLabel.textColor = .gray
        productDescription.numberOfLines = 0
        
        specsLabel.font = UIFont.boldSystemFont(ofSize: 17)
        specsLabel.textColor = .gray
        specifications.numberOfLines = 0
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.productImage.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.productImage.addGestureRecognizer(swipeLeft)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if currentImage == imageNames.count - 1 {
                    currentImage = 0
                    
                }else{
                    currentImage += 1
                }
                productImage.image = imageNames[currentImage]
                
            case UISwipeGestureRecognizer.Direction.right:
                if currentImage == 0 {
                    currentImage = imageNames.count - 1
                }else{
                    currentImage -= 1
                }
                productImage.image = imageNames[currentImage]
            default:
                break
            }
        }
    }
    
    func setupViews(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        productImage.translatesAutoresizingMaskIntoConstraints = false
        
        productImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        productImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        productImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        productTitle.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true
        productTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        productTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -136).isActive = true
        
        price.translatesAutoresizingMaskIntoConstraints = false
        price.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 16).isActive = true
        price.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true
        cartButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        cartButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        // count view start
        
        countView.translatesAutoresizingMaskIntoConstraints = false
    
        countView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true
        countView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        countView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        countView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        subButton.translatesAutoresizingMaskIntoConstraints = false
        subButton.leadingAnchor.constraint(equalTo: countView.leadingAnchor).isActive = true
        subButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        subButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        subButton.centerYAnchor.constraint(equalTo: count.centerYAnchor).isActive = true
        
        
        count.translatesAutoresizingMaskIntoConstraints = false
        count.centerXAnchor.constraint(equalTo: countView.centerXAnchor).isActive = true
        count.centerYAnchor.constraint(equalTo: countView.centerYAnchor).isActive = true
        
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.trailingAnchor.constraint(equalTo: countView.trailingAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.centerYAnchor.constraint(equalTo: count.centerYAnchor).isActive = true
        
        
        //count view end
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 16).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        productDescription.translatesAutoresizingMaskIntoConstraints = false
        productDescription.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16).isActive = true
        productDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        productDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        specsLabel.translatesAutoresizingMaskIntoConstraints = false
        specsLabel.topAnchor.constraint(equalTo: productDescription.bottomAnchor, constant: 16).isActive = true
        specsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        specifications.translatesAutoresizingMaskIntoConstraints = false
        specifications.topAnchor.constraint(equalTo: specsLabel.bottomAnchor, constant: 16).isActive = true
        specifications.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        specifications.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
    

 

}
