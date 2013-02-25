//
//  ViewController.m
//  runTimeApi
//
//  Created by システム管理者 on 12/10/22.
//  Copyright (c) 2012年 koji.Okada. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Classes";
	_dataSource = [[NSMutableArray alloc]init];
    
    int numClasses;
    
    numClasses = objc_getClassList(NULL, 0);
    if(numClasses > 0){
        
        Class *cls;
        cls = malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(cls, numClasses);
        
        
        int i;
        
        for(i=0;i< numClasses;i++){
            
            Class klass;
            klass = *(cls + i);
            
            NSString* className;
            className = [NSString stringWithCString:class_getName(klass) encoding:NSUTF8StringEncoding];
            
            if(className){
                [_dataSource addObject:className];
            }
            
        }
        
        free(cls),cls = NULL;
    }
    [_dataSource sortUsingComparator:^(id obj1,id obj2){
        
        //比較の実行
        NSComparisonResult result = [ obj1 compare : obj2];        
        return result;
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
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return @"概要：";
//    }
//    return @"品目：";
//}

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
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"WishListCell";
    
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString* name = [_dataSource objectAtIndex:indexPath.row];
    //NSLog(@"%@",name);
    cell.textLabel.text = name;
    
    /* カスタムセルにデータを表示 */
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *className = [_dataSource objectAtIndex:indexPath.row];
    DetailViewController* viewController = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    viewController.className = className;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
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
