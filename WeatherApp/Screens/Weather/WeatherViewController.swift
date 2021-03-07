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

class WeatherViewController: UIViewController {
  var currentDayForecast: Current?
  var dailyForecasts: [Daily]?
  let apiClient: ApiManager = ApiManager()
  var location: CLLocation?
  var locManager = CLLocationManager()
  
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
    theTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
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
    guard let currentDayForecast = currentDayForecast, let dailyForecasts = dailyForecasts else {return;}
    dayLabel.text = getDayOfWeek(dtFormat: currentDayForecast.dt)
    weatherLabel.text = currentDayForecast.weather[0].main
    currentTemperatureLabel.text = "\(round(currentDayForecast.temp*10 - 2730)/10)°"
    avgDayTemperatureLabel.text = "\(round(dailyForecasts[0].temp.day*10 - 2730)/10)°"
    avgNightTemperatureLabel.text = "\(round(dailyForecasts[0].temp.night*10 - 2730)/10)°"
    todayLabel.isHidden = false
  }
  
  func setupTownLabelFromLocation() {
    guard let location = location else {return}
    location.fetchCity{ city, error in
      guard let city = city, error == nil else {
        return
      }
      self.townLabel.text = city
    }
  }
  
  func showAlertWithSettingsButton() {
    let alertController = UIAlertController (title: "Location wasn't allowed", message: "App doesn't work without location services. Please, go to settings -> privacy -> location services and allow the use of location", preferredStyle: .alert)

    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    alertController.addAction(settingsAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
      (_) -> Void in
      if (self.location == nil && self.locManager.authorizationStatus != .notDetermined) {
        self.showAlertWithSettingsButton()
      }
    }
    alertController.addAction(cancelAction)
    if (self.presentedViewController == nil) {
      present(alertController, animated: true, completion: nil)
    }
  }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let dailyForecasts = dailyForecasts else {return 0}
    if (dailyForecasts.count > 5) {
      return 5;
    } else {
      return dailyForecasts.count - 1;
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
    guard let dailyForecasts = dailyForecasts else {
      return cell;
    }
    ///because first day is a current day
    cell.configure(daily: dailyForecasts[indexPath.row + 1])
    return cell;
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40;
  }
}

extension WeatherViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      location = locations.last
      setupTownLabelFromLocation()
      reloadData()
    }

  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    guard let error = error as? CLError else {return}
    if (error.code == CLError.denied && locManager.authorizationStatus == .denied) {
      self.showAlertWithSettingsButton()
    }
  }
}
