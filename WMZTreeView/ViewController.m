//
//  ViewController.m
//  WMZTree
//
//  Created by wmz on 2019/10/17.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "ViewController.h"
#import "WMZTreeView.h"
#import "WMZMyCell.h"
@interface ViewController ()
@property(nonatomic,strong)WMZTreeView *treeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = @{
        @(1):@"firstDemo",
        @(2):@"secondDemo",
        @(3):@"thirdDemo",
        @(4):@"fourDemo",
        @(5):@"fiveDemo",
        @(6):@"sixDemo",
        @(7):@"sevenDemo",
    };
    if (self.type) {
        [self performSelector:NSSelectorFromString(dic[@(self.type)]) withObject:nil afterDelay:0.01];
    }

}

//全部属性
- (void)all{
        WMZTreeViewParam *param =
        TreeViewParam()
        .wDataSet([self randomArr:20 level:3])
    //    .wDataSet([self jsonData])
        //数据为空时的占位图
        .wEmptyDataSet(@{@"name":@"暂无数据",@"image":@"default_maintenance"})
        //frame
        .wFrameSet(CGRectMake(0, TreeNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-TreeNavBarHeight))
        //缩进距离
        .wIndentSet(2)
        //手风琴效果 同级只展开一级
        .wAccordionSet(NO)
        //可勾选
        .wShowCheckboxSet(YES)
        //隐藏展开图标
        .wHideExpanIconSet(NO)
        //节点字体font
        .wNodeTextFontSet(15.0f)
        //节点字体颜色
        .wNodeTextColorSet([UIColor blackColor])
        //节点字体高亮颜色
        .wHighlightCurrentSet(TreeColor(0x1d76db))
        //默认勾选
        .wDefaultExpandedKeysSet(@[@"1_2_1",@"2"])
        //父节点和子节点 勾选关联
        .wCheckStrictlySet(YES)
        //默认展开全部
        .wDefaultExpandAllSet(YES)
        //拖拽
        .wDraggableSet(NO)
        //节点点击事件
        .wEventNodeClickSet(^(id node) {
            NSLog(@"%@被点击",node);
        })
        //节点勾选状态切换事件
        .wEventCheckChangeSet(^(id node, BOOL isSelect) {
            NSLog(@"节点切换 %@ , %d",node,isSelect);
        })
        //自定义节点内容
        .wEventTreeCellSet(^UITableViewCell *(id model, NSIndexPath *path,UITableView *table,id param) {
            WMZMyCell *cell = [table dequeueReusableCellWithIdentifier:@"WMZMyCell"];
            if (!cell) {
                cell = [[WMZMyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMZMyCell" parentModel:param];
            }
            cell.model = model;
            return cell;
        })
        //自定义节点高度
        .wEventCellHeightSet(^CGFloat(id model, NSIndexPath *path, UITableView *table) {
            return 50;
        })
        //自定义节点用户交互
        .wEventCellUserEnabledSet(^(id model, NSIndexPath *path, UITableView *table,id userInfo) {

        })
        //节点拖拽完成
        .wEventNodeDraggableSet(^(NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath, UITableView *table) {
            
        });
        self.treeView = [[WMZTreeView alloc]initWithParam:param];
        [self.view addSubview:self.treeView];
}


//正常多叉树显示
- (void)firstDemo{
    WMZTreeViewParam *param =TreeViewParam()
    .wFrameSet(CGRectMake(0, TreeNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-TreeNavBarHeight))
    .wDataSet([self randomArr:100 level:10]);
    self.treeView = [[WMZTreeView alloc]initWithParam:param];
    [self.view addSubview:self.treeView];
}

//可选中树形+选中高亮显示
- (void)secondDemo{
    WMZTreeViewParam *param =TreeViewParam()
    .wDataSet([self randomArr:10 level:5])
    .wFrameSet(CGRectMake(0, TreeNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-TreeNavBarHeight))
    //节点字体高亮颜色
    .wHighlightCurrentSet(TreeColor(0x1d76db))
    //可勾选
    .wShowCheckboxSet(YES);
    self.treeView = [[WMZTreeView alloc]initWithParam:param];
    [self.view addSubview:self.treeView];
}

//自定义节点内容+增删节点
- (void)thirdDemo{
    __weak ViewController *weakSelf = self;
    WMZTreeViewParam *param =TreeViewParam()
    .wFrameSet(CGRectMake(0, TreeNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-TreeNavBarHeight))
    .wDataSet([self randomArr:10 level:5])
    //自定义节点内容
    .wEventTreeCellSet(^UITableViewCell *(id model, NSIndexPath *path,UITableView *table,id param) {
        WMZMyCell *cell = [table dequeueReusableCellWithIdentifier:@"WMZMyCell"];
        if (!cell) {
            cell = [[WMZMyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMZMyCell" parentModel:param];
        }
        cell.model = model;
        return cell;
    })
    //自定义节点用户交互
    .wEventCellUserEnabledSet(^(id model, NSIndexPath *path, UITableView *table,id userInfo) {
        [weakSelf  dealModel:model path:path userInfo:userInfo];
    });
    self.treeView = [[WMZTreeView alloc]initWithParam:param];
    [self.view addSubview:self.treeView];
}

//手风琴效果+指定层级可勾选(这里选取3层 指定第三层可选)
- (void)fourDemo{
    NSArray *data = @[
        TreeParam().currentIdSet(@"1").nameSet(@"第1_0级").canSelectSet(NO),
        TreeParam().currentIdSet(@"2").nameSet(@"第1_1级").canSelectSet(NO),
        TreeParam().currentIdSet(@"3").nameSet(@"第1_2级").canSelectSet(NO),
        TreeParam().currentIdSet(@"11").nameSet(@"第2_11级").parentIdSet(@"1").canSelectSet(NO),
        TreeParam().currentIdSet(@"22").nameSet(@"第2_22级").parentIdSet(@"2").canSelectSet(NO),
        TreeParam().currentIdSet(@"33").nameSet(@"第2_22级").parentIdSet(@"3").canSelectSet(NO),
        //第三层可选
        TreeParam().currentIdSet(@"111").nameSet(@"第3_111级").parentIdSet(@"11"),
        TreeParam().currentIdSet(@"222").nameSet(@"第3_222级").parentIdSet(@"22"),
        TreeParam().currentIdSet(@"333").nameSet(@"第3_333级").parentIdSet(@"33"),
    ];
    WMZTreeViewParam *param =TreeViewParam()
    .wFrameSet(CGRectMake(0, TreeNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-TreeNavBarHeight))
    .wDataSet(data)
    //可勾选
    .wShowCheckboxSet(YES)
    //手风琴效果
    .wAccordionSet(YES);
    self.treeView = [[WMZTreeView alloc]initWithParam:param];
    [self.view addSubview:self.treeView];
}

//勾选不关联父节点和子节点+默认选中+默认全部展开
- (void)fiveDemo{
    WMZTreeViewParam *param =TreeViewParam()
    .wDataSet(([self randomArr:10 level:5]))
    .wFrameSet(CGRectMake(0, TreeNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-TreeNavBarHeight))
    //默认全部展开
    .wDefaultExpandAllSet(YES)
    //不关联父节点和子节点
    .wCheckStrictlySet(NO)
    //可勾选
    .wShowCheckboxSet(YES)
    //默认选中
    .wDefaultExpandedKeysSet(@[@"5",@"8"]);
    self.treeView = [[WMZTreeView alloc]initWithParam:param];
    [self.view addSubview:self.treeView];
}

//开启拖拽
- (void)sixDemo{
    WMZTreeViewParam *param =TreeViewParam()
    .wFrameSet(CGRectMake(0, TreeNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-TreeNavBarHeight))
    .wDefaultExpandAllSet(YES)
    .wDataSet([self randomArr:10 level:5]);
    
    self.treeView = [[WMZTreeView alloc]initWithParam:param];
    [self.view addSubview:self.treeView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:TreeColor(0xF4606C) forState:UIControlStateNormal];
    [btn setTitle:@"开启拖拽" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barItem;
}

//传字典数据
- (void)sevenDemo{
    WMZTreeViewParam *param =TreeViewParam()
    .wFrameSet(CGRectMake(0, TreeNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-TreeNavBarHeight))
    .wShowCheckboxSet(YES)
    .wDataSet([self jsonData]);
    self.treeView = [[WMZTreeView alloc]initWithParam:param];
    [self.view addSubview:self.treeView];
}

//增删数据
- (void)dealModel:(id)model path:(NSIndexPath*)path userInfo:(id)userInfo{
    if ([userInfo isEqualToString:@"add"]) {
         WMZTreeParam *param = model;
        __weak ViewController *weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入节点" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"追加子节点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *idText = alertController.textFields[0];
            UITextField *nameText = alertController.textFields[1];
            WMZTreeParam *node =  TreeParam().currentIdSet(idText.text).nameSet(nameText.text).parentIdSet(param.currentId);
            [weakSelf.treeView append:param.currentId node:node];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"追加节点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *idText = alertController.textFields[0];
            UITextField *nameText = alertController.textFields[1];
            WMZTreeParam *node =  TreeParam().currentIdSet(idText.text).nameSet(nameText.text).parentIdSet(param.parentId);
            [weakSelf.treeView insertAfter:param.currentId node:node];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
            textField.placeholder=@"请输入节点唯一currentId";
        }];
                   
        [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
            textField.placeholder=@"请输入节点name";
        }];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if ([userInfo isEqualToString:@"delete"]){
        WMZTreeParam *param = model;
        [self.treeView remove:param.currentId];
    }
}

//随机多少级 每级多少条数据
- (NSArray*)randomArr:(int)num level:(int)level{
    NSMutableArray *arr = [NSMutableArray new];
    NSArray *firstId = @[@"0",@"1",@"2"];
    //第一级
    for (int i = 0; i<firstId.count; i++) {
        NSString *str = [NSString stringWithFormat:@"第1_%d级",i];
        [arr addObject:TreeParam().currentIdSet(firstId[i]).nameSet(str)];
    }
    NSInteger index = 1;
    NSInteger fitstIndex = firstId.count;
    NSInteger endIndex = num+3;
    NSArray *tempArr = [NSArray new];
    while (index<level) {
        NSArray *dataArr = [NSArray arrayWithArray:tempArr.count?tempArr:firstId];
        index+=1;
         NSMutableArray *secondId = [NSMutableArray new];
          for (NSInteger i = fitstIndex; i<endIndex; i++) {
               int y =(arc4random() % (dataArr.count));
               NSString *str = [NSString stringWithFormat:@"第%ld_%ld级",index,i];
               NSString *currentID = [NSString stringWithFormat:@"%ld",i];
               [secondId addObject:currentID];
               WMZTreeParam *param = TreeParam().currentIdSet(currentID).parentIdSet(dataArr[y]).nameSet(str);
               [arr addObject:param];
        }
        fitstIndex = num*index;
        endIndex = num*(index+1);
        tempArr = secondId;
    }
    return [NSArray arrayWithArray:arr];
}

//拖拽
- (void)onBtnAction:(UIButton*)sender{
    sender.selected = ![sender isSelected];
    if (sender.isSelected) {
        [sender setTitle:@"关闭拖拽" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"开启拖拽" forState:UIControlStateNormal];
    }
    self.treeView.param.wDraggableSet(sender.isSelected);
    [self.treeView updateEditing];
}

//json数据
- (NSArray*)jsonData{
    return @[
        @{
            @"name":@"1级",
            @"currentId":@"1",
            @"children":@[
                    @{
                        @"name":@"1_2_1级",
                        @"currentId":@"1_2_1",
                        @"parentId":@"1",
                        @"children":@[
                                           @{
                                               @"name":@"1_3_1级",
                                               @"currentId":@"1_3_1",
                                               @"parentId":@"1_2_1",
                                           },
                                           @{
                                               @"name":@"1_3_2级",
                                               @"currentId":@"1_3_2",
                                               @"parentId":@"1_2_1",
                                           },
                                          @{
                                               @"name":@"1_3_3级",
                                               @"currentId":@"1_3_3",
                                               @"parentId":@"1_2_1",
                                           },
                                   ]
                    },
                    @{
                        @"name":@"1_2_2级",
                        @"currentId":@"1_2_2",
                        @"parentId":@"1",
                    },
                   @{
                        @"name":@"1_2_3级",
                        @"currentId":@"1_2_3",
                        @"parentId":@"1",
                    },
            ]
        },
        @{
            @"name":@"2级",
            @"currentId":@"2",
            @"children":@[
                    @{
                        @"name":@"2_2_1级",
                        @"currentId":@"2_2_1",
                        @"parentId":@"2",
                    },
                    @{
                        @"name":@"2_2_2级",
                        @"currentId":@"2_2_2",
                        @"parentId":@"2",
                    },
                   @{
                        @"name":@"2_2_3级",
                        @"currentId":@"2_2_3",
                        @"parentId":@"2",
                    },
            ]
        },
        @{
            @"name":@"3级",
            @"currentId":@"3",
            @"children":@[
                    @{
                        @"name":@"3_2_1级",
                        @"currentId":@"3_2_1",
                        @"parentId":@"3",
                    },
                    @{
                        @"name":@"3_2_2级",
                        @"currentId":@"3_2_2",
                        @"parentId":@"3",
                    },
                   @{
                        @"name":@"3_2_3级",
                        @"currentId":@"3_2_3",
                        @"parentId":@"3",
                    },
            ]
        }
    ];
}

@end
