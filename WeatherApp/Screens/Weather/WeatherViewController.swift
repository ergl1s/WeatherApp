//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 28.02.21.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
  var currentDayForecast: Current?
  var dailyForecasts: [Daily] = []
  let apiClient: ApiManager = ApiManager()
  var location: CLLocation?
  var locManager = CLLocationManager()
  
  let WeatherDict:[String:String] = [
    "Thunderstorm":"cloud.bolt.rain.fill",
    "Drizzle":"cloud.drizzle.fill",
    "Rain":"cloud.rain.fill",
    "Snow":"cloud.snow.fill",
    "Clear":"sun.max.fill",
    "Clouds":"cloud.fill"
  ]
  
  // MARK: - Subviews setup
  var containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
 
  var townLabel: UILabel = {
    let label = UILabel()
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

  //MARK: - Error handling
  
  var reloadButton: UIButton = {
    let button = UIButton()
    button.isHidden = true
    button.setTitle("Reload data", for: .normal)
    button.backgroundColor = UIColor.white.withAlphaComponent(0.4)
    button.layer.cornerRadius = 15
    button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
    button.addTarget(self, action:#selector(reloadData), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  var errorLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 5
    label.textColor = UIColor(red: 0.87, green: 0.05, blue: 0.05, alpha: 1.0)
    label.isHidden = true
    label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  // MARK: - Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(backgroundImageView)
    view.addSubview(containerView)
    view.addSubview(activityIndicator)
    view.addSubview(tableView);
    
    view.addSubview(reloadButton);
    view.addSubview(errorLabel);
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    containerView.addSubview(townLabel)
    containerView.addSubview(weatherLabel)
    containerView.addSubview(currentTemperatureLabel)
    containerView.addSubview(dayLabel)
    containerView.addSubview(todayLabel)
    containerView.addSubview(avgDayTemperatureLabel)
    containerView.addSubview(avgNightTemperatureLabel)
    addConstraints()
    setupLocationService()
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
     
      avgNightTemperatureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
      avgNightTemperatureLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      
      avgDayTemperatureLabel.trailingAnchor.constraint(equalTo: avgNightTemperatureLabel.leadingAnchor, constant: -10),
      avgDayTemperatureLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
      
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 20),
      
      activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      
      errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      errorLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -40),
      
      reloadButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      reloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
      reloadButton.widthAnchor.constraint(equalToConstant: 215),
    ])
  }
  
  func setupLocationService() {
    locManager.delegate = self
    if (CLLocationManager.locationServicesEnabled()) {
      locManager = CLLocationManager()
      locManager.delegate = self
      locManager.desiredAccuracy = kCLLocationAccuracyBest
      locManager.requestAlwaysAuthorization()
      locManager.startUpdatingLocation()
    }
  }
  
  @objc private func reloadData() {
    showLoading()
    apiClient.getWeather(location: location, completion: {result in
      DispatchQueue.main.async {
        switch (result) {
        case .success(let response):
          self.showData()
          self.dailyForecasts = response.daily
          self.currentDayForecast = response.current
          break
        case .failure(let error):
          self.showError(error: error)
          self.dailyForecasts = []
          self.currentDayForecast = nil
          break
        }
        self.setupCurrentDay()
        self.tableView.reloadData()
      }
    })
  }
  
  private func showLoading() {
    errorLabel.isHidden = true
    reloadButton.isHidden = true
    activityIndicator.startAnimating()
  }
  
  private func showData() {
    errorLabel.isHidden = true
    reloadButton.isHidden = true
    townLabel.isHidden = false;
    weatherLabel.isHidden = false
    currentTemperatureLabel.isHidden = false
    dayLabel.isHidden = false
    todayLabel.isHidden = false
    avgDayTemperatureLabel.isHidden = false
    avgNightTemperatureLabel.isHidden = false
    tableView.isHidden = false
    activityIndicator.stopAnimating()
  }
  
  private func hideData() {
    townLabel.isHidden = true;
    weatherLabel.isHidden = true
    currentTemperatureLabel.isHidden = true
    dayLabel.isHidden = true
    todayLabel.isHidden = true
    avgDayTemperatureLabel.isHidden = true
    avgNightTemperatureLabel.isHidden = true
    tableView.isHidden = true
  }
  
  private func showError(error: Error) {
    errorLabel.isHidden = false
    reloadButton.isHidden = false
    hideData()
    guard let error = error as? ApiError else {
      errorLabel.text = "Unknown error"
      return
    }
    let textOfError = error.getTextOfError()
    errorLabel.text = textOfError
    activityIndicator.stopAnimating()
  }
  
  func setupCurrentDay() {
    if (currentDayForecast == nil) {
      return
    }
    dayLabel.text = getDayOfWeek(dtFormat: currentDayForecast!.dt)
    weatherLabel.text = currentDayForecast!.weather[0].main
    currentTemperatureLabel.text = "\(round(currentDayForecast!.temp*10 - 2730)/10)°"
    avgDayTemperatureLabel.text = "\(round(dailyForecasts[0].temp.day*10 - 2730)/10)°"
    avgNightTemperatureLabel.text = "\(round(dailyForecasts[0].temp.night*10 - 2730)/10)°"
    todayLabel.isHidden = false
  }
  
  private func getDayOfWeek(dtFormat:Int) -> String {
    let date = Date(timeIntervalSince1970: Double(dtFormat))
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = .current
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: date)
  }
  
  //MARK: - TableView delegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dailyForecasts.count != 0 ? 5 : 0;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! WeatherTableViewCell
    let daily = dailyForecasts[indexPath.row + 1]
    cell.avgDayTemperatureLabel.text = "\(round(daily.temp.day*10 - 2730)/10)°"
    cell.avgNightTemperatureLabel.text = "\(round(daily.temp.night*10 - 2730)/10)°"
    cell.weatherImage.image = getImageForWeather(weather: daily.weather[0].main)
    cell.dayLabel.text = getDayOfWeek(dtFormat: daily.dt)
    return cell;
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40;
  }
  
  //MARK: - Others
  
  func setupTownLabelFromLocation() {
    location?.fetchCity{ city, error in
      guard let city = city, error == nil else {
        return
      }
      self.townLabel.text = city
    }
  }
  
  func getImageForWeather(weather: String) -> UIImage {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
    if let imageName = WeatherDict[weather] {
      return UIImage(systemName: imageName, withConfiguration: imageConfig)!
    } else {
      return UIImage(systemName: "wind", withConfiguration: imageConfig)!
    }
  }
  
//MARK: - Location Manager delegate
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    location = locations.last! as CLLocation
    setupTownLabelFromLocation()
    reloadData()
  }
}

