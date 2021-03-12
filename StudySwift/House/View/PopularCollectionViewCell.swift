//
//  PopularCollectionViewCell.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/12.
//

import Kingfisher
import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    var palyBtn: UIButton!
    var titleLab: UILabel!
    var img: UIImageView!
    var bgView: CALayer!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.cornerRadius = 3
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeUI() {
        bgView = CALayer()

        bgView.frame = CGRect(x: 0, y: 0, width: (screen_Width - 25) / 2, height: height)
        contentView.layer.addSublayer(bgView)

        img = UIImageView(frame: CGRect(x: 0, y: 0, width: (screen_Width - 25) / 2, height: height - 30))
        bgView.addSublayer(img.layer)

        titleLab = UILabel(frame: CGRect(x: 0, y: height - 30, width: (screen_Width - 25) / 2, height: 30))
        bgView.addSublayer(titleLab.layer)

        palyBtn = UIButton(frame: CGRect(x: (screen_Width - 25) / 2 - 80, y: 30, width: 40, height: 40))
        img.addSubview(palyBtn)
    }

    public var item: HomePopularItem? {
        didSet {
            guard let item = item else { return }
            if item.entry?.content?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
                titleLab.text = "暂无标题"
            } else {
                titleLab.text = item.entry?.content?.trimmingCharacters(in: .whitespaces)
            }
            if !(item.entry?.gif?.isEmpty ?? true) {
                let urls = item.entry?.gif?.components(separatedBy: "?")
                let url = URL(string: urls?.first ?? "")
//                img.image = UIImage.gifImageWithURL(gifUrl: url!.absoluteString) 
                img.kf.setImage(with: url)
            } else if !(item.entry?.photo?.isEmpty ?? true) {
                let urls = item.entry?.photo?.components(separatedBy: "?")
                let url = URL(string: urls?.first ?? "")
                img.kf.setImage(with: url)
            } else {
                /// 占位图
            }

            palyBtn.isHidden = (item.entry?.video?.isEmpty ?? true)
            /// 更新约束
            let h:CGFloat = item.entry?.itemHeight ?? 200.0
            img.frame = CGRect(x: 0, y: 0, width: (screen_Width - 25) / 2, height: h - 30)
            titleLab.frame = CGRect(x: 0, y: h - 30, width: (screen_Width - 25) / 2, height: 30)
        }
    }
}
