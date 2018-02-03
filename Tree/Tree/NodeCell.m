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

#import "NodeCell.h"
#import "UIView+Extension.h"

// 获取设备的物理高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 获取设备的物理宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//16进制数
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 缩进值
static const CGFloat k_indentation = 30.0f;

@interface NodeCell () {
    UIImageView *_iconView;
    UILabel *_titleLb;
    UIImageView *_arrowView;
    UIView *_lineView;
}

@end

@implementation NodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 15, 15)];
    [self.contentView addSubview:_iconView];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_iconView.centerX, _iconView.bottom, 1, 10)];
    _lineView.backgroundColor = UIColorFromRGB(0xcfcfcf);
    [self.contentView insertSubview:_lineView belowSubview:_iconView];
    _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _iconView.top, 13, 13)];
    _arrowView.right = kScreenWidth - 15;
    _arrowView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_arrowView];
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + 10, _iconView.top, 100, 20)];
    _titleLb.numberOfLines = 0;
    _titleLb.font = [UIFont systemFontOfSize:16];
    _titleLb.textColor = UIColorFromRGB(0x666666);
    [self.contentView addSubview:_titleLb];
}

- (void)setModel:(Node *)model {
    
    _model = model;
    _titleLb.text = model.name;
    
    _arrowView.image = model.isSelected ? [UIImage imageNamed:@"竖下拉"] : [UIImage imageNamed:@"横下拉"];
    _titleLb.font = [UIFont systemFontOfSize:16 - model.depth];
    _arrowView.hidden = model.isLastNode;
    
    if (model.rect.size.width == 0) {
        _iconView.left = 15 + model.depth * k_indentation;
        _titleLb.left = _iconView.right + 10;
        _titleLb.width = _arrowView.left - _iconView.right - 20;
        CGSize lbsize = [_titleLb sizeThatFits:CGSizeMake(_titleLb.width, MAXFLOAT)];
        _titleLb.height = lbsize.height;
        if (_titleLb.height < _iconView.height) {
            _titleLb.height = _iconView.height;
        }
        model.rect = _titleLb.frame;
    }
    else {
        _titleLb.frame = model.rect;
        _iconView.right = _titleLb.left - 10;
    }
    
    _lineView.x = _iconView.centerX;
    if (model.isLast && model.isFirst) {
        _lineView.height = 0;
    }
    else if (model.isLast) {
        _lineView.y = 0;
        _lineView.height = _iconView.top;
    }
    else if (model.isFirst) {
        _lineView.y = _iconView.bottom;
        _lineView.height = _titleLb.bottom - _iconView.bottom + 7.5;
    }
    else {
        _lineView.y = 0;
        _lineView.height = _titleLb.bottom + 7.5;
    }
    
    if (model.isLastNode) {
        _iconView.image = model.isSelected ? [UIImage imageNamed:@"选择框-选中副本2"] : [UIImage imageNamed:@"选择框-选中副本6"];
    }
    else {
        _iconView.image = [UIImage imageNamed:@"选择框-选中副本6"];
    }
    
    for (UIView *lineView in self.contentView.subviews) {
        if (lineView.tag > 100) {
            lineView.hidden = YES;
        }
    }
    
    Node *parentNode = model.parentNode;
    for (int i = 1; i <= model.depth; i++) {
        UIView *line = [self.contentView viewWithTag:100 + i];
        if (!line) {
            line = [UIView new];
            line.backgroundColor = UIColorFromRGB(0xcfcfcf);
            line.tag = 100 + i;
            [self.contentView addSubview:line];
        }
        line.frame = CGRectMake(_iconView.centerX - k_indentation * i, 0, 1, _titleLb.bottom + 7.5);
        line.hidden = parentNode.isLast;
        parentNode = parentNode.parentNode;
    }
}

@end
