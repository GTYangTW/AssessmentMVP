//
//  DownloadJSON.swift
//  AssessmentMVP
//
//  Created by 10362 on 2024/2/7.
//

import Foundation

class DownloadJSON {
    var apiWebsite = String()
    var pageNumber = Int()
    var jsonResult = [Result]()
    
//    init(pageNumber: Int = Int(), jsonResult: [Result] = [Result]()) {
//        self.pageNumber = pageNumber
//        self.jsonResult = jsonResult
//    }
    
    func createDefaultUrlComponents(nowDonwnloadPageIs: Int) -> URLComponents {
        let page = String(nowDonwnloadPageIs)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "us-central1-redso-challenge.cloudfunctions.net"
        urlComponents.path = "/catalog"
        let queryItem = URLQueryItem(name: "team", value: "rangers")
        let queryItem2 = URLQueryItem(name: "page", value: page)
        urlComponents.queryItems = [queryItem, queryItem2]
        return urlComponents
    }
    
    func downloadJson(with page: Int, completion: @escaping ([Result]) -> Void) {
        let jsonDecoder = JSONDecoder()
        let urlComponents = createDefaultUrlComponents(nowDonwnloadPageIs: page)
        
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
