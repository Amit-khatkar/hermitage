//
//  CartVC.swift
//  Hermitage
//
//  Created by Amit on 14/05/19.
//  Copyright © 2019 iamitkhatkar. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

public struct cartModel: Codable {
    var name:String
    var qty: Int
//    var price: String
   
}

class CartVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
     private let cellReuseIdentifier = "cart"
    var db = Firestore.firestore()
    var cartData: [cartModel] = []
    let checkOutView = UIView()
    let addressBar = UITextField()
    let checkoutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cart"
        
        view.backgroundColor = .white
        
        view.addSubview(checkOutView)
        
        checkOutView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        checkOutView.translatesAutoresizingMaskIntoConstraints = false
        checkOutView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive  = true
        checkOutView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        checkOutView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.register(CartItemCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -206).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        setupViews()
        setupCheckoutButton()
        
        fetchData()
    }
    
    func setupViews(){
        addressBar.backgroundColor = .white
        addressBar.layer.borderWidth = 0.5
        addressBar.layer.borderColor = UIColor.gray.cgColor
        addressBar.contentVerticalAlignment = .top;
        addressBar.font = addressBar.font?.withSize(14)
        addressBar.placeholder = "Enter Your Address"
        addressBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: addressBar.frame.height))
        addressBar.leftViewMode = .always
        addressBar.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: addressBar.frame.height))
        addressBar.rightViewMode = .always
        addressBar.layer.cornerRadius = 6
        checkOutView.addSubview(addressBar)
        
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        addressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        addressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        addressBar.bottomAnchor.constraint(equalTo: checkOutView.bottomAnchor, constant: -100).isActive = true
        addressBar.topAnchor.constraint(equalTo: checkOutView.topAnchor, constant: 16).isActive = true
    }
    
    func setupCheckoutButton(){
        checkoutButton.setTitle("Check Out", for: .normal)
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.backgroundColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        checkOutView.addSubview(checkoutButton)
        checkoutButton.addTarget(self, action: #selector(placeOrder), for: .touchUpInside)
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        checkoutButton.topAnchor.constraint(equalTo: addressBar.bottomAnchor, constant: 16).isActive = true
        checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        checkoutButton.layer.cornerRadius = 25
    }
    
    
    func fetchData() {
        
//        var array: [cartModel] = []
        if let cartData = UserDefaults.standard.object(forKey: "cart") as? Data {
            if let cart = try? JSONDecoder().decode([cartModel].self, from: cartData) {
                self.cartData = cart
            }
        }
        
//        let uid = Auth.auth().currentUser?.uid
//        db.collection("users").document("23872").collection("cart").getDocuments { (querySnapshot, error) in
//
//            if(error == nil){
//                self.cartData = []
//                querySnapshot?.documents.forEach({ (doc) in
//                    do{
//                        let jsonData = try JSONSerialization.data(withJSONObject: doc.data(),
//                                                                  options: JSONSerialization.WritingOptions.prettyPrinted)
//                         let json = try JSONDecoder().decode(cartModel.self, from: jsonData)
//                        print(json)
//                         self.cartData.append(json)
//                    } catch {
//                        print(error)
//                    }
//                })
//            }
//
//            DispatchQueue.main.async {
//                print(self.cartData)
//                 self.collectionView.reloadData()
//            }
//        }
        
    }
    
    @objc func removeItem(title: String){

        db.collection("users").document("23872").collection("cart").document(title).delete { (err) in
            if err != nil{
                print(err!)
            }else{
                print("Deleted")
                 self.fetchData()
            }
        }
    }
    
    @objc func placeOrder(){
        let jsonData = try! JSONEncoder().encode(cartData)
    
            let jsonArray = try! JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as! [Dictionary<String,Any>]

        let docData: [String: Any] = [
            "uid" : "23872",
            "price" : 1232,
            "items" : jsonArray
        ]
        db.collection("orders").addDocument(data: docData) { (err) in
            if err == nil {
                self.db.collection("users").document("23872").collection("cart").getDocuments(completion: { (snapshot, error) in
                    if error == nil {
                        for doc in (snapshot?.documents)!{
                            doc.reference.delete()
                            self.navigationController?.popViewController(animated: true)
                            self.showAlert(message: "Order Placed")
                        }
                    }
                })
              
            }else{
                print(err ?? "no error found")
            }
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "oops", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func onPlusButton(sender: UIButton){
          let title = sender.title(for: .disabled)!
        let currentQty = Int(sender.title(for: .focused)!)
        let docData: [String: Any] = [
            "name" : title,
            "qty" : currentQty! + 1
        ]
        db.collection("users").document("23872").collection("cart").document(title).setData(docData, merge: true)
        DispatchQueue.main.async {
            self.fetchData()
        }
    }
    
    @objc func onSubButton(sender: UIButton){
        let title = sender.title(for: .disabled)!
        let currentQty = Int(sender.title(for: .focused)!)
        let docData: [String: Any] = [
            "name" : title ,
            "qty" : currentQty! - 1
        ]
        db.collection("users").document("23872").collection("cart").document(title).setData(docData, merge: true)
        DispatchQueue.main.async {
            self.fetchData()
            if(currentQty == 1){
                self.removeItem(title: title)
            }
        }
    }
    
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartData.count
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CartItemCell
        let name =  cartData[indexPath.row].name
        cell.title.text = name
        cell.count.text = "\(String(describing: cartData[indexPath.row].qty))"
        cell.addButton.setTitle(name, for: .disabled)
        cell.addButton.setTitle(String(describing: cartData[indexPath.row].qty), for: .focused)
        cell.subButton.setTitle(name, for: .disabled)
        cell.subButton.setTitle(String(describing: cartData[indexPath.row].qty), for: .focused)
        cell.addButton.addTarget(self, action: #selector(onPlusButton(sender:)), for: .touchUpInside)
        cell.subButton.addTarget(self, action: #selector(onSubButton(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    

}
