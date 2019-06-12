enum BrewModel {
    
    struct BreweryData: Codable {
        let brewery: Breweries?
    }
    
    struct Breweries: Codable {
        let id: String?
        let name: String?
        let description: String?
        let images: BreweryImages?
    }
    
    struct BreweryImages: Codable {
        let icon: String?
    }
}
