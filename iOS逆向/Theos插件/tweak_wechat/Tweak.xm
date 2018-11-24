
    
#define XZDefaults [NSUserDefaults standardUserDefaults]
#define XZAutoKey @"xz_auto_key"
#define XZFile(path) @"/Library/PreferenceLoader/Preferences/XZWeChat/" #path

%hook FindFriendEntryViewController

// 一共有多少组
- (long long)numberOfSectionsInTableView:(id)tableView
{
	return %orig + 1;
}

// 每一组有多少行
- (long long)tableView:(id)tableView numberOfRowsInSection:(long long)section
{
	if (section == [self numberOfSectionsInTableView:tableView] - 1) {
		return 2;
	} else {
		return %orig;
	}
}

// 监听自动抢红包的开关(新方法需要添加%new)
%new
- (void)xz_autoChange:(UISwitch *)switchView
{
	[XZDefaults setBool:switchView.isOn forKey:XZAutoKey];
	[XZDefaults synchronize];
}

// 返回每一行的cell
- (id)tableView:(id)tableView cellForRowAtIndexPath:(id)indexPath
{
	if ([indexPath section] != 
		[self numberOfSectionsInTableView:tableView] - 1) {
		return %orig;
	}


	// 最后一组cell的公共代码
	NSString *cellId = ([indexPath row] == 1) ? @"exitCellId" : @"autoCellId";
	UITableViewCell *cell = [tableView 
			dequeueReusableCellWithIdentifier:cellId];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] 
				initWithStyle:UITableViewCellStyleDefault 
				reuseIdentifier:cellId];
		cell.backgroundColor = [UIColor whiteColor];
		// 图片
		cell.imageView.image = [UIImage imageWithContentsOfFile:XZFile(skull.png)];
	}

	// 最后一组cell的具体代码
	if ([indexPath row] == 0) {
		cell.textLabel.text = @"自动抢红包";

		// 开关
		UISwitch *switchView = [[UISwitch alloc] init];
		switchView.on = [XZDefaults boolForKey:XZAutoKey];
    	[switchView addTarget:self 
    		action:@selector(xz_autoChange:) 
    		forControlEvents:UIControlEventValueChanged];
		cell.accessoryView = switchView;
	} else if ([indexPath row] == 1) {
		cell.textLabel.text = @"退出微信";
	}


	return cell;
}

// 每一行的高度
- (double)tableView:(id)tableView heightForRowAtIndexPath:(id)indexPath
{
	if ([indexPath section] != 
		[self numberOfSectionsInTableView:tableView] - 1) {
		return %orig;
	}

	return 44;
}

// 点击的监听
- (void)tableView:(id)tableView didSelectRowAtIndexPath:(id)indexPath
{
	if ([indexPath section] != 
		[self numberOfSectionsInTableView:tableView] - 1) {
		%orig;
		return;
	}

	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if ([indexPath row] == 1) {
		// exit(0);
		// 终止进程
		abort();
	}
}

%end