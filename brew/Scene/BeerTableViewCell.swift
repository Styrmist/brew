import UIKit

class BeerTableViewCell: UITableViewCell {

    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerLabel: UILabel!
    @IBOutlet weak var beerType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        beerImage.image = nil
        beerLabel.text = nil
        beerType.text = nil
    }
}
