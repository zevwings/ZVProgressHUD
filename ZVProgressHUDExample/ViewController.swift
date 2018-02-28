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
        ("show", #selector(showIndicator)),
        ("showWithLabel", #selector(showWithLabel)),
        ("showProgress", #selector(showProgress)),
        ("showProgressWithLabel", #selector(showProgressWithLabel)),
        ("showError", #selector(showError)),
        ("showSuccess", #selector(showSuccess)),
        ("showWarning", #selector(showWarning)),
        ("showCustomImage", #selector(showCustomImage)),
        ("showCustomImageWithLabel", #selector(showCustomImageWithLabel)),
        ("showAnimation", #selector(showCustomView)),
        ("showLabel", #selector(showLabel)),
        ("dismiss", #selector(dismissHUD))
    ]

    @IBOutlet weak var stateSizeTextField: UITextField!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var textField: UITextField!

    var progress: Float = 0.0
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ZVProgressHUD.maskType = .black
        ZVProgressHUD.displayStyle = .dark

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(progressHUDTouchEvent(_:)),
                                               name: .ZVProgressHUDReceivedTouchUpInsideEvent,
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

// MARK: - ZVProgressHUD Notification

extension ViewController {

    @objc func progressHUDTouchEvent(_ notification: Notification) {
        ZVProgressHUD.dismiss()
    }
}

// MARK: - ZVProgressHUD

extension ViewController {

    @objc func showIndicator() {
        ZVProgressHUD.show()
    }

    @objc func showWithLabel() {
        ZVProgressHUD.show(with: "正在保存 ... ", delay: 3.0)
    }

    @objc func showError() {
        ZVProgressHUD.showError(with: "保存失败")
    }

    @objc func showSuccess() {
        ZVProgressHUD.showSuccess(with: "保存成功")
    }

    @objc func showWarning() {
        ZVProgressHUD.showWarning(with: "存储信息有误")
    }

    @objc func showCustomImage() {
        
        let image = UIImage(named: "smile")
        ZVProgressHUD.showImage(image!)
    }

    @objc func showCustomImageWithLabel() {
        
        let image = UIImage(named: "smile")
        ZVProgressHUD.showImage(image!, title: "微笑每一天")
    }

    @objc func showProgress() {
        self.progress = 0
        if  self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        ZVProgressHUD.showProgress(0.0)
        self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(ViewController.progressTimerAction(_:)), userInfo: nil, repeats: true)
    }

    @objc func showProgressWithLabel() {
        self.progress = 0
        if  self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        ZVProgressHUD.showProgress(0.0, title: "Progress")
        self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(ViewController.progressTimerAction(_:)), userInfo: ["title": "Progress"], repeats: true)
    }


    @objc func showCustomView() {
        
        var images = [UIImage]()
        for index in 1 ... 3 {
            let image = UIImage(named: "loading_0\(index)")
            images.append(image!)
        }
        ZVProgressHUD.showAnimation(images)
    }

    @objc func showLabel() {
        
        
        ZVProgressHUD.showText("我是一个挺长挺长的土豆肉丝加餐吃掉饱了没有", in: self.view)

//        ZVProgressHUD.showText("我是一个挺长挺长的土豆肉丝加餐吃掉饱了没有")
    }

    @objc func dismissHUD() {

        ZVProgressHUD.dismiss(delay: 3) {
            print("dimiss")
        }
    }

    @IBAction func setDisplayStyle(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            ZVProgressHUD.displayStyle = .dark
            break
        case 1:
            ZVProgressHUD.displayStyle = .light
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
            ZVProgressHUD.animationType = .flat
            break
        case 1:
            ZVProgressHUD.animationType = .native
            break
        default:
            break
        }
    }

    @objc func progressTimerAction(_ sender: Timer?) {

        let userInfo = sender?.userInfo as? [String: String]
        let title = userInfo?["title"] ?? ""
        progress += 0.05
        ZVProgressHUD.showProgress(progress, title: title)

        if progress > 1.0 {
            timer?.invalidate()
            timer = nil
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

