protocol ProfileStorageProtocol {
    func fetch(id: String) -> ProfileInfo?
    func save(_ profile: ProfileInfo)
    func delete(id: String)
    func clear()
}
