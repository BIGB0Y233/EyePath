import CoreImage

class FrameModel: ObservableObject {
  @Published var error: Error?
  @Published var frame: CGImage?

  var comicFilter = false
  var monoFilter = false
  var crystalFilter = false

  private let context = CIContext()

  private let cameraManager = CameraManager.shared
  private let frameManager = FrameManager.shared

  init() {
    setupSubscriptions()
  }

  func setupSubscriptions() {
    // swiftlint:disable:next array_init
    cameraManager.configure()
    cameraManager.$error
      .receive(on: RunLoop.main)
      .map { $0 }
      .assign(to: &$error)

    frameManager.$current
      .receive(on: RunLoop.main)
      .compactMap { buffer in
        guard let image = CGImage.create(from: buffer) else {
          return nil
        }
        return image
      }
      .assign(to: &$frame)
  }
  
  func stopSubscriptions(){
      cameraManager.stopCapture()
  }
}
