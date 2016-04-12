//
//  BatteryView.m
//  luggage
//
//  Created by 张志阳 on 4/12/16.
//  Copyright © 2016 张志阳. All rights reserved.
//

#import "BatteryView.h"

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
        
        _cell1.backgroundColor = [UIColor grayColor];
        _cell2.backgroundColor = [UIColor grayColor];
        _cell3.backgroundColor = [UIColor grayColor];

    }
    return self;
}

-(UILabel *)cell1 {
    CGRect rc = CGRectMake(3, 2, self.frame.size.width/3.0-3, self.frame.size.height-4);
    if (!_cell1) {
        _cell1 = [[UILabel alloc] initWithFrame:rc];
     }
    return _cell1;
}
-(UILabel *)cell2 {
    CGRect rc = CGRectMake(self.frame.size.width/3.0+1, 2, self.frame.size.width/3.0-3, self.frame.size.height-4);
    if (!_cell2) {
        _cell2 = [[UILabel alloc] initWithFrame:rc];
    }
    return _cell2;
}
-(UILabel *)cell3 {
    CGRect rc = CGRectMake(self.frame.size.width*2/3.0-1, 2, self.frame.size.width/3.0-3, self.frame.size.height-4);

    if (!_cell3) {
        _cell3 = [[UILabel alloc] initWithFrame:rc];
    }
    return _cell3;
}

-(void)setBatttery:(NSInteger)battery
{
    _batttery = battery;
    switch (battery) {
        case BATTERY_0:
            _cell1.backgroundColor = _cell2.backgroundColor = _cell3.backgroundColor = [UIColor whiteColor];
            break;
        case BATTERY_33:
            _cell1.backgroundColor = [UIColor greenColor];
            _cell2.backgroundColor = _cell3.backgroundColor = [UIColor whiteColor];
            break;
        case BATTERY_66:
            _cell1.backgroundColor = _cell2.backgroundColor = [UIColor greenColor];
            _cell3.backgroundColor = [UIColor whiteColor];

            break;
        case BATTERY_100:
            _cell1.backgroundColor = _cell2.backgroundColor = _cell3.backgroundColor = [UIColor greenColor];

            break;
            
        default:
            break;
    }
}
@end
