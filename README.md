# TextViewEdit1
模仿短信的弹出文本框，输入文字，并发送

![image](https://github.com/Kimsswift/TextViewEdit1/blob/master/TextViewEdit/t1.gif)

类属性:

    //MARK: -
    var sendText: String = ""  //存储textView的文字
    
    var textView: UITextView!  //用来显示输入的文本内容
    var textView2: UITextView!  //贴在键盘正上方的文本框
    var view1: UIView!  //包容发送按钮和textView2的视图
    
    var isTap: Bool = false  //检测点击事件
    
    let screen = UIScreen.main.bounds  //获取屏幕大小
    
    var view1OriginY: CGFloat! //view1原始Y轴坐标
    var textViewHight: CGFloat! //textView高度
    
    
 注册监视器，以及配置手势事件
 
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



点击发送按钮时的调用方法:

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
    
    
 弹出/收回键盘时调用的方法:
    
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

