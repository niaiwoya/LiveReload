@import LRCommons;

#import "CompileFileRuleRow.h"
#import "LiveReload-Swift-x.h"


@implementation CompileFileRuleRow

- (void)loadContent {
    [super loadContent];

    self.sourcePopUp = [[[[NSPopUpButton popUpButton] withBezelStyle:NSRoundRectBezelStyle] withTarget:self action:@selector(sourceOptionSelected:)] addedToView:self];
    self.destinationPopUp = [[[[NSPopUpButton popUpButton] withBezelStyle:NSRoundRectBezelStyle] withTarget:self action:@selector(destinationOptionSelected:)] addedToView:self];
    [[self.sourcePopUp cell] setLineBreakMode:NSLineBreakByTruncatingHead];
    [[self.destinationPopUp cell] setLineBreakMode:NSLineBreakByTruncatingHead];
    [self.sourcePopUp setContentCompressionResistancePriority:450 forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.destinationPopUp setContentCompressionResistancePriority:450 forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sourcePopUp attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.destinationPopUp attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];

    [self addConstraintsWithVisualFormat:@"|-indentL2-[checkbox(>=200)]-[sourcePopUp(>=120)]-columnGapMin-[destinationPopUp(>=120)]-(>=buttonBarGapMin)-[optionsButton]-buttonGap-[removeButton]|" options:NSLayoutFormatAlignAllCenterY];
    [self addFullHeightConstraintsForSubview:self.sourcePopUp];

    //    [self alignView:self.checkbox toColumnNamed:@"actionRightEdge" alignment:ATStackViewColumnAlignmentTrailing];
    [self alignView:self.sourcePopUp toColumnNamed:@"from"];
    [self alignView:self.destinationPopUp toColumnNamed:@"to"];

    [self.checkbox bind:@"value" toObject:self.representedObject withKeyPath:@"enabled" options:nil];
}

- (void)updateContent {
    [super updateContent];
    self.checkbox.title = self.rule.label;
}

- (void)updateFilterOptions {
    CompileFileRule *xaction = (CompileFileRule *)self.rule;
    [self updateFilterOptionsPopUp:self.sourcePopUp selectedOption:self.rule.inputFilterOption];
    [self updateFilterOptionsPopUp:self.destinationPopUp selectedOption:xaction.outputFilterOption];
}

- (IBAction)sourceOptionSelected:(NSPopUpButton *)sender {
    CompileFileRule *xaction = (CompileFileRule *)self.rule;
    FilterOption *filterOption = sender.selectedItem.representedObject;

    BOOL same = ([xaction.inputFilterOption.subfolder isEqualToString:xaction.outputFilterOption.subfolder]);
    xaction.inputFilterOption = filterOption;
    if (same) {
        xaction.outputFilterOption = filterOption;
    }
}

- (IBAction)destinationOptionSelected:(NSPopUpButton *)sender {
    CompileFileRule *xaction = (CompileFileRule *)self.rule;
    FilterOption *filterOption = sender.selectedItem.representedObject;
    xaction.outputFilterOption = filterOption;
}

+ (NSArray *)representedObjectKeyPathsToObserve {
    return @[@"inputFilterOption", @"outputFilterOption"];
}

- (void)loadOptionsIntoView:(LROptionsView *)container {
    for (Option *option in [self.rule createOptions]) {
        OptionController *controller = [OptionController controllerForOption:option];
        if (controller) {
            [container addOption:controller];
        }
    }
}

@end
