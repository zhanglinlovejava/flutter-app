class API {
  static const String HOME_TAB = 'v7/index/tab/list'; //主页tab
  static const String COMMUNITY_TAB = 'v7/community/tab/list'; //社区tab
//  static final String DAILY_LIST = 'v5/index/tab/feed'; //日报
//  static final String DISCOVERY_LIST = 'v5/index/tab/discovery'; //发现
//  static final String FOLLOW_LIST = 'v6/community/tab/follow'; //关注
//  static final String RECOMMEND_LIST = 'v5/index/tab/allRec'; //推荐
//  static final String CATEGORY_LIST = 'v5/index/tab/category'; //通用类
  static const String MESSAGE_LIST = 'v3/messages'; //消息
  static const String INTERACT_LIST = 'v5/discovery/myMessage'; //互动

  static const String VIDEO_RELATED_LIST = 'v4/video/related'; //视频相关列表

//个人信息
  static const String USER_TABS = 'v5/userInfo/tab'; //个人 tab list //id, userType
  static const String ALL_PGC = 'v4/pgcs/all'; //全部作者
  static const String MY_FOLLOW= 'v2/follow/newlist'; //我的关注 tab ?uid
  static const String MY_MEDALS= 'v6/medal/tag/medals'; //我的徽章   ?uid
//搜索
  static const String SEARCH = 'v3/search'; //search //query
  static const String SEARCH_HOT = 'v3/queries/hot'; //hot
  static const String SEARCH_PER = 'v3/search/preSearch'; //pre search //query
  static const String SEARCH_ALL_USER =
      'v3/search/showAllUserOrAuthor'; //显示所有用户

  static const String TAG_INFO_TAB = 'v6/tag/index'; //taginfo  tab id
  //分类
  static const String CATEGORY_INFO_TAB =
      'v4/categories/detail/tab'; //分类详情  tab id=871
  static const String CATEGORY_ALL = 'v4/categories/all'; //全部分类

//专题
  static const String SPECIAL_TOPIC_ALL = 'v3/specialTopics'; //专题
  static const String LIGHT_TOPIC_ALL = 'v3/lightTopics/internal'; //专题  /407

  static const String RANK_LIST = 'v4/rankList'; //排行榜 tab
  static const String MESSAGE_TAB = 'v3/messages/tabList'; //消息tab
  static const String VIDEO_DETAIL = 'v2/video'; //视频详情  /147228

}
