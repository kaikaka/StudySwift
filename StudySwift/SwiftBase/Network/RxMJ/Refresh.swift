//
//  Refresh.swift
//  StudySwift
//
//  Created by Yoon on 2020/03/11.
//  Copyright © 2020 Fooww. All rights reserved.
//

import MJRefresh

extension UIScrollView {

    public var refreshHeader: MJRefreshHeader? {
        get { return mj_header }
        set { mj_header = newValue }
    }

    public var refreshFooter: MJRefreshFooter? {
        get { return mj_footer }
        set { mj_footer = newValue }
    }

    public var isTotalDataEmpty: Bool {
        return mj_totalDataCount() == 0
    }
}

public class RefreshHeader: MJRefreshGifHeader {

    /// 初始化
    override public func prepare() {
        super.prepare()
        self.lastUpdatedTimeLabel?.isHidden = true
        self.setTitle("松开立即加载", for: MJRefreshState.pulling)
        self.setTitle("加载数据...", for: MJRefreshState.refreshing)
    }
}

public class RefreshFooter: MJRefreshAutoStateFooter {
    /// 初始化
    override public func prepare() {
        super.prepare()
        
        triggerAutomaticallyRefreshPercent = 0.5
        self.setTitle("松开立即加载", for: MJRefreshState.pulling)
        self.setTitle("加载数据...", for: MJRefreshState.refreshing)
    }
}
