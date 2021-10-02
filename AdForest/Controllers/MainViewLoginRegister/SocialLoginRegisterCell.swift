//
//  SocialLoginRegisterCell.swift
//  AdForest
//
//  Created by Apple on 13/09/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class SocialLoginRegisterCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnLoginAsGuest: UIButton!
    @IBOutlet weak var lblLoginAsGuest: UILabel!
    @IBOutlet weak var viewLoginAsGuest: UIView!
    {
        didSet{
            viewLoginAsGuest.layer.borderWidth = 1
            viewLoginAsGuest.layer.borderColor = UIColor.black.cgColor
            viewLoginAsGuest.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnLoginByPhone: UIButton!
    @IBOutlet weak var lblLoginByPhone: UILabel!
    @IBOutlet weak var ViewLoginByPhone: UIView!
    {
        didSet{
            ViewLoginByPhone.layer.borderWidth = 1
            ViewLoginByPhone.layer.borderColor = UIColor.black.cgColor
            ViewLoginByPhone.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnLoginByApple: UIButton!
    @IBOutlet weak var lblLoginByApple: UILabel!
    @IBOutlet weak var ViewLoginByApple: UIView!
    {
        didSet{
            ViewLoginByApple.layer.borderWidth = 1
            ViewLoginByApple.layer.borderColor = UIColor.black.cgColor
            ViewLoginByApple.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnLoginByLinkedIn: UIButton!
    @IBOutlet weak var lblLoginByLinkedIn: UILabel!
    @IBOutlet weak var ViewLoginByLinkedIn: UIView!
    {
        didSet{
            ViewLoginByLinkedIn.layer.borderWidth = 1
            ViewLoginByLinkedIn.layer.borderColor = UIColor.black.cgColor
            ViewLoginByLinkedIn.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnLoginByGoogle: UIButton!
    @IBOutlet weak var lblLoginByGoogle: UILabel!
    @IBOutlet weak var ViewLoginByGoogle: UIView!
    {
        didSet{
            ViewLoginByGoogle.layer.borderWidth = 1
            ViewLoginByGoogle.layer.borderColor = UIColor.black.cgColor
            ViewLoginByGoogle.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var BtnLoginByFacebook: UIButton!
    @IBOutlet weak var lblLoginByFaceBook: UILabel!
    @IBOutlet weak var ViewLoginByFacebook: UIView!
    {
        didSet{
            ViewLoginByFacebook.layer.borderWidth = 1
            ViewLoginByFacebook.layer.borderColor = UIColor.black.cgColor
            ViewLoginByFacebook.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnLoginByEmail: UIButton!
    @IBOutlet weak var lblLoginByEmail: UILabel!
    @IBOutlet weak var viewLoginByEmail: UIView!
    {
        didSet{
            viewLoginByEmail.layer.borderWidth = 1
            viewLoginByEmail.layer.borderColor = UIColor.black.cgColor
            viewLoginByEmail.layer.cornerRadius = 5
        }
    }
    
    
    
    //MARK;-Properties
    var calledFrom  = ""
    var btnActionLoginByEmail: (()->())?
    var btnActionLoginByFacebook: (()->())?
    var btnActionLoginByGoogle: (()->())?
    var btnActionLoginByLInkedIn: (()->())?
    var btnActionLoginByApple: (()->())?
    var btnActionLoginByPhone: (()->())?
    var btnActionLoginByGuest: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func ActionBtnLoginByEmail(_ sender: Any) {
        if calledFrom == "Login"{
            self.btnActionLoginByEmail?()
        }
        else if calledFrom == "register"{
            self.btnActionLoginByEmail?()
        }
    }
    
    @IBAction func ActionBtnLoginByFacebook(_ sender: Any) {
        self.btnActionLoginByFacebook?()
        
    }
    
    @IBAction func ActionBtnLoginByGoogle(_ sender: Any) {
        self.btnActionLoginByGoogle?()
        
    }
    @IBAction func ActionBtnLoginByLinkedIn(_ sender: Any) {
        self.btnActionLoginByLInkedIn?()
        
    }
    @IBAction func ActionBtnLoginByPhone(_ sender: Any) {
        self.btnActionLoginByPhone?()
        
    }
    @IBAction func ActionBtnLoginByApple(_ sender: Any) {
        self.btnActionLoginByApple?()
        
    }
    
    @IBAction func ActionLoginByGuest(_ sender: Any) {
        self.btnActionLoginByGuest?()
    }
    
}
