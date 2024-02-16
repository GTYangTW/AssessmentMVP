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

//typealias PresenterDelegate = RedsoPresenterDelegate & UIViewController

//Presenter 主要的 class 以及 weak self
class RedsoPresenter {
    //let downloadJSON = DownloadJSON()
    //weak var mainView: MainView?

    // 創建 delegation 的變數遵照 Protocol 實作的方法
    weak var delegate: RedsoPresenterDelegate?
    let jsonDecoder = JSONDecoder()
    var arrayResult = [Result]()
    
    // 實作方法
    func getJSON(with pageNumber: Int = 0){
        let downloadJson = DownloadJSON()
        //let urlComponent = try downloadJson.createDefaultUrlComponents(nowDonwnloadPageIs: pageNumber)
        let jsonResult = downloadJson.downloadJson(with: pageNumber, completion: { result in
            self.delegate?.presentJSON(result: result)
        })
    }
    
    // 委任，當外部呼叫這個方法時，需要呼叫方輸入一個要實作的協議（Protocol）父類型（1/2）
    func setViewDelegate(delegate: RedsoPresenterDelegate){
        self.delegate = delegate
    }
}
