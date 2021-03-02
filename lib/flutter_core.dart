library flutter_core;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:auto_route/auto_route.dart';

// 统一依赖第三方库
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:provider/provider.dart';
export 'package:flutter_easyrefresh/easy_refresh.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:smooth_star_rating/smooth_star_rating.dart';
export 'package:dio/dio.dart';
export 'package:auto_route/auto_route.dart';
export 'package:auto_route/auto_route_annotations.dart';

// 基类模块
part 'base/function/base_function.dart';
part 'base/function/navigator_manager.dart';
part 'base/function/life_circle.dart';
part 'base/base_page.dart';
part 'base/base_scaffold.dart';
part 'base/base_components.dart';
part 'base/base_fragment.dart';

// 工具模块
part 'util/storage.dart';
part 'util/log_util.dart';
part 'util/data_util.dart';

// 网络请求模块
part 'net/http.dart';
part 'net/http_controller.dart';
part 'net/interceptor_log.dart';
part 'net/interceptor_connection_status.dart';
part 'net/exception_net.dart';

// 常用控件模块
part 'widgets/popup/message_dialog.dart';
part 'widgets/popup/show_toast.dart';
part 'widgets/filter/filter_bar.dart';
part 'widgets/filter/filter_condition_model.dart';
part 'widgets/filter/filter_controller.dart';
part 'widgets/filter/filter_menu.dart';
part 'widgets/filter/filter_menu_expand_with_animation.dart';
part 'widgets/filter/filter_menu_item_widget.dart';
part 'widgets/form/component/bottom_bar_row.dart';
part 'widgets/form/component/edit_row.dart';
part 'widgets/form/component/form_widgets.dart';
part 'widgets/form/component/image_picker_row.dart';
part 'widgets/form/component/multi_choice_bottom_sheet.dart';
part 'widgets/form/component/range_edit_row.dart';
part 'widgets/form/component/rate_row.dart';
part 'widgets/form/component/select_row.dart';
part 'widgets/form/component/single_checkbox_row.dart';
part 'widgets/refresh/base_page_request.dart';
part 'widgets/refresh/base_page_response.dart';
part 'widgets/refresh/refresh_list.dart';
part 'widgets/refresh/search_choice_item_model.dart';
part 'widgets/refresh/search_item_interface.dart';
part 'widgets/refresh/search_refresh_list.dart';
part 'widgets/refresh/search_refresh_list_multi_choice.dart';

// 项目配置模块
part 'config/global.dart';
part 'config/config.dart';
part 'configuration.dart';
