
import UIKit
import MonkeyKing

class AlipayViewController: UIViewController {
    
    @IBOutlet private var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        let account = MonkeyKing.Account.alipay(appID: Configs.Alipay.appID)
        MonkeyKing.registerAccount(account)
    }

    // MARK: Share

    @IBAction func shareTextToAlipay(_ sender: UIButton) {
        let info = MonkeyKing.Info(
            title: "Friends Text, \(UUID().uuidString)",
            description: nil,
            thumbnail: nil,
            media: nil
        )
        shareInfo(info)
    }

    @IBAction func shareImageToAlipay(_ sender: UIButton) {
        let info = MonkeyKing.Info(
            title: nil,
            description: nil,
            thumbnail: nil,
            media: .image(UIImage(named: "rabbit")!)
        )
        shareInfo(info)
    }

    @IBAction func shareURLToAlipay(_ sender: UIButton) {
        let info = MonkeyKing.Info(
            title: "Friends URL, \(UUID().uuidString)",
            description: "Description URL, \(UUID().uuidString)",
            thumbnail: UIImage(named: "rabbit"),
            media: .url(URL(string: "http://soyep.com")!)
        )
        shareInfo(info)
    }

    private func shareInfo(_ info: MonkeyKing.Info) {
        var message: MonkeyKing.Message?
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            message = MonkeyKing.Message.alipay(.friends(info: info))
        case 1:
            guard info.media != nil else {
                print("目前支付宝生活圈还不支持纯文本的分享")
                break
            }
            message = MonkeyKing.Message.alipay(.timeline(info: info))
        default:
            break
        }
        if let message = message {
            MonkeyKing.deliver(message) { result in
                print("result: \(result)")
            }
        }
    }

    // MARK: Pay

    @IBAction func pay(_ sender: UIButton) {
        do {
            let data = try NSURLConnection.sendSynchronousRequest(URLRequest(url: URL(string: "http://www.example.com/pay.php?payType=alipay")!), returning: nil)
            let urlString = String(data: data, encoding: .utf8)!
            let order = MonkeyKing.Order.alipay(urlString: urlString, scheme: nil)
            MonkeyKing.deliver(order) { result in
                print("result: \(result)")
            }
        } catch {
            print(error)
        }
    }
}
