import Foundation

/// Error cases for API calls.
public enum APError: Error {
    case invalidUrl
    case invalidRequestData
    case unableToComplete
    case invalidResponse
    case emptyResponseData
    case invalidResponseData
    case httpError(statusCode: Int)
    case decodingError
    case encodingError
}
