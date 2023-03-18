//
//  NetworkService.swift
//  DownloadProgress
//
//  Created by Stan Trujillo on 13/08/2023.
//

import Foundation

private let DownloadDelegateMaxFrequencyPerSecond = 30
private let DownloadDelegateMaxFrequency = 1.0 / Double(DownloadDelegateMaxFrequencyPerSecond)

protocol DownloadProgressDelegate {
    func progress(percent: Double)
}

class NetworkResponse<T> {
    init(body: T?, statusCode: Int) {
        self.body = body
        self.httpStatusCode = statusCode
    }
    var httpStatusCode: Int
    var body: T?
}

class NetworkService {
    actor fetchActor {
        
        func downloadFile(url: URL, delegate: DownloadProgressDelegate?) async throws -> NetworkResponse<Data>? {
            
            let request = URLRequest(url: url)
            
            var lastDelegateUpdate = Date.now
            delegate?.progress(percent: 0.0)

            do {
                let (asyncBytes, urlResponse) = try await URLSession.shared.bytes(for: request)
                let responseInfo = urlResponse as! HTTPURLResponse

                var data = Data()
                data.reserveCapacity(Int(urlResponse.expectedContentLength))

                for try await byte in asyncBytes {
                    data.append(byte)

                    if lastDelegateUpdate.secondsHaveElapsedSince(interval: DownloadDelegateMaxFrequency) {
                        lastDelegateUpdate = Date.now
                        let percent = Double(data.count) / Double(urlResponse.expectedContentLength)
                        delegate?.progress(percent: percent)
                    }
                }
                
                delegate?.progress(percent: 1.0)
                
                print("\(request.url!) [\(responseInfo.statusCode)]")
                
                if responseInfo.statusCode != 200 {
                    return NetworkResponse(body: nil, statusCode: responseInfo.statusCode)
                }
                
                return NetworkResponse(body: data, statusCode: responseInfo.statusCode)
            } catch let error {
                print("\(error)")
            }

            return NetworkResponse(body: nil, statusCode: 0)
        }
        
    }

    let actor = fetchActor()
}
