class ErrorObject: Codable {
    let message: String
    let invalidFields: [String]?
    let status: String
}
