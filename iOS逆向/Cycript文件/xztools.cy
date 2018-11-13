(function(exports) {
    
    // app id
	XZAppId = [NSBundle mainBundle].bundleIdentifier;

	// mainBundlePath
	XZAppPath = [NSBundle mainBundle].bundlePath;

	// document path
	XZDocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

	// caches path
	XZCachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]; 


})(exports);