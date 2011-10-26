#import "LibrariesTableViewCell.h"
#import "Foundation+MITAdditions.h"
#import "UIKit+MITAdditions.h"

const CGFloat kLibrariesTableCellDefaultWidth = 300;
const CGFloat kLibrariesTableCellEditingWidth = 296;

@implementation LibrariesTableViewCell
@synthesize contentViewInsets = _contentViewInsets,
            infoLabel = _infoLabel,
            itemDetails = _itemDetails,
            statusLabel = _statusLabel,
            statusIcon = _statusIcon,
            titleLabel = _titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.editingAccessoryType = UITableViewCellAccessoryCheckmark;
        self.shouldIndentWhileEditing = NO;
        
        self.titleLabel = [[[UILabel alloc] init] autorelease];
        self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.titleLabel.highlightedTextColor = [UIColor whiteColor];
        self.titleLabel.autoresizingMask = UIViewAutoresizingNone;
        [self.contentView addSubview:self.titleLabel];
        
        self.infoLabel = [[[UILabel alloc] init] autorelease];
        self.infoLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.infoLabel.numberOfLines = 0;
        self.infoLabel.font = [UIFont systemFontOfSize:14.0];
        self.infoLabel.highlightedTextColor = [UIColor whiteColor];
        self.infoLabel.autoresizingMask = UIViewAutoresizingNone;
        
        [self.contentView addSubview:self.infoLabel];
        
        self.statusLabel = [[[UILabel alloc] init] autorelease];
        self.statusLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.statusLabel.numberOfLines = 0;
        self.statusLabel.font = [UIFont systemFontOfSize:14.0];
        self.statusLabel.highlightedTextColor = [UIColor whiteColor];
        self.statusLabel.autoresizingMask = UIViewAutoresizingNone;
        [self.contentView addSubview:self.statusLabel];
        
        self.statusIcon = [[[UIImageView alloc] init] autorelease];
        self.statusIcon.hidden = YES;
        [self.contentView addSubview:self.statusIcon];
        
        self.contentViewInsets = UIEdgeInsetsMake(5, 5, 5, 10);
    }
    return self;
}

- (void)dealloc
{
    self.itemDetails = nil;
    self.infoLabel = nil;
    self.statusLabel = nil;
    self.statusIcon = nil;
    self.titleLabel = nil;
    
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect contentBounds = UIEdgeInsetsInsetRect(self.contentView.frame, self.contentViewInsets);
    self.contentView.frame = contentBounds;
    [self layoutContentUsingBounds:self.contentView.bounds];
}

- (void)layoutContentUsingBounds:(CGRect)viewBounds
{
    CGFloat viewWidth = CGRectGetWidth(viewBounds);
    
    {
        CGRect titleFrame = CGRectZero;
        titleFrame.origin = viewBounds.origin;
        titleFrame.size = [[self.titleLabel text] sizeWithFont:self.titleLabel.font
                                             constrainedToSize:CGSizeMake(viewWidth, CGFLOAT_MAX)
                                                 lineBreakMode:self.titleLabel.lineBreakMode];
        self.titleLabel.frame = titleFrame;
    }
    
    {
        CGRect infoFrame = CGRectZero;
        infoFrame.origin = CGPointMake(CGRectGetMinX(viewBounds),
                                       CGRectGetMaxY(self.titleLabel.frame) + 3);
        
        infoFrame.size = [[self.infoLabel text] sizeWithFont:self.infoLabel.font
                                           constrainedToSize:CGSizeMake(viewWidth, CGFLOAT_MAX)
                                               lineBreakMode:self.infoLabel.lineBreakMode];
        self.infoLabel.frame = infoFrame;
    }
    
    {
        CGRect statusFrame = CGRectZero;
        statusFrame.origin = CGPointMake(CGRectGetMinX(viewBounds),
                                         CGRectGetMaxY(self.infoLabel.frame));
        statusFrame.size = [[self.statusLabel text] sizeWithFont:self.statusLabel.font
                                               constrainedToSize:CGSizeMake(viewWidth, CGFLOAT_MAX)
                                                   lineBreakMode:self.statusLabel.lineBreakMode];
        self.statusLabel.frame = statusFrame;
    }
}

- (CGFloat)heightForContentWithWidth:(CGFloat)width
{
    CGFloat height = 0;
    width -= (self.contentViewInsets.left + self.contentViewInsets.right);
    
    {
        CGSize titleSize = [[self.titleLabel text] sizeWithFont:self.titleLabel.font
                                              constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                                                  lineBreakMode:self.titleLabel.lineBreakMode];
        height += titleSize.height + 3;
    }
    
    {
        CGSize infoSize = [[self.infoLabel text] sizeWithFont:self.infoLabel.font
                                            constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                                                lineBreakMode:self.infoLabel.lineBreakMode];
        height += infoSize.height;
    }
    
    {
        CGSize noticeSize = [[self.statusLabel text] sizeWithFont:self.statusLabel.font
                                                constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                                                    lineBreakMode:self.statusLabel.lineBreakMode];

        height += noticeSize.height;
    }
    
    return (height + self.contentViewInsets.top + self.contentViewInsets.bottom);
}

- (void)setItemDetails:(NSDictionary *)itemDetails
{
    if ([self.itemDetails isEqualToDictionary:itemDetails] == NO) {
        [_itemDetails release];
        _itemDetails = [itemDetails copy];
        
        if (itemDetails == nil) {
            self.titleLabel.text = nil;
            self.infoLabel.text = nil;
            self.statusLabel.text = nil;
            self.statusIcon.hidden = YES;
        } else {
            NSDictionary *item = self.itemDetails;
            self.titleLabel.text = [item objectForKey:@"title"];
            
            NSString *author = [item objectForKey:@"author"];
            NSString *year = [item objectForKey:@"year"];
            self.infoLabel.text = [[NSString stringWithFormat:@"%@; %@",year,author] stringByDecodingXMLEntities];
        }
        
        [self setNeedsLayout];
    }
}
@end
