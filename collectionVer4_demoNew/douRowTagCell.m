//
//  DouRowTagCell.m
//  collectionVer4_demoNew
//
//  Created by chensixin on 2025/8/27.
//

//
//  当前这个 cell 用于两列显示标签
// 
#import "DouRowTagCell.h"

@interface DouRowTagCell()

// 显示文字
@property (nonatomic, strong) UILabel *describe_textLabel;

@end

@implementation DouRowTagCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    
    return self;
}



// 设置这个 cell 的 UI
- (void)setupUI{
    self.backgroundColor = [UIColor systemBackgroundColor];
    
    // 圆角
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
    // 框线
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.describe_textLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.describe_textLabel];
    
    self.describe_textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.describe_textLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.describe_textLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor]
    ]];
}




// 外部调用设置数据到这个 cell，只有这两个，直接拼
- (void)setTagCellWithTagData:(Tags *)tag{
    self.describe_textLabel.text = [NSString stringWithFormat:@"%@ %@",
                                    tag.emoji, tag.name];
}




- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

@end
