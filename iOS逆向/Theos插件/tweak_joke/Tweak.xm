// %hook SSTipModel

// - (id)initWithDictionary:(id)arg1 location:(long long)arg2
// {
// 	return nil;
// }

// %end

// %hook EssayDetailTipModel


// - (id)initWithDictionary:(id)arg1 error:(id *)arg2
// {
// 	return nil;
// }

// %end

@interface XZMethodSet 
- (id)listModel;
- (id)dataList;
- (id)refreshView;
- (void)setRefreshView:(id)arg;
@end

%hook EssayFeedListView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSMutableArray *adList = [NSMutableArray array];
	NSMutableArray *dataList = [[self listModel] dataList];

	for (id model in dataList) {
		if ([model isKindOfClass:%c(SSTipModel)]) {
			[adList addObject:model];
		}
	}

	[dataList removeObjectsInArray:adList];

    return %orig;
}

%end

%hook SSCommentListView

- (void)setDetailTipModel:(id)arg
{

}

%end

%hook CategorySelectorButton

- (void)setImageView:(id)arg
{

}

%end

%hook NHHomeMixViewController

- (void)viewWillAppear:(_Bool)arg1
{
	%orig;

	[[self refreshView] removeFromSuperview];
	[self setRefreshView:nil];
}

%end

// 加载动态库时调用这个方法（做一些初始化操作）
%ctor {
	NSLog(@"-----------------ctor--------------------------");
}

// 程序即将结束的时候调用这个方法（做一些收尾操作）
%dtor {
	NSLog(@"-----------------dtor--------------------------");
}

