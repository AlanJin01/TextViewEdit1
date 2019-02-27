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
