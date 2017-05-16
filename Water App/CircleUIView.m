//
//  CircleView.m
//  Water App
//
//  Created by Immanuel Kannan on 16/05/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "CircleUIView.h"

@implementation CircleUIView

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
