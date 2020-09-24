#import "LIASongTitleSubPrefsListController.h"

BOOL enableSongTitleSection = NO;

UIBlurEffect* blur;
UIVisualEffectView* blurView;

@implementation LIASongTitleSubPrefsListController

- (instancetype)init {

    self = [super init];

    if (self) {
        LIAAppearanceSettings* appearanceSettings = [[LIAAppearanceSettings alloc] init];
        self.hb_appearanceSettings = appearanceSettings;
        self.enableSwitch = [[UISwitch alloc] init];
        self.enableSwitch.onTintColor = [UIColor colorWithRed: 0.64 green: 0.49 blue: 1.00 alpha: 1.00];
        [self.enableSwitch addTarget:self action:@selector(toggleState) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* switchy = [[UIBarButtonItem alloc] initWithCustomView: self.enableSwitch];
        self.navigationItem.rightBarButtonItem = switchy;
    }

    return self;

}

- (id)specifiers {

    return _specifiers;

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    [self setCellState];

    blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    [blurView setFrame:[[self view] bounds]];
    [blurView setAlpha:1.0];
    [[self view] addSubview:blurView];

    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [blurView setAlpha:0.0];
    } completion:nil];

}

- (void)viewDidAppear:(BOOL)animated {

    [self setEnableSwitchState];

}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {

    NSString* sub = [specifier propertyForKey:@"LIASub"];
    NSString* title = [specifier name];

    _specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

    [self setTitle:title];
    [self.navigationItem setTitle:title];

}

- (void)setSpecifier:(PSSpecifier *)specifier {

    [self loadFromSpecifier:specifier];
    [super setSpecifier:specifier];

}

- (bool)shouldReloadSpecifiersOnResume {

    return false;

}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier{

	[super setPreferenceValue:value specifier:specifier];
	
    if ([specifier.properties[@"key"] isEqualToString:@"customSongTitlePositionAndSize"] && [value isEqual:@(NO)]) {
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] enabled:NO];
    } else if ([specifier.properties[@"key"] isEqualToString:@"customSongTitlePositionAndSize"] && [value isEqual:@(YES)]) {
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] enabled:YES];
    }

    if ([specifier.properties[@"key"] isEqualToString:@"songTitleCustomColor"] && [value isEqual:@(NO)])
	    [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:17 inSection:0] enabled:NO];
    else if ([specifier.properties[@"key"] isEqualToString:@"songTitleCustomColor"] && [value isEqual:@(YES)])
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:17 inSection:0] enabled:YES];

    if ([specifier.properties[@"key"] isEqualToString:@"songTitleShadow"] && [value isEqual:@(NO)]) {
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:21 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:22 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:24 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:26 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:28 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:30 inSection:0] enabled:NO];
    } else if ([specifier.properties[@"key"] isEqualToString:@"songTitleShadow"] && [value isEqual:@(YES)]) {
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:21 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:22 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:24 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:26 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:28 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:30 inSection:0] enabled:YES];
    }

}

- (void)toggleState {

    NSString* path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/love.litten.lobeliaspreferences.plist"];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSSet* allKeys = [NSSet setWithArray:[dictionary allKeys]];
    HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier: @"love.litten.lobeliaspreferences"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/love.litten.lobeliaspreferences.plist"]) {
        enableSongTitleSection = YES;
        [preferences setBool:enableSongTitleSection forKey:@"EnableSongTitleSection"];
        [self toggleCellState:YES];
    } else if (![allKeys containsObject:@"EnableSongTitleSection"]) {
        enableSongTitleSection = YES;
        [preferences setBool:enableSongTitleSection forKey:@"EnableSongTitleSection"];
        [self toggleCellState:YES];
    } else if ([[preferences objectForKey:@"EnableSongTitleSection"] isEqual:@(NO)]) {
        enableSongTitleSection = YES;
        [preferences setBool:enableSongTitleSection forKey:@"EnableSongTitleSection"];
        [self toggleCellState:YES];   
    } else if ([[preferences objectForKey:@"EnableSongTitleSection"] isEqual:@(YES)]) {
        enableSongTitleSection = NO;
        [preferences setBool:enableSongTitleSection forKey:@"EnableSongTitleSection"];
        [self toggleCellState:NO];
    }

}

- (void)setEnableSwitchState {

    NSString* path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/love.litten.lobeliaspreferences.plist"];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSSet* allKeys = [NSSet setWithArray:[dictionary allKeys]];
    HBPreferences* preferences = [[HBPreferences alloc] initWithIdentifier: @"love.litten.lobeliaspreferences"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/love.litten.lobeliaspreferences.plist"]){
        [[self enableSwitch] setOn:NO animated:YES];
        [self toggleCellState:NO];
    } else if (![allKeys containsObject:@"EnableSongTitleSection"]) {
        [[self enableSwitch] setOn:NO animated:YES];
        [self toggleCellState:NO];
    } else if ([[preferences objectForKey:@"EnableSongTitleSection"] isEqual:@(YES)]) {
        [[self enableSwitch] setOn:YES animated:YES];
        [self toggleCellState:YES];
    } else if ([[preferences objectForKey:@"EnableSongTitleSection"] isEqual:@(NO)]) {
        [[self enableSwitch] setOn:NO animated:YES];
        [self toggleCellState:NO];
    }

}

- (void)setCellState {

    NSString* path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/love.litten.lobeliaspreferences.plist"];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSSet* allKeys = [NSSet setWithArray:[dictionary allKeys]];
    HBPreferences* preferences = [[HBPreferences alloc] initWithIdentifier: @"love.litten.lobeliaspreferences"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/love.litten.lobeliaspreferences.plist"]){
        [self toggleCellState:NO];
    } else if (![allKeys containsObject:@"EnableSongTitleSection"]) {
        [self toggleCellState:NO];
    } else if ([[preferences objectForKey:@"EnableSongTitleSection"] isEqual:@(YES)]) {
        [self toggleCellState:YES];
    } else if ([[preferences objectForKey:@"EnableSongTitleSection"] isEqual:@(NO)]) {
        [self toggleCellState:NO];
    }

}

- (void)toggleCellState:(BOOL)enable {

    if (enable) {
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:13 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:14 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:15 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:16 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:17 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:18 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:19 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:20 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:21 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:22 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:23 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:24 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:25 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:26 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:27 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:28 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:29 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:30 inSection:0] enabled:YES];
        [self setCellsHidden];
    } else {
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:13 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:14 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:15 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:16 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:17 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:18 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:19 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:20 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:21 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:22 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:23 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:24 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:25 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:26 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:27 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:28 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:29 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:30 inSection:0] enabled:NO];
    }

}

- (void)setCellsHidden {

    HBPreferences* preferences = [[HBPreferences alloc] initWithIdentifier: @"love.litten.lobeliaspreferences"];

    if ([[preferences objectForKey:@"customSongTitlePositionAndSize"] isEqual:@(YES)]) {
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] enabled:YES];
    } else {
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] enabled:NO];
    }

    if ([[preferences objectForKey:@"songTitleCustomColor"] isEqual:@(YES)])
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:17 inSection:0] enabled:YES];
    else
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:17 inSection:0] enabled:NO];

    if ([[preferences objectForKey:@"songTitleShadow"] isEqual:@(YES)]) {
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:21 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:22 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:24 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:26 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:28 inSection:0] enabled:YES];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:30 inSection:0] enabled:YES];
    } else {
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:21 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:22 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:24 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:26 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:28 inSection:0] enabled:NO];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:30 inSection:0] enabled:NO];
    }

}

- (void)setCellForRowAtIndexPath:(NSIndexPath *)indexPath enabled:(BOOL)enabled {

    UITableViewCell* cell = [self tableView:self.table cellForRowAtIndexPath:indexPath];

    if (cell) {
        cell.userInteractionEnabled = enabled;
        cell.textLabel.enabled = enabled;
        cell.detailTextLabel.enabled = enabled;
        if ([cell isKindOfClass:[PSControlTableCell class]]) {
            PSControlTableCell *controlCell = (PSControlTableCell *)cell;
            if (controlCell.control)
                controlCell.control.enabled = enabled;
        } else if ([cell isKindOfClass:[PSEditableTableCell class]]) {
            PSEditableTableCell *editableCell = (PSEditableTableCell *)cell;
            ((UITextField*)[editableCell textField]).alpha = enabled ? 1 : 0.4;
        }
    }

}

@end