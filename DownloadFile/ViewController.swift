//
//  ViewController.swift
//  DownloadFile
//
//  Created by Viet Le Van on 11/17/20.
//

import UIKit
import Alamofire
import MBProgressHUD

class ViewController: UIViewController {
    var progressHub: MBProgressHUD!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        testDownloadFile()
    }
    
    func testDownloadFile() {
        let downloadQueue = DispatchQueue.global(qos: .default)
        progressHub = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHub.mode = .annularDeterminate
        AF.download("http://qeam.org/qeam/pdf/hackingwithswift.pdf")
            .downloadProgress(queue: downloadQueue) { (progress) in
                DispatchQueue.main.async {
                    let progressValue = Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
                    print(progressValue)
                    self.progressHub.progress = progressValue
                }
                
            }
            .responseURL(completionHandler: { (responseURL) in
                if let url = responseURL.fileURL {
                    let filePath = NSTemporaryDirectory().appending("hackingwithswift.pdf")
                    
                    try? FileManager.default.copyItem(at: url, to: URL.init(fileURLWithPath: filePath))
                    DispatchQueue.main.async {
                        self.progressHub.hide(animated: true)
                    }
                }
            })
    }

}


