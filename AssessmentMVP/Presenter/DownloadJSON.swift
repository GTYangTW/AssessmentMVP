//
//  DownloadJSON.swift
//  AssessmentMVP
//
//  Created by 10362 on 2024/2/7.
//

import Foundation

class DownloadJSON {
    private var apiWebsite = String()
    private var pageNumber = Int()
    private var jsonResult = [Result]()
    
    // createDefaultUrlComponents目前沒使用
    func createDefaultUrlComponents(webapi value: String, nowDonwnloadPageIs: Int) -> URLComponents {
        let value = value
        let page = String(nowDonwnloadPageIs)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "us-central1-redso-challenge.cloudfunctions.net"
        urlComponents.path = "/catalog"
        let queryItem = URLQueryItem(name: "team", value: value)
        let queryItem2 = URLQueryItem(name: "page", value: page)
        urlComponents.queryItems = [queryItem, queryItem2]
        return urlComponents
    }
    
    func webapiChecked(viewNumber: Int) throws -> String{
        let apiName: [Int: String] = [1: "Rangers",
                                      2: "Elastic",
                                      3: "Dynamo"]
        guard viewNumber >= 3 else{
            throw viewNumberError.OutOfNumber
        }
        if let viewNumber = apiName[viewNumber] as? String {
            return viewNumber
        }
        return "Rangers"
    }
    
    func downloadJson(with webapi: String, with page: Int, completion: @escaping ([Result]) -> Void) {
        let jsonDecoder = JSONDecoder()
        let urlComponents = createDefaultUrlComponents(webapi: webapi, nowDonwnloadPageIs: page)
        
        if let url = urlComponents.url {
            let task = URLSession.shared.dataTask(with: url) { (data, response , error) in
                if error != nil {
                    //completion(nil)
                    return
                }
                if let data = data {
                    do {
                        let jsonData = try jsonDecoder.decode(DataJson.self, from: data)
                        let jsonResult = jsonData.results.compactMap{ $0 }
                        completion(jsonResult)
                    } catch {
                        fatalError("Error parsing JSON: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    // TODO: 實作儲存到本地的功能
    func loadingJsonFromLocal() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName = String("\(self.apiWebsite)-\(self.pageNumber).json")
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // Data(contentsOf:)會導致 main threads 卡頓，因此寫成網路下載時，不能放在main執行
                    let data = try Data(contentsOf: fileURL)
                    let json = try JSONDecoder().decode(DataJson.self, from: data)
                    //self.tbData = json.results.compactMap{ $0 }
                } catch {
                    print("Error reading file: \(error.localizedDescription)")
                }
            } else {
                print("File does not exist at path: \(fileURL.path)")
                // 如果文件不存在，可以根据需要执行其他操作
            }
        }
    }
}
