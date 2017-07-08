//
//  BatteryView.m
//  luggage
//
//  Created by 张志阳 on 4/12/16.
//  Copyright © 2016 张志阳. All rights reserved.
//

#import "BatteryView.h"
#define CELL_COUNT 4
#define CELL_SPACE 1
#define SPACE_COUNT 5
@implementation BatteryView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgView.image = [UIImage imageNamed:@"battery.png"];
        bgView.contentMode = UIViewContentModeScaleToFill;

        [self addSubview: bgView];
        
        [self addSubview:self.cell1];
        [self addSubview:self.cell2];
        [self addSubview:self.cell3];
        [self addSubview:self.cell4];

        _cell1.backgroundColor = [UIColor grayColor];
        _cell2.backgroundColor = [UIColor grayColor];
        _cell3.backgroundColor = [UIColor grayColor];
        _cell4.backgroundColor = [UIColor grayColor];

    }
    return self;
}

-(UILabel *)cell1 {
    float wigth = (self.frame.size.width - SPACE_COUNT*CELL_SPACE)/CELL_COUNT;
    CGRect rc = CGRectMake(CELL_SPACE+1, 2, wigth-1, self.frame.size.height-4);
    if (!_cell1) {
        _cell1 = [[UILabel alloc] initWithFrame:rc];
     }
    return _cell1;
}
-(UILabel *)cell2 {
    float wigth = (self.frame.size.width - SPACE_COUNT*CELL_SPACE)/CELL_COUNT;
    CGRect rc = CGRectMake(wigth + 2*CELL_SPACE, 2,wigth, self.frame.size.height-4);
    if (!_cell2) {
        _cell2 = [[UILabel alloc] initWithFrame:rc];
    }
    return _cell2;
}
-(UILabel *)cell3 {
    float wigth = (self.frame.size.width - SPACE_COUNT*CELL_SPACE)/CELL_COUNT;
    CGRect rc = CGRectMake((wigth+CELL_SPACE)*2 + CELL_SPACE, 2, wigth, self.frame.size.height-4);

    if (!_cell3) {
        _cell3 = [[UILabel alloc] initWithFrame:rc];
    }
    return _cell3;
}

-(UILabel *)cell4 {
    float wigth = (self.frame.size.width - SPACE_COUNT*CELL_SPACE)/CELL_COUNT;

    CGRect rc = CGRectMake((wigth + CELL_SPACE)*3+CELL_SPACE, 2, wigth-2, self.frame.size.height-4);
    
    if (!_cell4) {
        _cell4 = [[UILabel alloc] initWithFrame:rc];
    }
    return _cell4;
}

-(void)setBatttery:(NSInteger)battery
{
    _batttery = battery;
    switch (battery) {
        case BATTERY_0:
            _cell1.backgroundColor = [UIColor redColor];
            _cell2.backgroundColor = _cell3.backgroundColor = _cell4.backgroundColor = [UIColor clearColor];
            break;
        case BATTERY_33:
            _cell1.backgroundColor =_cell2.backgroundColor = [UIColor yellowColor];
            _cell3.backgroundColor = _cell4.backgroundColor = [UIColor clearColor];
            break;
        case BATTERY_66:
            _cell1.backgroundColor = _cell2.backgroundColor = _cell3.backgroundColor=[UIColor greenColor];
            _cell4.backgroundColor = [UIColor clearColor];

            break;
        case BATTERY_100:
            _cell1.backgroundColor = _cell2.backgroundColor = _cell3.backgroundColor =_cell4.backgroundColor= [UIColor greenColor];

            break;
            
        default:
            break;
    }
}
@end
