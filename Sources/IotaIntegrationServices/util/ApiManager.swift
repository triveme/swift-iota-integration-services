import Foundation
import Logging

/// API manager for handling http calls.
public class ApiManager {

    private let logger: Logger

    public let encoder: JSONEncoder
    public let decoder: JSONDecoder

    private let urlSchema: String
    private let urlHost: String
    private let urlPort: Int
    private let urlPath: String
    private let urlQueryItems: [URLQueryItem]?
    
    /// Initializes the class with the services details.
    /// - Parameters:
    ///   - schema: URL schema
    ///   - host: URL host
    ///   - port: URL port
    ///   - path: URL path
    ///   - queryItems: URL query items
    public init(schema: String, host: String, port: Int, path: String, queryItems: [URLQueryItem]? = nil) {
        logger = Logger(label: String(describing: ApiManager.self))

        encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        decoder = JSONDecoder()

        urlSchema = schema
        urlHost = host
        urlPort = port
        urlPath = path
        urlQueryItems = queryItems
    }
    
    /// Performs a given URL request.
    /// - Parameters:
    ///   - request: URL request
    ///   - model: Data model
    ///   - completed: Completed action
    public func httpRequest<T: Decodable>(_ request: URLRequest, model: T.Type, completed: @escaping (Result<T, APError>) -> Void) {
        
        logger.info("\(request.httpMethod!) \(request.url!)")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completed(.failure(.invalidResponse))
                return
            }
                      
            guard (200...300 ~= response.statusCode) else {
                completed(.failure(.httpError(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completed(.failure(.emptyResponseData))
                return
            }
            
            do {
                let response = try self.decoder.decode(model, from: data)
                
                DispatchQueue.main.async {
                    completed(.success(response))
                }
            } catch {
                completed(.failure(.invalidResponseData))
            }

        }
        
        task.resume()
    }
    
    /// Generates a custom url from the given parameters.
    /// - Parameters:
    ///   - scheme: URL scheme
    ///   - host: URL host
    ///   - port: URL port
    ///   - path: URL path
    ///   - queryItems: URL query items
    /// - Returns: Generated URL
    private func generateCustomUrl(scheme: String, host: String, port: Int, path: String, queryItems: [URLQueryItem]) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.port = port
        urlComponents.path = path
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url?.absoluteURL else {
            throw URLError(.badURL)
        }

        return url
    }
    
    /// Generates a url from the instances url properties and the given parameters.
    /// - Parameters:
    ///   - endpoint: URL endpoint
    ///   - additionalQueryItems: Additional URL query items
    /// - Returns: Generated URL
    public func generateUrl(forEndpoint endpoint: String, withAdditionalQueryItems additionalQueryItems: [URLQueryItem]? = nil) throws -> URL {
        var combinedQueryItems: [URLQueryItem] = []
        if let urlQueryItems = urlQueryItems {
            combinedQueryItems.append(contentsOf: urlQueryItems)
        }
        if let customQueryItems = additionalQueryItems {
            combinedQueryItems.append(contentsOf: customQueryItems)
        }
        combinedQueryItems = combinedQueryItems.unique()

        return try generateCustomUrl(
                scheme: urlSchema,
                host: urlHost,
                port: urlPort,
                path: "\(urlPath)\(endpoint)",
                queryItems: combinedQueryItems)
    }
}
