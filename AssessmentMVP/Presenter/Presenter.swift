//
//  Presenter.swift
//  AssessmentMVP
//
//  Created by 10362 on 2024/2/7.
//

import Foundation
import UIKit

// protocol
// View & Presenter 之間的委任
// Protocol 中加入更新畫面的方法(數據在這裡被傳過去)
// Presenter 中實作方法，把數據推給 View； View 中實作方法刷新畫面
protocol RedsoPresenterDelegate: AnyObject {
    func presentJSON(result: [Result])
}

//Presenter 主要的 class 以及 weak self
class RedsoPresenter {

    // 創建 delegation 的變數遵照 Protocol 實作的方法
    weak var delegate: RedsoPresenterDelegate?
    let jsonDecoder = JSONDecoder()
    var arrayResult = [Result]()
    
    // 實作方法
    func getJSON(with pageNumber: Int = 0){
        let downloadJson = DownloadJSON()
<<<<<<< HEAD
        let urlComponent = downloadJson.createDefaultUrlComponents(nowDonwnloadPageIs: pageNumber)
        let task = URLSession.shared.dataTask(with: urlComponent.url!) { [weak self] (data, response , error) in
            if let data = data {
                do {
                    let jsonData = try JSONDecoder().decode(DataJson.self, from: data)
                    let tempjson = jsonData.results.compactMap{ $0 }
                    self?.arrayResult += tempjson
                    // 協定，把獲得的值，放到 Protocol 中，給其他 View 使用
                    // 多個畫面如何處理？
                    self?.delegate?.presentJSON(result: self!.arrayResult)
                } catch {
                    fatalError("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()
=======
        //let urlComponent = try downloadJson.createDefaultUrlComponents(nowDonwnloadPageIs: pageNumber)
        let jsonResult = downloadJson.downloadJson(with: pageNumber, completion: { result in
            self.arrayResult += result
            self.delegate?.presentJSON(result: self.arrayResult)
        })
>>>>>>> feature
    }
    
    // 委任，當外部呼叫這個方法時，需要呼叫方輸入一個要實作的協議（Protocol）父類型（1/2）
    func setViewDelegate(delegate: RedsoPresenterDelegate){
        self.delegate = delegate
    }
}
