//
//  ViewController.swift
//  DownloadFile
//
//  Created by Viet Le Van on 11/17/20.
//

import UIKit
import Alamofire
import MBProgressHUD
import PDFKit

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
            .response { (url) in
                DispatchQueue.main.async {
                    self.progressHub.hide(animated: true)
                    if let pdfURL = url.value {
                        self.previewPDF(url: pdfURL!)
                    }
                }
            }
    }
    
    private func previewPDF(url: URL) {
        let pdfview = PDFView(frame:self.view.bounds)
        pdfview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfview.autoScales = true
        self.view.addSubview(pdfview)
        let doc = PDFDocument(url: url)
        pdfview.document = doc
    }
}


