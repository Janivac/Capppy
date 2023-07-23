//
//  ViewController+UI.swift
//  Capppy
//
//  Created by Jana Vac on 09.10.2022.
//

import UIKit

extension ViewController {
    
    func setupHeaderTitle(){
        let title = "Vítej u Capppy!"
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Futura", size: 28)!,
                                                                                   NSAttributedString.Key.foregroundColor : UIColor.black
                                                                                  ])

        
        let paragrapStyle = NSMutableParagraphStyle()
        paragrapStyle.lineSpacing = 5
        
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragrapStyle, range: NSMakeRange(0, attributedText.length))
        
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedText
    }
    

    func setupCreateAccountButton() {
        
        createAccountButton.setTitle("Registrovat se", for: UIControl.State.normal)
        createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.clipsToBounds = true
    
    }
    
    func setupTermsLabel () {
        
         let attributedTermsText = NSMutableAttributedString(string: "Kliknutím na “vytvořit nový účet“ souhlasíte s našimi ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                                                                                                                                          NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)
                                                                                   ])
         let attributedSubTermsText = NSMutableAttributedString(string: "obchodními podmínkami.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                                                                                           NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)
                                                                                   ])
     attributedTermsText.append(attributedSubTermsText)
     termsOfServiceLabel.attributedText = attributedTermsText
     termsOfServiceLabel.numberOfLines = 0
        
    }
    
    
}
