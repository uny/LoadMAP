import Foundation
import RxSwift

protocol WebServiceProtocol {
    func download(url: URL) -> Single<URL>
}

final class WebService: WebServiceProtocol {
    func download(url: URL) -> Single<URL> {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5 * 60)
        return Single.create { observer in
            let task = URLSession.shared.downloadTask(with: request) { url, response, error in
                if let url = url {
                    observer(.success(url))
                }
            }
            task.resume()
            return Disposables.create(with: task.cancel)
        }
    }
}
