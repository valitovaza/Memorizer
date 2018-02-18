enum Result<SuccessType, ErrorType> {
    case success(SuccessType)
    case failure(ErrorType)
}
