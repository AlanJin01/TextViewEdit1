//
//  ViewController.swift
//  TextViewEdit
//
//  Created by J K on 2019/2/27.
//  Copyright © 2019 KimsStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    //隐藏手机状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: -
    var sendText: String = ""  //存储textView的文字
    
    var textView: UITextView!  //用来显示输入的文本内容
    var textView2: UITextView!  //贴在键盘正上方的文本框
    var view1: UIView!  //包容发送按钮和textView2的视图
    
    var isTap: Bool = false  //检测点击事件
    
    let screen = UIScreen.main.bounds  //获取屏幕大小
    
    var view1OriginY: CGFloat! //view1原始Y轴坐标
    var textViewHight: CGFloat! //textView高度
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = #colorLiteral(red: 0.6670507018, green: 0.6126480565, blue: 1, alpha: 1)
        
        //配置一个视图，用来包容textView2
        view1 = UIView(frame: CGRect(x: 0, y: screen.height - 50, width: screen.width, height: 50))
        view1.backgroundColor = #colorLiteral(red: 1, green: 0.8165173668, blue: 0.909292958, alpha: 1)
        view1OriginY = view1.frame.origin.y  //存储原始y坐标
        self.view.addSubview(view1)
        
        //配置贴在键盘正上方的文本框
        textView2 = UITextView(frame: CGRect(x: 10, y: 10, width: 290, height: 30))
        textView2.layer.cornerRadius = 15
        textView2.backgroundColor = UIColor.white
        textView2.isEditable = false  //关闭可编辑模式
        textView2.autocorrectionType = .no
        textView2.keyboardType = .default
        textView2.keyboardAppearance = .default
        textView2.isSecureTextEntry = false
        textView2.font = UIFont(name: "GillSans-Bold", size: 17)
        textView2.delegate = self
        view1.addSubview(textView2)
        
        //配置发送按钮, 发送的内容是textView2中填写的内容, 发送到textView中
        let sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        sendButton.center = CGPoint(x: 350, y: 25)
        sendButton.backgroundColor = #colorLiteral(red: 0.5705511254, green: 1, blue: 0.5329697138, alpha: 1)
        sendButton.layer.cornerRadius = 15
        sendButton.setTitle("send", for: .normal)
        sendButton.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sendButton.addTarget(self, action: #selector(ViewController.theSendButton), for: .touchUpInside)
        view1.addSubview(sendButton)
        
        //配置大的文本编辑框
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height - view1.frame.height))
        textViewHight = textView.frame.height  //存储textView高度
        textView.backgroundColor = #colorLiteral(red: 0.6670507018, green: 0.6126480565, blue: 1, alpha: 1)
        textView.isEditable = false  //关闭可编辑模式
        textView.autocorrectionType = .no
        textView.keyboardType = .default
        textView.keyboardAppearance = .default
        textView.isSecureTextEntry = false
        textView.font = UIFont(name: "GillSans-Bold", size: 17)
        self.view.addSubview(textView)
        
        //键盘弹出监视
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //键盘收回监视
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //配置手势,用来检测textView手势事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGesture1(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        textView.addGestureRecognizer(tap)
        
        //配置手势,用来检测textView2手势事件
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGesture2(_:)))
        tap2.numberOfTapsRequired = 1
        tap2.numberOfTouchesRequired = 1
        textView2.addGestureRecognizer(tap2)
    }

    //MARK: -
    //点击textView时调用
    @objc func tapGesture1(_ tap: UITapGestureRecognizer) {
        //当点击textView区域时
        if tap.view == textView {
            if isTap == true && textView2.isFirstResponder {
                textView2.isEditable = false  //禁止可编辑模式
                textView2.resignFirstResponder()  //撤掉textView2第一响应者, 以便收回键盘
                isTap = false
            }
        }
    }

    //点击textView2时调用
    @objc func tapGesture2(_ tap: UITapGestureRecognizer) {
        //当点击文本输入框textView2时
        if tap.view == textView2 {
            if isTap == false {
                textView2.isEditable = true  //开启可编辑模式
                textView2.becomeFirstResponder()  //把textView2变为第一响应者模式，以便弹出键盘
                isTap = true
            }
        }
    }
    
    //MARK: -
    //点击发送按钮时调用
    @objc func theSendButton() {
        let whiteSpace = NSCharacterSet.whitespacesAndNewlines   //表示空格和换行\n
        var text = textView2.text!
        text = text.trimmingCharacters(in: whiteSpace)  //剪掉首尾部分的多余空格，包括换行
        text.append("\n")  //换行
        
        if text != "" {
            sendText.append(text)
            textView.text = sendText
            textView2.text = ""    //清空
            
        }else {  //如果输入的是纯空格，就把光标移到最开始的地方
            textView2.selectedRange = NSRange(location: 0, length: 0)   //选择从location这个点开始，到length这个长度的范围
        }
        
    }
    
    //MARK: -
    //键盘即将显现时调用
    @objc func keyboardShow(_ notification: Notification) {
        let userInf = notification.userInfo as! NSDictionary
        let frame = userInf.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as AnyObject  //获取键盘的Frame
        let keyboardHeight = frame.cgRectValue!.size.height   //获取弹出的键盘高度
        
        let keyboardDuration = userInf.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! TimeInterval  //获取键盘完成弹出时的所消耗时间
        
        //利用键盘的弹出时间，把textView高度减少到合适的高度; 把textView2抬高，模拟微信、QQ等聊天窗
        UIView.animate(withDuration: keyboardDuration, delay: 0, options: [.curveLinear], animations: {
            self.textView.frame.size.height = self.textViewHight - keyboardHeight  //调整textView高度
            
            self.view1.frame.origin.y = self.view1OriginY - keyboardHeight  //把textView2所在视图抬高
        }) { (complite: Bool) in
            
        }
    }
    
    //键盘即将隐藏时调用
    @objc func keyboardHide(_ notificatin: Notification) {
        let userInf = notificatin.userInfo as! NSDictionary
        
        let keyboardDuration = userInf.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! TimeInterval  //获取键盘完成收回时的所消耗时间
        
        //利用键盘收回的时间，把textView和textView2高度还原到原来的高度
        UIView.animate(withDuration: keyboardDuration, delay: 0, options: [.curveLinear], animations: {
            self.textView.frame.size.height = self.screen.height - 50  //还原textView高度
            
            self.view1.frame.origin.y = self.view1OriginY
        }, completion: nil)
    }
}

