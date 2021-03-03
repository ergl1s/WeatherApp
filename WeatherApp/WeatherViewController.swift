//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 28.02.21.
//

import UIKit
import Foundation

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var dailyForecasts: [Daily] = []
  let apiClient: ApiClient = ApiClientImplementation()
  
  // MARK: - Subviews setup
  var containerView: UIView = {
    var view = UIView()
//    view.backgroundColor = UIColor.red;
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var townLabel: UILabel = {
    var label = UILabel()
    label.text = "Minsk"
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 40, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var weatherLabel: UILabel = {
    var label = UILabel()
    label.text = "Thunderstorm"
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 19, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var currentTemperatureLabel: UILabel = {
    var label = UILabel()
    label.text = "34°"
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 80, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var dayLabel: UILabel = {
    var label = UILabel()
    label.text = "Sunday"
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var todayLabel: UILabel = {
    var label = UILabel()
    label.text = "Today"
    label.textColor = UIColor.systemGray4
    label.font = UIFont.systemFont(ofSize: 20, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var avgDayTemperatureLabel: UILabel = {
    var label = UILabel()
    label.text = "23°"
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var avgNightTemperatureLabel: UILabel = {
    var label = UILabel()
    label.text = "15°"
    label.textColor = UIColor.systemGray4
    label.font = UIFont.systemFont(ofSize: 20, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var backgroundImageView: UIImageView = {
    var theImageView = UIImageView()
    theImageView.image = UIImage(named: "mountain")!
    theImageView.alpha = 0.6
    theImageView.translatesAutoresizingMaskIntoConstraints = false
    theImageView.clipsToBounds = true
    theImageView.contentMode = UIView.ContentMode.scaleAspectFill
    
    return theImageView
 }()
  
  var tableView: UITableView = {
    var theTableView = UITableView()
    theTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "cellId")
    theTableView.backgroundColor = UIColor.clear;
    theTableView.translatesAutoresizingMaskIntoConstraints = false
    theTableView.separatorStyle = UITableViewCell.SeparatorStyle.none;
    return theTableView
  }()

  // MARK: - Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(backgroundImageView)
    view.addSubview(containerView)
  
    view.addSubview(tableView);
    tableView.dataSource = self;
    tableView.delegate = self;
    
    containerView.addSubview(townLabel)
    containerView.addSubview(weatherLabel)
    containerView.addSubview(currentTemperatureLabel)
    containerView.addSubview(dayLabel)
    containerView.addSubview(todayLabel)
    containerView.addSubview(avgDayTemperatureLabel)
    containerView.addSubview(avgNightTemperatureLabel)
    self.addConstraints()
    
    apiClient.getWeather(completion: {result in
      DispatchQueue.main.async {
        switch (result) {
        case .success(let response):
          self.dailyForecasts = response.daily
          break
        case .failure:
          self.dailyForecasts = []
          break
        }
        self.tableView.reloadData();
      }
    })
  }
  
  func addConstraints() {
    NSLayoutConstraint.activate([
      backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      
      
      townLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      townLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50),
      
      weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      weatherLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100),
      
      currentTemperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      currentTemperatureLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 110),
      
      dayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
      dayLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      
      todayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 90),
      todayLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      
      avgDayTemperatureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -55),
      avgDayTemperatureLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      
      avgNightTemperatureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -13),
      avgNightTemperatureLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 20),
    ])
  }
  
  //MARK: - Table view delegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! WeatherTableViewCell
    
    if (dailyForecasts.count != 0) {
    let daily = dailyForecasts[indexPath.row]
      cell.avgDayTemperatureLabel.text = "\(round(daily.temp.day*10 - 2730)/10)°"
      cell.avgNightTemperatureLabel.text = "\(round(daily.temp.night*10 - 2730)/10)°"
    }
    
    return cell;
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40;
  }
  
  //MARK: - Private methods
  
}
