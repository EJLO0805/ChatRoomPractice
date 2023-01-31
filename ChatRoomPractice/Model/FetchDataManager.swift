//
//  FetchDataManager.swift
//  ChatRoomPractice
//
//  Created by 羅以捷 on 2023/1/29.
//

import Foundation


struct FetchData{
    private static var apiKey : String = "Bearer APIKey"
    private static var apiHeaderField : String = "Authorization"
    private static var apiKeyOfPost : String = "application/json"
    private static var apiHeaderFieldOfPost : String = "Content-Type"
    private static var chatUrl : String = "https://api.airtable.com/YourURL"
    
    
    //下載對話資料
    static func fetchChatContent(completion: @escaping (Result<[ChatRoomModel.Record], Error>) -> Void){
        let url = URL(string: Self.chatUrl)!
        var request = URLRequest(url: url)
        request.setValue(Self.apiKey, forHTTPHeaderField: Self.apiHeaderField)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do{
                    let decorder = JSONDecoder()
                    let contentResponse = try decorder.decode(ChatRoomModel.self, from: data)
                    completion(.success(contentResponse.records))
                }catch{
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    //上傳對話資料
    static func uploadChatContent(chatContent: ChatContentModel  ,completion: @escaping(Result<String,Error>) -> Void){
        let sendTimeStr = dateToString(chatContent.sendTime)
        let chatContent = ChatRoomModel.Record(fields: ChatRoomModel.Fields(name: chatContent.name, content: chatContent.content, sendTimeString: sendTimeStr))
        let url = URL(string: Self.chatUrl)!
        var request = URLRequest(url: url)
        request.setValue(Self.apiKey, forHTTPHeaderField: Self.apiHeaderField)
        request.setValue(Self.apiKeyOfPost, forHTTPHeaderField: Self.apiHeaderFieldOfPost)
        request.httpMethod = "POST"
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(chatContent)
            URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
                if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
                    completion(.success("成功"))
                }
            }.resume()
        }catch{
            completion(.failure(error))
        }
    }
    
}
