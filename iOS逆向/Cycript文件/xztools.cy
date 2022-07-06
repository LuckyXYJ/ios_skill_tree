(function(exports) {
	var invalidParamStr = 'Invalid parameter';
	var missingParamStr = 'Missing parameter';

	// app id
	XZAppId = [NSBundle mainBundle].bundleIdentifier;

	// mainBundlePath
	XZAppPath = [NSBundle mainBundle].bundlePath;

	// document path
	XZDocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

	// caches path
	XZCachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]; 

	// 加载系统动态库
	XZLoadFramework = function(name) {
		var head = "/System/Library/";
		var foot = "Frameworks/" + name + ".framework";
		var bundle = [NSBundle bundleWithPath:head + foot] || [NSBundle bundleWithPath:head + "Private" + foot];
  		[bundle load];
  		return bundle;
	};

	// keyWindow
	XZKeyWin = function() {
		return UIApp.keyWindow;
	};

	// 根控制器
	XZRootVc =  function() {
		return UIApp.keyWindow.rootViewController;
	};

	// 找到显示在最前面的控制器
	var _XZFrontVc = function(vc) {
		if (vc.presentedViewController) {
        	return _XZFrontVc(vc.presentedViewController);
	    }else if ([vc isKindOfClass:[UITabBarController class]]) {
	        return _XZFrontVc(vc.selectedViewController);
	    } else if ([vc isKindOfClass:[UINavigationController class]]) {
	        return _XZFrontVc(vc.visibleViewController);
	    } else {
	    	var count = vc.childViewControllers.count;
    		for (var i = count - 1; i >= 0; i--) {
    			var childVc = vc.childViewControllers[i];
    			if (childVc && childVc.view.window) {
    				vc = _XZFrontVc(childVc);
    				break;
    			}
    		}
	        return vc;
    	}
	};

	XZFrontVc = function() {
		return _XZFrontVc(UIApp.keyWindow.rootViewController);
	};

	// 递归打印UIViewController view的层级结构
	XZVcSubviews = function(vc) { 
		if (![vc isKindOfClass:[UIViewController class]]) throw new Error(invalidParamStr);
		return vc.view.recursiveDescription().toString(); 
	};

	// 递归打印最上层UIViewController view的层级结构
	XZFrontVcSubViews = function() {
		return XZVcSubviews(_XZFrontVc(UIApp.keyWindow.rootViewController));
	};

	// 获取按钮绑定的所有TouchUpInside事件的方法名
	XZBtnTouchUpEvent = function(btn) { 
		var events = [];
		var allTargets = btn.allTargets().allObjects()
		var count = allTargets.count;
    	for (var i = count - 1; i >= 0; i--) { 
    		if (btn != allTargets[i]) {
    			var e = [btn actionsForTarget:allTargets[i] forControlEvent:UIControlEventTouchUpInside];
    			events.push(e);
    		}
    	}
	   return events;
	};

	// CG函数
	XZPointMake = function(x, y) { 
		return {0 : x, 1 : y}; 
	};

	XZSizeMake = function(w, h) { 
		return {0 : w, 1 : h}; 
	};

	XZRectMake = function(x, y, w, h) { 
		return {0 : XZPointMake(x, y), 1 : XZSizeMake(w, h)}; 
	};

	// 递归打印controller的层级结构
	XZChildVcs = function(vc) {
		if (![vc isKindOfClass:[UIViewController class]]) throw new Error(invalidParamStr);
		return [vc _printHierarchy].toString();
	};

	


	// 递归打印view的层级结构
	XZSubviews = function(view) { 
		if (![view isKindOfClass:[UIView class]]) throw new Error(invalidParamStr);
		return view.recursiveDescription().toString(); 
	};

	// 判断是否为字符串 "str" @"str"
	XZIsString = function(str) {
		return typeof str == 'string' || str instanceof String;
	};

	// 判断是否为数组 []、@[]
	XZIsArray = function(arr) {
		return arr instanceof Array;
	};

	// 判断是否为数字 666 @666
	XZIsNumber = function(num) {
		return typeof num == 'number' || num instanceof Number;
	};

	var _XZClass = function(className) {
		if (!className) throw new Error(missingParamStr);
		if (XZIsString(className)) {
			return NSClassFromString(className);
		} 
		if (!className) throw new Error(invalidParamStr);
		// 对象或者类
		return className.class();
	};

	// 打印所有的子类
	XZSubclasses = function(className, reg) {
		className = _XZClass(className);

		return [c for each (c in ObjectiveC.classes) 
		if (c != className 
			&& class_getSuperclass(c) 
			&& [c isSubclassOfClass:className] 
			&& (!reg || reg.test(c)))
			];
	};

	// 打印所有的方法
	var _XZGetMethods = function(className, reg, clazz) {
		className = _XZClass(className);

		var count = new new Type('I');
		var classObj = clazz ? className.constructor : className;
		var methodList = class_copyMethodList(classObj, count);
		var methodsArray = [];
		var methodNamesArray = [];
		for(var i = 0; i < *count; i++) {
			var method = methodList[i];
			var selector = method_getName(method);
			var name = sel_getName(selector);
			if (reg && !reg.test(name)) continue;
			methodsArray.push({
				selector : selector, 
				type : method_getTypeEncoding(method)
			});
			methodNamesArray.push(name);
		}
		free(methodList);
		return [methodsArray, methodNamesArray];
	};

	var _XZMethods = function(className, reg, clazz) {
		return _XZGetMethods(className, reg, clazz)[0];
	};

	// 打印所有的方法名字
	var _XZMethodNames = function(className, reg, clazz) {
		return _XZGetMethods(className, reg, clazz)[1];
	};

	// 打印所有的对象方法
	XZInstanceMethods = function(className, reg) {
		return _XZMethods(className, reg);
	};

	// 打印所有的对象方法名字
	XZInstanceMethodNames = function(className, reg) {
		return _XZMethodNames(className, reg);
	};

	// 打印所有的类方法
	XZClassMethods = function(className, reg) {
		return _XZMethods(className, reg, true);
	};

	// 打印所有的类方法名字
	XZClassMethodNames = function(className, reg) {
		return _XZMethodNames(className, reg, true);
	};

	// 打印所有的成员变量
	XZIvars = function(obj, reg){ 
		if (!obj) throw new Error(missingParamStr);
		var x = {}; 
		for(var i in *obj) { 
			try { 
				var value = (*obj)[i];
				if (reg && !reg.test(i) && !reg.test(value)) continue;
				x[i] = value; 
			} catch(e){} 
		} 
		return x; 
	};

	// 打印所有的成员变量名字
	XZIvarNames = function(obj, reg) {
		if (!obj) throw new Error(missingParamStr);
		var array = [];
		for(var name in *obj) { 
			if (reg && !reg.test(name)) continue;
			array.push(name);
		}
		return array;
	};
})(exports);