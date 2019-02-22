import UIKit

class MoviesListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let cellIdentifier = "movieCell"
    private let movieServiceClient = MovieServiceClient()
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            guard let detailVC = segue.destination as? MovieDetailViewController, let indexPath = tableView.indexPathForSelectedRow, let cell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell else { return }
            
            let movie = movies[indexPath.row]
            detailVC.movie = movie
            detailVC.movieImage = cell.movieImageView?.image
            detailVC.title = movie.title
        }
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = movies[indexPath.row]
        cell.movie = movie
        return cell
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty, searchText != " " else { return }
        searchBar.resignFirstResponder()
        
        movieServiceClient.getMoviesMatching(text: searchText) { movies in
            guard let movies = movies else { return }
    
            self.movies = movies
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let index = movies.index(of: movies[indexPath.row]) else { return }

            movies.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
