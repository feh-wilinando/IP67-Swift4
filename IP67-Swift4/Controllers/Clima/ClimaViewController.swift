//
//  ClimaViewController.swift
//  IP67-Swift4
//
//  Created by Nando on 31/12/17.
//  Copyright © 2017 Nando. All rights reserved.
//

import UIKit

class ClimaViewController: UIViewController {

    var contato: Contato?
//    http://api.openweathermap.org/data/2.5/weather?APPID=db6e4ee50071d663e42d3dcf8da8a3d6&units=metric&lat=-23.588806&lon=-46.631484
    private let URL_BASE = "http://api.openweathermap.org/data/2.5/weather"
    private let URL_BASE_IMAGE = "http://openweathermap.org/img/w/"
    
    @IBOutlet weak var condicaoLabel: UILabel!
    @IBOutlet weak var condicaoImageView: UIImageView!
    
    @IBOutlet weak var temperaturaMinimaLabel: UILabel!
    @IBOutlet weak var temperaturaMaximaLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let contato = contato else {
            return
        }
        
        tabBarController?.tabBar.isHidden = true
        
        fetchData(by: contato)
    }
    
    private func fetchData(by contato: Contato) {
        let params = [  "APPID": "db6e4ee50071d663e42d3dcf8da8a3d6",
                        "units": "metric",
                        "lat": "\(contato.latitude ?? 0)",
                        "lon": "\(contato.longitude ?? 0)"
        ]
        
        guard let url = buildURL(baseURL: URL_BASE, params: params) else {
            return
        }
        
        request(for: url) { (data) in
            
            let decoder = JSONDecoder()
            
            do{
               let weather =  try decoder.decode(JsonResponse.self, from: data).unwrapp()
                
                self.fetchImage(icon: weather.icon)
                
                self.condicaoLabel.text = weather.condition
                self.temperaturaMinimaLabel.text = weather.temperature.min.description + "º"
                self.temperaturaMaximaLabel.text = weather.temperature.max.description + "º"
                
                self.condicaoLabel.isHidden = false
                self.temperaturaMaximaLabel.isHidden = false
                self.temperaturaMinimaLabel.isHidden = false
            }catch {
                print(error.localizedDescription)
            }
        }
 
    }
    
    private func fetchImage(icon: String) {
        guard let url = URL(string: URL_BASE_IMAGE + "\(icon).png") else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        request(for: urlRequest) { (data) in
            let image = UIImage(data: data)
            
            self.condicaoImageView.image = image
        }
        
        
    }

    
    private func request(for url:URLRequest, completion: @escaping (Data) -> Void ) {
        let session = URLSession(configuration: .default)
        
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
        
        task.resume()
        
    }
    
    
    private func buildURL(baseURL: String, params: [String:String] ) -> URLRequest?{
        
        guard var urlComponent = URLComponents(string: baseURL) else {
            return nil
        }
     
        urlComponent.queryItems = params.map({ URLQueryItem(name: $0, value: $1)  })
        
        guard let url = urlComponent.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }
}
