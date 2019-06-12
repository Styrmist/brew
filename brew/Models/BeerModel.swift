enum BeerModel {
    
    struct BeerData: Codable {
        let id: String
        let name: String
        let description: String?
        let abv: String?
        let ibu: String?
        let labels: BeerLabels?
        let style: BeerStyle?
    }
    
    struct BeerStyle: Codable {
        let name: String?
        let shortName: String?
        let description: String?
    }
    
    struct BeerLabels: Codable {
        let icon: String?
        let medium: String?
        let large: String?
        let contentAwareIcon: String?
        let contentAwareMedium: String?
        let contentAwareLarge: String?
    }
    
    struct BeerCategory: Codable {
        let id: Int?
        let name: String?
        let createDate: String?
    }
    struct BeerForSave {
        let id: String
    }
}
