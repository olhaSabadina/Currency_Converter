//
//  Sare+VC+Extension.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-05-19.
//

import Foundation
import UIKit


extension StartViewController {
    
    func shareText() {
        let text = createTextToShare(currenсyArray)
        let obectsToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: obectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareScreenShotImage() {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        view.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        
        let obectsToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: obectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func createTextToShare(_ array:[Currency]?) -> String {
        guard let array = array else {return ""}
        var resultString = ""
        for item in array {
            if item.currency != "UAH" {
                let str = "100 \(item.currency) = \(String(format: "%.3f", ((item.saleRateNB ?? 0) * 100))) UAH\n"
                resultString.append(str)
            }
        }
        resultString.append(lastUpdatedLabel.text ?? "")
        return resultString
    }
}
