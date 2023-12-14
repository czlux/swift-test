//
//  ViewController.swift
//  SwiftTest
//
//  Created by llf on 2023/12/14.
//

import UIKit

import Toast_Swift
enum BusinessType {
    case LOGIN
    case REGISTER
}


let KEY_CURRENT_NAME = "key_current_name"

let KEY_CURRENT_PASSWORD = "key_current_password"

class LoginController: UIViewController {

    @IBOutlet weak var account_textfield: UITextField!
    
    @IBOutlet weak var password_textfiled: UITextField!
    
    @IBOutlet weak var register_button: UIButton!
    
    @IBOutlet weak var login_button: UIButton!
    
    @IBOutlet weak var error_label: UILabel!
    
    @IBOutlet weak var hide_pass_button: UIButton!
    let store = AccountStore()
    
    var type: BusinessType = .LOGIN
    
    var hidePassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.error_label.isHidden = true
        
        switch self.type {
        case .REGISTER:
            self.login_button.setTitle("注册", for: .normal)
            self.navigationItem.title = "注册"
            self.register_button.isHidden = true
        default:
            
            //密码记录
            let currentName = UserDefaults.standard.string(forKey: KEY_CURRENT_NAME)
            let currentPassword = UserDefaults.standard.string(forKey: KEY_CURRENT_PASSWORD)
            if let userStr = currentName, let passwordStr = currentPassword{
                self.account_textfield.text = userStr
                self.password_textfiled.text = passwordStr
                
            }
            
            
            self.login_button.setTitle("登录", for: .normal)
        }
      
        
        // Do any additional setup after loading the view.
    }

    @IBAction func toLogin(_ sender: UIButton) {
       
        let accountStr = self.account_textfield.text?.replacingOccurrences(of: " ", with: "")
        let pwdStr = self.password_textfiled.text?.replacingOccurrences(of: " ", with: "")
        
        if(accountStr == ""){
           
            self.errorlabel_show(message: "请输入用户名", hide: false)
            return
        }
        if(pwdStr == ""){
            self.errorlabel_show(message: "请输入密码", hide: false)
            return
        }
        self.error_label.isHidden = true
      
        let user = User(name: accountStr, password: pwdStr)
        
        
        switch self.type {
        case .REGISTER:
            if (self.store.isUserExist(user: user)){
                self.errorlabel_show(message: "当前用户已存在", hide: false)
            }else{
                if self.store.registerUser(user: user) != nil{
                  
                    self.view.makeToast("注册成功",duration: 1.0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        self.navigationController?.popViewController(animated: true)
                    }
                   
                }
            }
            
        default:
            if (self.store.isUserExist(user: user)){
               
                if(self.store.checkNameAndPassword(user: user)){
                    self.view.makeToast("登录成功",duration: 1.0)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        UserDefaults.standard.set(user.name, forKey: KEY_CURRENT_NAME)
                        UserDefaults.standard.set(user.password, forKey: KEY_CURRENT_PASSWORD)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }else{
                    self.errorlabel_show(message: "密码不正确", hide: false)
                }
            }else{
                self.errorlabel_show(message: "当前用户不存在", hide: false)
            }
        }
        
       
        
    }
    
    func errorlabel_show(message: String, hide: Bool){
        self.error_label.text = message
        self.error_label.isHidden = hide
    }
   
    
    @IBAction func inputChange(_ sender: UITextField) {
        
        self.error_label.isHidden = true
    }
   
    @IBAction func toRegister(_ sender: UIButton) {
        self.error_label.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginController
        vc.type = .REGISTER
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func hidePassword(_ sender: UIButton) {
        
        self.hidePassword = !self.hidePassword
        if(self.hidePassword){
            self.hide_pass_button.setImage(UIImage(named: "open"), for: .normal)
            self.password_textfiled.isSecureTextEntry = true
        }else{
            self.hide_pass_button.setImage(UIImage(named: "close"), for: .normal)
            self.password_textfiled.isSecureTextEntry = false
        }
        
    }
    
}

