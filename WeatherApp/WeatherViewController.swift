//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 28.02.21.
//

import UIKit
import Foundation
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var currentDayForecast: Current?
  var dailyForecasts: [Daily] = []
  let apiClient: ApiClient = ApiClientImplementation()
  var currentLocation: CLLocation?
  
  // MARK: - Subviews setup
  var containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var townLabel: UILabel = {
    let label = UILabel()
    label.text = "Minsk"
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 40, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var weatherLabel: UILabel = {
    var label = UILabel()
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 19, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var currentTemperatureLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 80, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var dayLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var todayLabel: UILabel = {
    let label = UILabel()
    label.text = "Today"
    label.isHidden = true;
    label.textColor = UIColor.systemGray4
    label.font = UIFont.systemFont(ofSize: 20, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var avgDayTemperatureLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var avgNightTemperatureLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.systemGray4
    label.font = UIFont.systemFont(ofSize: 20, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var backgroundImageView: UIImageView = {
    let theImageView = UIImageView()
    theImageView.image = UIImage(named: "mountain")!
    theImageView.alpha = 0.6
    theImageView.translatesAutoresizingMaskIntoConstraints = false
    theImageView.clipsToBounds = true
    theImageView.contentMode = UIView.ContentMode.scaleAspectFill
    return theImageView
 }()
  
  var tableView: UITableView = {
    let theTableView = UITableView()
    theTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "cellId")
    theTableView.backgroundColor = UIColor.clear;
    theTableView.translatesAutoresizingMaskIntoConstraints = false
    theTableView.separatorStyle = UITableViewCell.SeparatorStyle.none;
    return theTableView
  }()
  
  var activityIndicator: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.style = .large
    activityIndicatorView.color = .white
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    return activityIndicatorView
  }()

  // MARK: - Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(backgroundImageView)
    view.addSubview(containerView)
    view.addSubview(activityIndicator)
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
    
//    let locManager = CLLocationManager()
//    locManager.requestWhenInUseAuthorization()
//    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() ==  .authorizedAlways
//    {
//      currentLocation = locManager.location
//    }
    
    activityIndicator.startAnimating()
    apiClient.getWeather(location: currentLocation,completion: {result in
      DispatchQueue.main.async {
        switch (result) {
        case .success(let response):
          self.dailyForecasts = response.daily
          self.currentDayForecast = response.current
          break
        case .failure:
          self.dailyForecasts = []
          break
        }
        self.setupCurrentDay()
        self.tableView.reloadData();
        self.activityIndicator.stopAnimating()
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
      weatherLabel.topAnchor.constraint(equalTo: townLabel.bottomAnchor, constant: -5),
      
      currentTemperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      currentTemperatureLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: -15),
      
      dayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
      dayLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      
      todayLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 5),
      todayLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      
      avgDayTemperatureLabel.trailingAnchor.constraint(equalTo: avgNightTemperatureLabel.leadingAnchor, constant: -10),
      avgDayTemperatureLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      
      avgNightTemperatureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
      avgNightTemperatureLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 20),
      
      activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
    ])
  }
  
  //MARK: - Table view delegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dailyForecasts.count != 0 ? 5 : 0;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! WeatherTableViewCell
    
    
    let daily = dailyForecasts[indexPath.row + 1]
    cell.avgDayTemperatureLabel.text = "\(round(daily.temp.day*10 - 2730)/10)°"
    cell.avgNightTemperatureLabel.text = "\(round(daily.temp.night*10 - 2730)/10)°"
    
    cell.dayLabel.text = getDayOfWeek(dtFormat: daily.dt)
    
    return cell;
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40;
  }
  
  //MARK: - Private methods
  
  func setupCurrentDay() {
    dayLabel.text = getDayOfWeek(dtFormat: currentDayForecast!.dt)
    weatherLabel.text = currentDayForecast!.weather[0].main
    currentTemperatureLabel.text = "\(round(currentDayForecast!.temp*10 - 2730)/10)°"
    avgDayTemperatureLabel.text = "\(round(dailyForecasts[0].temp.day*10 - 2730)/10)°"
    avgNightTemperatureLabel.text = "\(round(dailyForecasts[0].temp.night*10 - 2730)/10)°"
    todayLabel.isHidden = false
  }
}
