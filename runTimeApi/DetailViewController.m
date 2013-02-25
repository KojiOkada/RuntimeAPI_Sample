//
//  DetailViewController.m
//  runTimeApi
//
//  Created by システム管理者 on 12/10/22.
//  Copyright (c) 2012年 koji.Okada. All rights reserved.
//

#import "DetailViewController.h"
#import <objc/runtime.h>
@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [[NSMutableArray alloc]init];
        _dataSource2 = [[NSMutableArray alloc]init];
        _dataSource3 = [[NSMutableArray alloc]init];
        _dataSource4 = [[NSMutableArray alloc]init];
        _dataSource5 = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = _className;
    
    Class cls = NSClassFromString(_className);
    
    Class superClass = class_getSuperclass(cls);
    
    _superClassName = [NSStringFromClass(superClass)retain];
   // DebugLog(@"%@",_superClassName)
    
    //インスタンス変数の一覧を取得
    Ivar* ivarList;
    uint count;
    ivarList = class_copyIvarList(cls, &count);
    
    for(int i=0;i< count;i++){
        
        Ivar ivar;
        ivar = *(ivarList + i);
        
        NSString* name;
        name = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        
        if(name){
            [_dataSource2 addObject:name];
        }
    }
    if(ivarList){
        free(ivarList),ivarList = NULL;
    }
   
    count = 0;
    //クラスメソッド
    Method* clsMethodList;
    clsMethodList = class_copyMethodList(object_getClass(cls), &count);
    
    for(int i =0;i< count;i++){
        Method method;
        method = *(clsMethodList + i);
        
        SEL sel = method_getName(method);
        NSString* name;
        name = NSStringFromSelector(sel);
        
        if(name){
            DebugLog(@"%@",name)
            [_dataSource3 addObject:name];
        }
    }
    
    if(clsMethodList){
        free(clsMethodList),clsMethodList=NULL;
    }
    
    count = 0;
    //インスタンスメソッド
    Method* methodList;
    methodList = class_copyMethodList(cls, &count);
    
    for(int i =0;i< count;i++){
        Method method;
        method = *(methodList + i);
        
        SEL sel = method_getName(method);
        NSString* name;
        name = NSStringFromSelector(sel);
        
        if(name){
            DebugLog(@"%@",name)
            [_dataSource4 addObject:name];
        }
    }

    if(methodList){
        free(methodList),methodList=NULL;
    }
    
    count = 0;
    
    Protocol **protocolList;
    protocolList = class_copyProtocolList(cls, &count);
    
    for(int i =0;i< count;i++){
        Protocol *proto;
        proto= *(protocolList+ i);
        
        NSString* name;
        name = [NSString stringWithCString:protocol_getName(proto) encoding:NSUTF8StringEncoding];
        
        if(name){
            DebugLog(@"%@",name)
            [_dataSource5 addObject:name];
        }
    }
    
    if(protocolList){
        free(protocolList),protocolList=NULL;
    }
    
    [_dataSource sortUsingComparator:^(id obj1,id obj2){
        return [ obj1 compare : obj2];
    }];
    [_dataSource2 sortUsingComparator:^(id obj1,id obj2){
        return [ obj1 compare : obj2];
    }];
    [_dataSource3 sortUsingComparator:^(id obj1,id obj2){
        return [ obj1 compare : obj2];
    }];
    [_dataSource4 sortUsingComparator:^(id obj1,id obj2){
        return [ obj1 compare : obj2];
    }];
    [_dataSource5 sortUsingComparator:^(id obj1,id obj2){
        return [ obj1 compare : obj2];
    }];
    
    
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    _tableView = nil;
    _dataSource = nil;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"親クラス：";
    }else if(section == 1){
        return @"インスタンス変数一覧：";
    }else if(section == 2){
        return @"クラスメソッド一覧";
    }else if(section == 3){
        return @"インスタンスメソッド一覧";
    }else if(section == 4){
        return @"プロトコルの一覧";
    }
     return @"";
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(150.0f, 0.0f, 320.0f, 60.0f)];
//	lbl.backgroundColor = [UIColor clearColor];
//	lbl.textColor = [UIColor whiteColor];
//	lbl.text = @"section title";
//
//    if (section==0) {
//        lbl.text=@"  概要：";
//    }else{
//        lbl.text=@"  品目：";
//    }
//
//	return lbl;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.0f;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if(section == 1){
        return [_dataSource2 count];
    }else if(section == 2){
        return [_dataSource3 count];
    }else if(section == 3){
        return [_dataSource4 count];
    }else if(section == 4){
        return [_dataSource5 count];
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"WishListCell";
    
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int section = indexPath.section;
    if(section == 0){
        cell.textLabel.text = _superClassName;
    }else if(section == 1){
        cell.textLabel.text = [_dataSource2 objectAtIndex:indexPath.row];
    }else if(section == 2){
        cell.textLabel.text = [_dataSource3 objectAtIndex:indexPath.row];
    }else if(section==3){
        cell.textLabel.text = [_dataSource4 objectAtIndex:indexPath.row];
    }else if(section == 4){
        cell.textLabel.text = [_dataSource5 objectAtIndex:indexPath.row];
    }
    
    /* カスタムセルにデータを表示 */
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
	[super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:YES];
	
	//Do not let the user add if the app is in edit mode.
	if(editing)
		self.navigationItem.leftBarButtonItem.enabled = NO;
	else
		self.navigationItem.leftBarButtonItem.enabled = YES;
}
- (void)tableView:(UITableView*)atableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath*)indexPath {
	
    [_tableView beginUpdates];
	if(editingStyle == UITableViewCellEditingStyleDelete){
		//UITableViewCell *headingCell = [atableView cellForRowAtIndexPath:indexPath];
		
        [_dataSource removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
        
	}
	[_tableView endUpdates];
	[_tableView reloadData];
}
@end
