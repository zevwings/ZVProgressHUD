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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    var progress: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.progressHUDTouchEvent(notification:)), name: .ZVProgressHUDTouchEvent, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

// MARK: - ZVProgressHUD Notification

extension ViewController {
    
    func progressHUDTouchEvent(notification: Notification) {
        ZVProgressHUD.dismiss()
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
        let image = UIImage(named: "cost")
        ZVProgressHUD.show(image: image!)
    }
    
    func showCustomImageWithLabel() {
        let image = UIImage(named: "cost")
        ZVProgressHUD.show(with: .state(title: "Cost", state: .custom(image: image!)))
    }
    
    func showProgress() {
        self.progress = 0
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.progressTimerAction(_:)), userInfo: nil, repeats: true)
    }
    
    func showProgressWithLabel() {
        self.progress = 0
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.progressTimerAction(_:)), userInfo: ["title": "Progress"], repeats: true)
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
        ZVProgressHUD.show(label: "I'm a toast")
    }
    
    func showLabelOnCenter() {
        ZVProgressHUD.show(label: "I'm a toast", on: .center)
    }
    
    func dismissHUD() {
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
