//                #########
//               ############
//               #############
//              ##  ###########
//             ###  ###### #####
//             ### #######   ####
//            ###  ########## ####
//           ####  ########### ####
//         #####   ###########  #####
//        ######   ### ########   #####
//        #####   ###   ########   ######
//       ######   ###  ###########   ######
//      ######   #### ##############  ######
//     #######  ##################### #######
//     #######  ##############################
//    #######  ###### ################# #######
//    #######  ###### ###### #########   ######
//    #######    ##  ######   ######     ######
//    #######        ######    #####     #####
//     ######        #####     #####     ####
//      #####        ####      #####     ###
//       #####      ;###        ###      #
//         ##       ####        ####

#import "ViewController.h"
#import "NodeCell.h"

@interface ViewController ()

@property (nonatomic , strong) NSMutableArray *tempData;

@property (nonatomic , strong) NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 1; i < 5; i++) {
        Node *node1 = [[Node alloc] initWithParentId:-1 nodeId:i name:[NSString stringWithFormat:@"第1层，第%d个", i] depth:0 expand:YES];
        node1.isFirst = i == 1;
        node1.isLast = i == 4;
        [data addObject:node1];
        for (int j = 1; j < 5; j++) {
            Node *node2 = [[Node alloc] initWithParentId:i nodeId:i*10+j name:[NSString stringWithFormat:@"第2层，第%d个", j] depth:1 expand:NO];
            node2.isFirst = j == 1;
            node2.isLast = j == 4;
            node2.parentNode = node1;
            [data addObject:node2];
            for (int k = 1; k < 5; k++) {
                Node *node3 = [[Node alloc] initWithParentId:i*10+j nodeId:i*100+j*10+k name:[NSString stringWithFormat:@"第3层，第%d个", k] depth:2 expand:NO];
                node3.isFirst = k == 1;
                node3.isLast = k == 4;
                node3.parentNode = node2;
                [data addObject:node3];
                for (int l = 1; l < k + 1; l++) {
                    Node *node4 = [[Node alloc] initWithParentId:i*100+j*10+k nodeId:i*100+j*20+k+l name:[NSString stringWithFormat:@"第4层，第%d个", l] depth:3 expand:NO];
                    node4.isFirst = l == 1;
                    node4.isLast = l == k;
                    node4.parentNode = node3;
                    node4.isLastNode = YES;
                    [data addObject:node4];
                }
            }
        }
    }
    self.data = data;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NodeCell class] forCellReuseIdentifier:@"NodeCell"];
}

- (void)setData:(NSArray *)data {
    if (!_data) {
        _data = data;
        _tempData = [self createTempData:data];
        [self.tableView reloadData];
    }
}


-(NSMutableArray *)createTempData : (NSArray *)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if (node.expand) {
            [tempArray addObject:node];
        }
    }
    return tempArray;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Node *node = [_tempData objectAtIndex:indexPath.row];
    NodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NodeCell"];
    cell.model = node;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Node *node = _tempData[indexPath.row];
    return node.rect.size.height + 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先修改数据源
    Node *parentNode = [_tempData objectAtIndex:indexPath.row];
    parentNode.isSelected = !parentNode.isSelected;
    
    if (parentNode.isLastNode) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    NSUInteger startPosition = indexPath.row+1;
    NSUInteger endPosition = startPosition;
    BOOL expand = NO;
    for (int i=0; i<_data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if (node.parentId == parentNode.nodeId) {
            node.expand = !node.expand;
            if (node.expand) {
                [_tempData insertObject:node atIndex:endPosition];
                expand = YES;
                endPosition++;
            }else{
                expand = NO;
                endPosition = [self removeAllNodesAtParentNode:parentNode];
                break;
            }
        }
    }
    
    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    
    //插入或者删除相关节点
    if (expand) {
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSUInteger)removeAllNodesAtParentNode : (Node *)parentNode{
    NSUInteger startPosition = [_tempData indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition+1; i<_tempData.count; i++) {
        Node *node = [_tempData objectAtIndex:i];
        endPosition++;
        if (node.depth <= parentNode.depth) {
            break;
        }
        if(endPosition == _tempData.count-1){
            endPosition++;
            node.expand = NO;
            break;
        }
        node.expand = NO;
        node.isSelected = NO;
    }
    if (endPosition>startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}


@end
