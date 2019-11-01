//
//  RestAPI.swift
//  WeatherApp
//
//  Created by Ali Youness on 10/25/19.
//  Copyright © 2019 Ali Youness. All rights reserved.
//

import Foundation

struct Wrapper<T: Decodable>: Decodable {
    let items: [T]
}


final class RestAPI
{
    var requestHttpHeaders = RestEntity()
    var urlQueryParameters = RestEntity()
    var httpBodyParameters = RestEntity()
    var httpBody:Data?
    
    func getWeatherData(lat: String, lon: String, completion: ((Result<WeatherStruct>) -> Void)?) -> () {
           
           var urlComponents = getBaseComponent()
           let queryItemLan = URLQueryItem(name: "lat", value: lat)
           let queryItemLon = URLQueryItem(name: "lon", value:lon)
           
           urlComponents.queryItems?.append(queryItemLan)
           urlComponents.queryItems?.append(queryItemLon)
           loadItems(with: urlComponents, completion: completion)
       }
       
       func getWeatherDataByCity(city: String, completion: ((Result<WeatherStruct>) -> Void)?) {
           var urlComponents = getBaseComponent()
           let queryItemCity = URLQueryItem(name: "q", value: city)
           urlComponents.queryItems?.append(queryItemCity)
           loadItems(with: urlComponents, completion: completion)
       }
    
    enum Result<T>
    {
        case success(T)
        case failure(Error)
    }
    
    private let appId = "ca9db572fae974e04fc67268c81830a9"
    private let apiHost = "api.openweathermap.org"
    private let apiPath = "/data/2.5/weather"
    
    private func getBaseComponent() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = apiHost
        urlComponents.path = apiPath
        let queryItemUnits = URLQueryItem(name: "units", value: "metric")
        let queryItemToken = URLQueryItem(name: "appid", value: appId)
        urlComponents.queryItems = [ queryItemUnits, queryItemToken]
        return urlComponents
    }


    private func loadItems<T: Decodable>(with components: URLComponents, completion: ((Result<T>) -> Void)?) {
          guard let url = components.url else { return }
          
          var request = URLRequest(url: url)
          print(url)
          request.httpMethod = HttpMethod.get.rawValue
          let config = URLSessionConfiguration.default
          let session = URLSession(configuration: config)
          let task = session.dataTask(with: request) { (responseData, response, responseError) in
              guard responseError == nil else { print("ERROR: - \(String(describing: responseError))"); return}
              guard let jsonData = responseData else { return }
              print(jsonData)
              let decoder = JSONDecoder()
              decoder.keyDecodingStrategy = .convertFromSnakeCase
         
              do {
                let decodedData = try decoder.decode(T.self, from: jsonData)
                completion?(.success(decodedData))
                 
              }
              catch {
                  completion?(.failure(error))
                  print(error.localizedDescription)
              }

          }
          task.resume()
      }
    
    private func createWeatherObjectWith<T: Decodable>(json: Data, Object:T.Type ,completion: @escaping (_ data: T?, _ error: Error?) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let weather = try decoder.decode(T.self, from: json)
            return completion(weather, nil)
        } catch let error {
            return completion(nil, error)
        }
    }
    public func makeHttpRequest(destinationUrl url:URL , withHttpVerb httpMethod :HttpMethod,completion: @escaping( _ result:Results) -> Void)
    {
        DispatchQueue.global(qos:.userInitiated).async {
            [weak self] in
            let targetURL = self?.AddURLQueryParameters(toURL: url)
            let httpBody = self?.httpBody
            
            
            guard let request  = self?.prepareHttpRequest(withURL: targetURL, httpBody: httpBody, httpMethod: httpMethod) else
            {
                completion(Results(withError: CustomError.failedToCreateRequest))
                return
            }
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: request)
            {
                (data, response, error) in completion(Results(withData: data,
                                              response: Response(fromURLResponse: response),
                                              error: error))
                       }
            task.resume()
        }
    }
    
      func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
          DispatchQueue.global(qos: .userInitiated).async {
              let sessionConfiguration = URLSessionConfiguration.default
              let session = URLSession(configuration: sessionConfiguration)
              let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                  guard let data = data else { completion(nil); return }
                  completion(data)
              })
              task.resume()
          }
      }
    //Mark Private Methods
    
    private func AddURLQueryParameters(toURL url:URL) -> URL{
        if urlQueryParameters.items() > 0
        {
            guard var urlComponents = URLComponents(url:url ,resolvingAgainstBaseURL: false) else { return url }
            var queryItems = [URLQueryItem] ()
            for (key , value) in urlQueryParameters.allValues()
            {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
            
            urlComponents.queryItems = queryItems
                     
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
        return url
    }
    
func getHttpBody() ->Data?
{
    guard let contentType = requestHttpHeaders.value(forkey: "Content-Type") else {return nil}
    if contentType.contains("application/json")
    {
        return try? JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted,.sortedKeys])
    }
    else if contentType.contains("application/x-www-form-urlencoded")
    {
        let bodyString = httpBodyParameters.allValues().map { "\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))" }.joined(separator: "&")
        return bodyString.data(using: .utf8)
    }
    else
    {
        return httpBody
    }
 }
    
    
    private func prepareHttpRequest(withURL url: URL?, httpBody: Data?, httpMethod: HttpMethod) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        for (header, value) in requestHttpHeaders.allValues() {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        request.httpBody = httpBody
        return request
    }
}
//Custm Type
extension RestAPI
{
    enum HttpMethod:String {
        case get
        case post
    }
    

struct RestEntity {
    
    private var values:[String:String] = [:]
    mutating func add(value:String ,forKey key:String)
    {
        values[key] = value
    }
    func value(forkey key:String) -> String?
    {
        return values[key]
    }
    func allValues()->[String:String]
    {
        return values;
    }
    func items()->Int{
        return values.count
    }
}
struct Response  {
    var resposne:URLResponse?
    var httpStatusCode:Int = 0
    var headers = RestEntity()
    
    init(fromURLResponse response: URLResponse?)
    {
        guard let response = response else {return }
        self.resposne = response
        httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields
        {
            for (key,value ) in headerFields {
                headers.add(value: "\(value)", forKey: "\(key)")
            }
        }
    }
}
struct Results {
    var data:Data?
    var response:Response?
    var error:Error?
    init(withData  data:Data? ,response : Response?,error:Error?)
    {
        self.data = data
        self.response = response
        self.error = error
    }
    init(withError error :Error)
    {
        self.error = error
    }
}

        enum CustomError: Error {
            case failedToCreateRequest
        }
    }
    
    
extension RestAPI.CustomError:LocalizedError{
    
    public var localizedDescription :String {
        switch self {
        case .failedToCreateRequest: return NSLocalizedString("Unable to create the URLRequest object", comment: "")

        }
    }
}
extension Decodable {
    static func map(JSONString:String) -> Self? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Self.self, from: Data(JSONString.utf8))
        } catch let error {
            print(error)
            return nil
        }
    }
}
