//
//  ScanQRVC.swift
//  Hermitage
//
//  Created by Amit on 11/05/19.
//  Copyright © 2019 iamitkhatkar. All rights reserved.
//

import UIKit
import SwiftIconFont

class ScanQRVC: UIViewController {
    
    let qrImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 200))
     let scanLabel = UILabel()
     let enterCodeLabel = UILabel()
     let codeInput = UITextField()
    let nextButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
      
        setQRLayout()
        setupInput()
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          self.tabBarController?.title = "Scan QR Code"
    }

    
   func setQRLayout(){
    qrImage.image = UIImage(imageLiteralResourceName: "qr")
    view.addSubview(qrImage)
    qrImage.translatesAutoresizingMaskIntoConstraints = false
    qrImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
    qrImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
   
    scanLabel.text = "Scan QR-Code"
    scanLabel.textColor = .blue
    view.addSubview(scanLabel)
    scanLabel.translatesAutoresizingMaskIntoConstraints = false
    scanLabel.topAnchor.constraint(equalTo: qrImage.topAnchor, constant: 176).isActive = true
    scanLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    }
    
    func setupInput(){
        codeInput.placeholder = "Enter Code"
        codeInput.textAlignment = .center
        codeInput.backgroundColor = .white
        codeInput.layer.borderColor = UIColor.black.cgColor
        codeInput.layer.borderWidth = 1
        
        view.addSubview(codeInput)
        codeInput.translatesAutoresizingMaskIntoConstraints = false
        codeInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        codeInput.topAnchor.constraint(equalTo: scanLabel.topAnchor, constant: 100).isActive = true
        codeInput.widthAnchor.constraint(equalToConstant: 150).isActive = true
        codeInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        codeInput.layer.cornerRadius = 25
        
        enterCodeLabel.text = "Enter Code"
        enterCodeLabel.textColor = .blue
        view.addSubview(enterCodeLabel)
        enterCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        enterCodeLabel.topAnchor.constraint(equalTo: codeInput.topAnchor, constant: 76).isActive = true
        enterCodeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
 
    }
    
    func setupButton(){
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .black
        nextButton.layer.cornerRadius = 25
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.topAnchor.constraint(equalTo: enterCodeLabel.topAnchor, constant: 70).isActive = true

        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
   

}
