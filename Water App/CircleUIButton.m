//
//  CircleUIButton.m
//  Pods
//
//  Created by Immanuel Kannan on 17/05/2017.
//
//

#import "CircleUIButton.h"

@implementation CircleUIButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
