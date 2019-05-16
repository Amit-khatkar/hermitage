//
//  CartMethods.swift
//  Hermitage
//
//  Created by Amit on 16/05/19.
//  Copyright © 2019 iamitkhatkar. All rights reserved.
//

import Foundation

class CartMethods {
    
    func saveCart(arr: [cartModel]){
        let jsonData = try! JSONEncoder().encode(arr)
        let defaults = UserDefaults.standard
        defaults.set(jsonData, forKey: "cart")
        fetchCart()
    }
    
    func fetchCart() -> [cartModel]{
        var cartarray: [cartModel] = []
        if let cartData = UserDefaults.standard.object(forKey: "cart") as? Data {
            if let cart = try? JSONDecoder().decode([cartModel].self, from: cartData) {
                cartarray = cart
            }
        }
        return cartarray
    }
    
    func checkifExist(arr: [cartModel], title: String) -> Bool{
        var isExist = false
        arr.forEach { (item) in
            if item.name == title {
                 let qty = item.qty
                if(qty > 0){
                    isExist = true
                }
            }
        }     
            return isExist
    }
    
    func getItem(arr: [cartModel], title: String) -> cartModel {
        var cartitem: cartModel?
        arr.forEach { (item) in
            if item.name == title {
                cartitem = item
            }
        }
        return cartitem!
    }
    
    func removeIfEmpty(arr: [cartModel], title: String){
        var cartarray = arr
        cartarray.forEach { (item) in
            if item.name == title {
                let qty = item.qty
                if(qty > 0){
                    if let ind =  cartarray.firstIndex(where: {$0.name == item.name}) {
                        cartarray.remove(at: ind)
                        saveCart(arr: cartarray)
                    }
                }
            }
        }
    }
    
    func removeOneQty(arr: [cartModel], title: String){
        var cartarray = arr
        var cartitem: cartModel?
        cartarray.forEach { (item) in
            if item.name == title {
                cartitem = item
                cartitem?.qty = item.qty - 1
                if let ind =  cartarray.firstIndex(where: {$0.name == item.name}) {
                    if(cartitem!.qty <= 0){
                          cartarray.remove(at: ind)
                    }else{
                        cartarray[ind] = cartitem!
                    }
                    saveCart(arr: cartarray)
                }
            }
        }
    }
    
    func addOneItem(arr: [cartModel], title: String)  {
        var cartarray = arr
        var cartitem: cartModel?
        cartarray.forEach { (item) in
            if item.name == title {
                cartitem = item
                cartitem?.qty = item.qty + 1
                if let ind =  cartarray.firstIndex(where: {$0.name == item.name}) {
                    cartarray[ind] = cartitem!
                    saveCart(arr: cartarray)
                }
            }
        }
    }
}


