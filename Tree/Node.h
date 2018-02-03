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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Node : NSObject

@property (nonatomic) int parentId; //父节点的id，如果为-1表示该节点为根节点

@property (nonatomic) int nodeId;   //本节点的id

@property (nonatomic, strong) NSString *name;   //本节点的名称

@property (nonatomic) int depth;    //该节点的深度

@property (nonatomic) BOOL expand;  //该节点是否处于展开状态

@property (nonatomic) CGRect rect;  //缓存计算的name的frame

@property (nonatomic) BOOL isLastNode;  //是否还有子节点

@property (nonatomic) BOOL isSelected;  //是否选中

@property (nonatomic) BOOL isFirst; //是否是第一个子节点

@property (nonatomic) BOOL isLast;  //是否是最后一个子节点

@property (nonatomic, strong) Node *parentNode; //父节点


/**
 *快速实例化该对象模型
 */
- (instancetype)initWithParentId:(int)parentId nodeId:(int)nodeId name:(NSString *)name depth:(int)depth expand:(BOOL)expand;

@end
