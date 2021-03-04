//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 1.03.21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
  
  var dayLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var weatherImage: UIImageView = {
    let imageView = UIImageView()
    imageView.tintColor = UIColor.white;
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView;
  }()
  
  var avgDayTemperatureLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 19, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var avgNightTemperatureLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.systemGray4
    label.font = UIFont.systemFont(ofSize: 19, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  func setupCell() {
    self.backgroundColor = UIColor.clear;
    
    addSubview(dayLabel)
    addSubview(weatherImage)
    addSubview(avgNightTemperatureLabel)
    addSubview(avgDayTemperatureLabel)
    addSubview(avgNightTemperatureLabel)
    NSLayoutConstraint.activate([
      dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
      dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      
      weatherImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      weatherImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      
      avgDayTemperatureLabel.trailingAnchor.constraint(equalTo: avgNightTemperatureLabel.leadingAnchor, constant: -15),
      avgDayTemperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      
      avgNightTemperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      avgNightTemperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
    ])
  }
  
  override func awakeFromNib() {
      super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    selectionStyle = .none
  }
}
