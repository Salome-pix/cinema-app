//
//  APICaller.swift
//  VuduTV
//
//  Created by Mcbook Pro on 03.09.22.
//

import Foundation
struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyBVXVrciH8ihWsJb8L35LxHJFdYuJpFqe8"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}


class APICaller {
    
    static let shared = APICaller()
    
    func getTrendingMovies(complition: @escaping (Result<[Title], Error>)->Void){
        guard let url = URL(string:"https://api.themoviedb.org/3/trending/movie/day?api_key=d8d40707712f37c88cbdf6475a093910") else {return}
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do{
                let resuls = try JSONDecoder().decode(TrendingTitleResponse.self , from: data)
                complition(.success(resuls.results))
            }catch{
                complition(.failure(error))
            }
        }.resume()
    }
    
    func getTrendingTVs(complition: @escaping (Result<[Title], Error>)->Void) {
        guard let url = URL(string:"https://api.themoviedb.org/3/trending/tv/day?api_key=d8d40707712f37c88cbdf6475a093910") else {return}
        
        URLSession.shared.dataTask(with: url) { data, _ , error in
            
            guard let data = data, error == nil else { return }
            
            do{
                let resuls = try JSONDecoder().decode(TrendingTitleResponse.self , from: data)
                complition(.success(resuls.results))
            }catch{
                complition(.failure(error))
            }
        }.resume()
    }
    func getPopular(complition: @escaping (Result<[Title], Error>)->Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=d8d40707712f37c88cbdf6475a093910") else {return}
        URLSession.shared.dataTask(with: url) { data, _ , error in
            
            guard let data = data, error == nil else { return }
            
            do{
                let resuls = try JSONDecoder().decode(TrendingTitleResponse.self , from: data)
                complition(.success(resuls.results))
            }catch{
                complition(.failure(error))
            }
        }.resume()
    }
    
    func getUpcommingMovies(complition: @escaping (Result<[Title], Error>)->Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=d8d40707712f37c88cbdf6475a093910") else {return}
        URLSession.shared.dataTask(with: url) { data, _ , error in
            
            guard let data = data, error == nil else { return }
            
            do{
                let resuls = try JSONDecoder().decode(TrendingTitleResponse.self , from: data)
                complition(.success(resuls.results))
            }catch{
                complition(.failure(error))
            }
        }.resume()
    }
    
 
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=d8d40707712f37c88cbdf6475a093910") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=d8d40707712f37c88cbdf6475a093910&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                completion(.success(results.items[0]))
                

            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
}
