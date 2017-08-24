//
//  ViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/11.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVProgressHUD

class ViewController: UIViewController {

    var rows = [
        ("show", #selector(ViewController.showIndicator)),
        ("showWithLabel", #selector(ViewController.showWithLabel)),
        ("showProgress", #selector(ViewController.showProgress)),
        ("showProgressWithLabel", #selector(ViewController.showProgressWithLabel)),
        ("showError", #selector(ViewController.showError)),
        ("showSuccess", #selector(ViewController.showSuccess)),
        ("showWarning", #selector(ViewController.showWarning)),
        ("showCustomImage", #selector(ViewController.showCustomImage)),
        ("showCustomImageWithLabel", #selector(ViewController.showCustomImageWithLabel)),
        ("showCustomView", #selector(ViewController.showCustomView)),
        ("showLabel", #selector(ViewController.showLabel)),
        ("showLabelOnCenter", #selector(ViewController.showLabelOnCenter)),
        ("dismiss", #selector(ViewController.dismissHUD))]
    
    @IBOutlet weak var stateSizeTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    var progress: Float = 0.0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let progressView = ZVProgressView(frame: .init(x: 0, y: 0, width: 200, height: 200))
//        progressView.backgroundColor = .lightGray
//        self.view.addSubview(progressView)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.progressHUDTouchEvent(notification:)), name: .ZVProgressHUDDidReceiveTouchEvent, object: nil)
//
//        ZVProgressHUD.lineWidth = 1.5
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

// MARK: - ZVProgressHUD Notification

extension ViewController {
    
    func progressHUDTouchEvent(notification: Notification) {
        self.dismissHUD()
    }
}

// MARK: - ZVProgressHUD

extension ViewController {

    func showIndicator() {
        ZVProgressHUD.show()
    }
    
    func showWithLabel() {
        ZVProgressHUD.show(with: .state(title: "Loading...", state: .indicator))
    }
    
    func showError() {
        ZVProgressHUD.show(with: .state(title: "Error", state: .error))
    }
    
    func showSuccess() {
        ZVProgressHUD.show(with: .state(title: "Success", state: .success))
    }
    
    func showWarning() {
        ZVProgressHUD.show(with: .state(title: "Warning", state: .warning))
    }
    
    func showCustomImage() {
        let image = UIImage(named: "smile")
        ZVProgressHUD.show(image: image!)
    }
    
    func showCustomImageWithLabel() {
        let image = UIImage(named: "smile")
        ZVProgressHUD.show(with: .state(title: "Check Smail", state: .custom(image: image!)))
    }
    
    func showProgress() {
        self.progress = 0
        if  self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.progressTimerAction(_:)), userInfo: nil, repeats: true)
    }
    
    func showProgressWithLabel() {
        self.progress = 0
        if  self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.progressTimerAction(_:)), userInfo: ["title": "Progress"], repeats: true)
    }
    
    
    func showCustomView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        customView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 0, y: 30, width: 100, height: 40 ))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor(red: 215.0 / 255.0, green: 22.0 / 255.0, blue: 59.0 / 255.0, alpha: 1.0)
        label.text = "custom view"
        customView.addSubview(label)
        ZVProgressHUD.customInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        ZVProgressHUD.show(with: .custom(view: customView))
    }
    
    func showLabel() {
        ZVProgressHUD.show(label: "我是一个挺长挺长的土豆肉丝加餐吃掉饱了没有")
    }
    
    func showLabelOnCenter() {
        ZVProgressHUD.show(label: "I'm a toast", on: .center)
    }
    
    func dismissHUD() {
        if self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        ZVProgressHUD.dismiss()
    }
    
    @IBAction func setDisplayStyle(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            ZVProgressHUD.displayStyle = .dark
            break
        case 1:
            ZVProgressHUD.displayStyle = .ligtht
            break
        case 2:
            let backgroundColor = UIColor(red: 86.0 / 255.0, green: 75.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
            let foregroundColor = UIColor(red: 239.0 / 255.0, green: 83.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
            ZVProgressHUD.displayStyle = .custom(backgroundColor: backgroundColor,
                                                 foregroundColor: foregroundColor)
            break
        default:
            break
        }
    }
    
    @IBAction func setMaskType(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            ZVProgressHUD.maskType = .clear
            break
        case 1:
            ZVProgressHUD.maskType = .none
            break
        case 2:
            ZVProgressHUD.maskType = .black
            break
        case 3:
            let color = UIColor(red: 215.0 / 255.0, green: 22.0 / 255.0, blue: 59.0 / 255.0, alpha: 0.35)
            ZVProgressHUD.maskType = .custom(color: color)
        default:
            break
        }
    }
    
    @IBAction func setAnimationType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            ZVProgressHUD.animationType = .extended
            break
        case 1:
            ZVProgressHUD.animationType = .native
            break
        default:
            break
        }
    }
    
    func progressTimerAction(_ sender: Timer) {
        
        let userInfo = sender.userInfo as? [String: String]
        let title = userInfo?["title"] ?? ""
        self.progress += 0.05
        ZVProgressHUD.show(title: title, progress: progress)
        
        if self.progress > 1.0 {
            ZVProgressHUD.dismiss()
            sender.invalidate()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseIdentifier")
        cell?.textLabel?.text = self.rows[indexPath.row].0
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        cell?.textLabel?.textColor = UIColor(white: 0.2, alpha: 1.0)
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selector = self.rows[indexPath.row].1
        self.perform(selector)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard textField == self.stateSizeTextField else { return true }
        
        var text = textField.text ?? ""
        let range = text.range(from: range)
        text.replaceSubrange(range!, with: string)
        
        let value = Int(text)
        guard let size = value, size > 0 else { return true }
    
        ZVProgressHUD.stateSize = .init(width: size, height: size)
        print(size)
        
        return true
    }
    
}

extension String {
    
    
    /// 将 Range<String.Index> 转为 NSRange
    ///
    /// - Parameter range: Range<String.Index>
    /// - Returns: NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let fromIndex = range.lowerBound.samePosition(in: utf16)
        let toIndex = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: fromIndex),
                       length: utf16.distance(from: fromIndex, to: toIndex))
    }
    
    
    /// 将NSRange 转为 Range<String.Index>
    ///
    /// - Parameter nsRange: NSRange
    /// - Returns: Range<String.Index>
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        
        guard
            let fromUTFIndex = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let toUTFIndex = utf16.index(fromUTFIndex, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let fromIndex = String.Index(fromUTFIndex, within: self),
            let toIndex = String.Index(toUTFIndex, within: self)
            else { return nil }
        
        return fromIndex ..< toIndex
    }
}


extension ViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UINavigationController {
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}

