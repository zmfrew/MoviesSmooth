import UIKit

class MovieServiceClient {
    private let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")!
    private let imageURL = URL(string: "http://image.tmdb.org/t/p/w500/")!
    private let downloadQueue = DispatchQueue(label: "downloader", qos: .default)
    
    func getMoviesMatching(text: String, completion: @escaping (([Movie]?) -> Void)) {
        let requestURL = buildQueryFor(baseURL, request: text) ?? baseURL
        
        downloadQueue.async {
            URLSession.shared.dataTask(with: requestURL) { data, _, error in
                if let error = error {
                    print("Error occurred retrieving data: \(error.localizedDescription).")
                    completion([])
                    return
                }
                
                let movies = self.decodeMovies(data)
                completion(movies)
            }.resume()
        }
    }
    
    func getImageFor(movie: Movie, completion: @escaping (UIImage?) -> Void) {
        guard let movieURLAsString = movie.imageURLExtension else { completion(nil); return }
        
        let url = imageURL.appendingPathComponent(movieURLAsString)
        
        downloadQueue.async {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Error occurred retrieving image: \(error.localizedDescription).")
                    completion(nil)
                    return
                }
            
                guard let data = data else { completion(nil); return }
            
                let image = UIImage(data: data)
                completion(image)
            }.resume()
        }
    }
    
    private func buildQueryFor(_ url: URL, request: String) -> URL? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        
        let apiKeyQuery = URLQueryItem(name: QueryItems.api.rawValue, value: ApiConfig.key)
        let languageQuery = URLQueryItem(name: QueryItems.language.rawValue, value: "en-US")
        let movieQuery = URLQueryItem(name: QueryItems.type.rawValue, value: request)
        components.queryItems = [apiKeyQuery, languageQuery, movieQuery]
        
        return components.url
    }
    
    private func decodeMovies(_ data: Data?) -> [Movie]? {
        guard let data = data else { return nil }
    
        do {
            let decoder = JSONDecoder()
            let movieDictionary = try decoder.decode(TopLevelDictionary.self, from: data)
            let movies = movieDictionary.results
            return movies
        } catch {
            print("Error occurred decoding JSON: \(error.localizedDescription).")
            return nil
        }
    }
}

