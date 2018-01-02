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
            
            guard let json = try! JSONSerialization.jsonObject(with: data, options:[]) as? [String: AnyObject] else {
                return
            }
            
            
            let main = json["main"] as! [String:AnyObject]
            let weather = json["weather"] as! [[String:AnyObject]]
            let temp_min = main["temp_min"] as! Double
            let temp_max = main["temp_max"] as! Double
            let icon = weather[0]["icon"] as! String
            let condicao = weather[0]["main"] as! String
            
            self.fetchImage(icon: icon)
            
            self.condicaoLabel.text = condicao
            self.temperaturaMinimaLabel.text = temp_min.description + "º"
            self.temperaturaMaximaLabel.text = temp_max.description + "º"
        
            self.condicaoLabel.isHidden = false
            self.temperaturaMaximaLabel.isHidden = false
            self.temperaturaMinimaLabel.isHidden = false
            
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
