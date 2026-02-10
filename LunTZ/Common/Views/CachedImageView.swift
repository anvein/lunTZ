import UIKit

final class CachedImageView: UIView {

    private let placeholderImage: UIImage?

    // MARK: - Subviews

    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Properties

    private var currentTask: Task<Void, Never>?
    private static let cacheFolderName = "ImageCache"

    // MARK: - Init

    init(placeholderImage: UIImage? = .init(systemName: "person.circle.fill")) {
        self.placeholderImage = placeholderImage
        super.init(frame: .zero)
        setupHierarchy()
        setupView()
    }

    required init?(coder: NSCoder) {
        self.placeholderImage = UIImage(systemName: "person.circle.fill")
        super.init(coder: coder)
        setupHierarchy()
        setupView()
    }

    // MARK: - Setup

    private func setupHierarchy() {
        addSubviews(imageView, activityIndicator)
    }

    private func setupView() {
        imageView.frame = bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        activityIndicator.center = center
        activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin,
                                              .flexibleTopMargin, .flexibleBottomMargin]
        activityIndicator.hidesWhenStopped = true
    }

    // MARK: - Public

    func loadImage(from url: URL?) {
        currentTask?.cancel()

        guard let url else {
            imageView.image = placeholderImage
            activityIndicator.stopAnimating()
            return
        }

        if let cachedImage = loadImageFromCache(url: url) {
            imageView.image = cachedImage
            activityIndicator.stopAnimating()
            return
        }

        activityIndicator.startAnimating()
        currentTask = Task {
            await downloadImage(url: url)
        }
    }

    func resetLoadingImage() {
        imageView.image = placeholderImage
        activityIndicator.stopAnimating()
        currentTask?.cancel()
        currentTask = nil
    }

    // MARK: - Cache

    private func cacheFolderURL() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let folderURL = paths[0].appendingPathComponent(Self.cacheFolderName)
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }
        return folderURL
    }

    private func cacheFileURL(for url: URL) -> URL {
        let fileName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        return cacheFolderURL().appendingPathComponent(fileName)
    }

    private func saveImageToCache(_ image: UIImage, url: URL) {
        guard let data = image.pngData() else { return }
        try? data.write(to: cacheFileURL(for: url))
    }

    private func loadImageFromCache(url: URL) -> UIImage? {
        let fileURL = cacheFileURL(for: url)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }

    // MARK: - Download

    private func downloadImage(url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw NSError(domain: "InvalidImageData", code: 0)
            }

            saveImageToCache(image, url: url)

            Task { @MainActor [weak self] in
                self?.currentTask = nil
                self?.imageView.image = image
                self?.activityIndicator.stopAnimating()
            }

        } catch {
            Task { @MainActor [weak self] in
                self?.currentTask = nil
                self?.imageView.image = self?.placeholderImage
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
