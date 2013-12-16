//
//  DRRMyViewController.m
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import "DRRMyViewController.h"

NSRect computeRect(NSPoint p1, NSPoint p2, NSInteger border) {
    
    CGFloat x = MIN(p1.x, p2.x) - border; CGFloat y = MIN(p1.y, p2.y) - border;
    CGFloat raww = p2.x - p1.x; CGFloat rawh = p2.y - p1.y;
    CGFloat w = ABS(raww) + 2*border; CGFloat h = ABS(rawh) + 2*border;
    
    return NSMakeRect(x, y, w, h);
}



NSPoint findAdiacentVertex(NSMutableArray * linesarr, NSPoint pt) {
    __block NSPoint doubleidx;
    __block BOOL found = NO;
    if (linesarr != NULL) {
        if ([linesarr count] > 0) {
            // comincio il ciclo: per ogni oggetto dell'array (NSMutableArray di NSPoint)...
            [linesarr enumerateObjectsWithOptions:NSEnumerationReverse
                                    usingBlock:^(id line, NSUInteger idx, BOOL *stop) {
                                        
                                        // ...cerco i punti i cui indici sono il primo e l'ultimo della linea
                                        NSInteger endidx = [line count] - 1;
                                        NSPoint startp = [line[0] getPoint];
                                        NSPoint endp = [line[endidx] getPoint];
                                        
                                        // e controllo la loro distanza dal mio punto: punto finale...
                                        if ((abs(endp.x - pt.x) <= PTDISTANCE) && (abs(endp.y - pt.y) <= PTDISTANCE) && !((abs(endp.x - pt.x) > PTDISTANCE*0.7) && (abs(endp.y - pt.y) > PTDISTANCE*0.7))) {
                                            *stop = YES; found = YES;
                                            doubleidx = NSMakePoint(idx, endidx);
                                        }
                                        // ...e punto iniziale
                                        else if ((abs(startp.x - pt.x) <= PTDISTANCE) && (abs(startp.y - pt.y) <= PTDISTANCE) && !((abs(startp.x - pt.x) > PTDISTANCE*0.7) && (abs(startp.y - pt.y) > PTDISTANCE*0.7))) {
                                            *stop = YES; found = YES;
                                            
                                            // rigiro l'array in modo da poter continuare la linea aggiungendo punti alla fine
                                            DRRPointObj * temp;
                                            NSInteger i, j;
                                            for (i = 0, j = [line count] - 1; i < j; i++, j--) {
                                                temp = line[i];
                                                line[i] = line[j];
                                                line[j] = temp;
                                            }
                                            
                                            doubleidx = NSMakePoint(idx, endidx);
                                        }
                                    }];
        }
        
        // arrivo qui solo se l'array delle linee è vuoto oppure se non ho trovato un punto adiacente al mio
        if (!found) doubleidx.x = NOTFOUND;
        return doubleidx;

    }
    else {
        doubleidx.x = ARGERROR;
        errno = EINVAL;
        return doubleidx;
    }
}


@implementation DRRMyViewController


//- (NSSize)screenSize {
//    
//    NSRect screenRect;
//    NSArray *screenArray = [NSScreen screens];
//    NSInteger screenCount = [screenArray count];
//    NSInteger i  = 0;
//    
//    for (i = 0; i < screenCount; i++)
//    {
//        NSScreen *screen = [screenArray objectAtIndex: i];
//        screenRect = [screen visibleFrame];
//    }
//    
//    return screenRect.size;
//}

//NSRect frameRelativeToWindow = [self convertRect:myView.bounds toView:nil];
//NSRect frameRelativeToScreen = [self.window convertRectToScreen:frameInWindow];

//- (NSPoint)convertToScreenFromLocalPoint:(NSPoint)point relativeToView:(NSView *)view {
//	NSPoint windowPoint = [view convertPoint:point toView:nil];
//    NSPoint screenPoint = [[view window] convertBaseToScreen:windowPoint];
//	
//	return screenPoint;
//}

//- (void)moveMouseToScreenPoint:(NSPoint)point
//{
//	CGPoint cgPoint = NSPointToCGPoint(point);
//    
//	CGSetLocalEventsSuppressionInterval(0.0);
//	CGWarpMouseCursorPosition(cgPoint);
//	CGSetLocalEventsSuppressionInterval(0.25);
//}

- (id)initWithFrame:(NSRect)frameRect {
    NSLog(@"initWithFrame myViewController"); // REMOVE
    
    self = [super initWithFrame:frameRect];
    if (self) {
        
//        controls = [[NSMutableArray alloc] init];
        
//        ctrlsz = NSRegularControlSize;
        
        
        
        [self setItemPropertiesToDefault]; ///// TODO proprietà?
    }
    return self;
}

- (void)awakeFromNib {
    NSLog(@"awakeFromNib"); // REMOVE
    
    [super awakeFromNib];
    [self setItemPropertiesToDefault];
    
    [dock setCellClass:[DRRButton class]];
    [dock setFrameOrigin:NSMakePoint(0, 0)];
    [dock setCellSize:cellsize];
    [dock renewRows:1 columns:1];
    
    cellpaths = [[NSMutableArray alloc] init];
    cellmodes = [[NSMutableArray alloc] init];
    makeDrawFreeButton(NSMakeRect(dock.frame.origin.x, dock.frame.origin.y, 1 * dock.cellSize.width, 1 * dock.cellSize.height), roundness, linewidth, cellpaths, cellmodes);
//    [cellpaths addObject:cellpaths];
//    [cellmodes addObject:cellmodes];
    DRRButton * btnDrawFree = [[DRRButton alloc] initWithSize:cellsize paths:cellpaths typeOfDrawing:cellmodes];
    [dock putCell:btnDrawFree atRow:1 column:1];
    [dock sizeToCells];
    
    
    

    
    
//    cellpaths = [[NSMutableArray alloc] init];
//    cellmodes = [[NSMutableArray alloc] init];
//    // altri bottoni TODO
    
    
//    NSArray * cells = [[NSArray alloc] init];
//    [cells arrayByAddingObject:<#(id)#>
    
//    [dock addRowWithCells:<#(NSArray *)#>];
    
    
    
    
    //    NSCell * btnDrawLine = [[DRRbuttonDrawLine alloc] init];
    //    NSCell * btnMoveView = [[DRRbuttonMoveView alloc] init];
    //    NSCell * btnPlay = [[DRRbuttonDrawPlay alloc] init];
    //    NSCell * btnZoomSlider = [[DRRbuttonZoomSlider alloc] init];
    
    //    DRRbuttonDrawFreely * btnDrawFreely = [self cell];
//    DRRbuttonDrawFreely * btnDrawFreely = [[DRRbuttonDrawFreely alloc] initWithFrame:NSMakeRect(0, self.frame.size.height - ctrlsize.height, ctrlsize.width, ctrlsize.height)];
//    
//    [btnDrawFreely setControlView:self];
//    [btnDrawFreely setFrame:NSMakeRect(0, self.frame.size.height - ctrlsize.height, ctrlsize.width, ctrlsize.height)];
//    [btnDrawFreely setEnabled:YES];
//    [btnDrawFreely setControlSize:ctrlsz];
//    
//    btn1 = [[DRRbuttonDrawFreely alloc] initWithFrame:NSMakeRect(0, self.frame.size.height - ctrlsize.height, ctrlsize.width, ctrlsize.height)];
//    [btn1 setControlView:self];
//    [btn1 setFrame:NSMakeRect(0, self.frame.size.height - ctrlsize.height, ctrlsize.width, ctrlsize.height)];
//    [btn1 setEnabled:YES];
//    [btn1 setControlSize:ctrlsz];
//    [self sizeToFit];
//    
//    [controls addObject:btnDrawFreely];
    
    
}




- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
//    if (self) { }
    return self;
}

- (void)setItemPropertiesToDefault {
    // inizializzo l'array di linee disegnate e le proprietà
    linesContainer = [[NSMutableArray alloc] init];
    last = -1;
    
    // Dimensione bottoni della dock, spessore line del disegno interno. Rotondità tasti.
    cellsize = NSMakeSize(32, 32);
    linewidth = (cellsize.width + cellsize.height) / 32;
    if (linewidth < 1) { linewidth = 1; }
    roundness = 5;
}



- (void)addEmptyLine {
    NSMutableArray * line = [[NSMutableArray alloc] init];     ///// TODO andranno   le alloc??
    [linesContainer addObject:line];
    last++;
}


- (void)addPointToLatestLine:(NSPoint*)p {
    if (p != NULL) {
        DRRPointObj * pobj = [[DRRPointObj alloc] initWithPoint:p];
        [linesContainer[last] addObject:pobj];
    }
    else
        errno = EINVAL;
}


- (void)addPointToIdxLine:(NSPoint*)p idxLinesArray:(NSInteger)idx {
    if (p != NULL) {
        DRRPointObj * pobj = [[DRRPointObj alloc] initWithPoint:p];
        [linesContainer[idx] addObject:pobj];
    }
    else
        errno = EINVAL;
}


//- (IBAction)cellPressed:(id)sender {
//    [sender setState:NSOnState];
//}
//
//- (IBAction)cellPressedNoMore:(id)sender {
//    [sender setState:NSOffState];
//}

- (void)mouseDown:(NSEvent *)theEvent {
    
    ////// [controller start:self];
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    prevmouseXY = pwindow;
    
    // controllo se il mouse è vicino ad un punto precedente...
    nearpointIdx = findAdiacentVertex(linesContainer, pview);
    
    // ...si! Ancoro la nuova linea a quella.
    if (nearpointIdx.x != ARGERROR && nearpointIdx.x != NOTFOUND) {
        thisIsANewLine = NO;
        NSPoint nearpoint = [linesContainer[(NSInteger)nearpointIdx.x][(NSInteger)nearpointIdx.y] getPoint];
        prevmouseXY = nearpoint;
        
        // sposto il puntatore del mouse nella nuova posizione (coordinate schermo)
        NSRect frameRelativeToScreen = [self.window convertRectToScreen:self.frame];
        NSPoint newpos = NSMakePoint(frameRelativeToScreen.origin.x + nearpoint.x,
                                     frameRelativeToScreen.origin.y + self.window.frame.size.height - nearpoint.y);
        CGWarpMouseCursorPosition(newpos);
    }
    
    // ...no! Aggiungo una nuova linea e il punto ad essa. Includo il caso in cui la funzione abbia restituito un errore
    // per camuffarlo a runtime
    else {
        thisIsANewLine = YES;
        [self addEmptyLine];
        [self addPointToLatestLine:(&pview)];
        if (nearpointIdx.x == ARGERROR)
            perror("myViewController: mouseDown: findAdiacentVertex");
    }
    
    //    [self drawRect:([self bounds])];
    
}


- (void)mouseDragged:(NSEvent *)theEvent {
    
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    
    // Devo aggiungere i punti a quella linea ancorata nella mouseDown senza crearne una nuova
    if (!thisIsANewLine)
        [self addPointToIdxLine:(&pview) idxLinesArray:nearpointIdx.x];
    
    // Creo nuova linea.
    else
        [self addPointToLatestLine:(&pview)];

    NSRect dirtyRect = computeRect(prevmouseXY, pwindow, 2);
    [self setNeedsDisplayInRect:dirtyRect];
        
    prevmouseXY = pwindow;
    
}


- (void)mouseUp:(NSEvent *)theEvent {
    
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    
    // Devo aggiungere i punti a quella linea ancorata nella mouseDown senza crearne una nuova
    if (!thisIsANewLine)
        [self addPointToIdxLine:(&pview) idxLinesArray:nearpointIdx.x];
    
    // Creo nuova linea.
    else
        [self addPointToLatestLine:(&pview)];
    
    NSRect dirtyRect = computeRect(prevmouseXY, pwindow, 2);
    [self setNeedsDisplayInRect:dirtyRect];
    
    prevmouseXY = pwindow;
    
}


- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [dock setNeedsDisplay];
    
}


- (void)setNeedsDisplayInRect:(NSRect)invalidRect {
    [super setNeedsDisplayInRect:invalidRect];
    
    if (CGRectIntersectsRect(dock.frame, invalidRect)) {
        [dock setNeedsDisplay];
    }
}



- (void)drawRect:(NSRect)dirtyRect {
    
    //    if (!NSEqualRects(prevbounds, [self bounds])) {
    //        [self setLayoutDefault];
    //    }
    if(DEBUGMODE) NSLog(@"draw");
    NSColor * black = [NSColor blackColor];
    NSColor * white = [NSColor whiteColor];
    NSColor * red = [NSColor redColor];
    
    [white set];
    NSRectFill(dirtyRect);
    
    //    NSGraphicsContext * g = [NSGraphicsContext currentContext];
    //    CGContextRef gport = [g graphicsPort];
//    NSBezierPath *path = [NSBezierPath bezierPath];
    pathLines = [NSBezierPath bezierPath];
    if (DEBUGMODE) { pathSinglePoint = [NSBezierPath bezierPath]; }
    [pathLines setLineWidth: 2];
    [black set];
    
//    srand(time(NULL));
    
    // per ogni linea del contenitore creo un path con NSBezierPath
    if ([linesContainer count] > 0) {
        [linesContainer enumerateObjectsUsingBlock:^(id line, NSUInteger iline, BOOL *stop1) {
            if ([line count] > 0) {
                // aggiungo ogni punto della linea al path
                [line enumerateObjectsUsingBlock:^(id point, NSUInteger ipoint, BOOL *stop2) {
                    NSPoint p = [point getPoint];
                    if (DEBUGMODE) {
                        [pathSinglePoint appendBezierPathWithOvalInRect:NSMakeRect(p.x - 1.5, p.y - 1.5, 3, 3)];
                    }
                    
                    if (ipoint == 0)
                        [pathLines moveToPoint:p];
                    else {
//                        NSPoint p = [point getPoint];
//                        NSInteger r1 = rand() % 20; NSInteger r2 = rand() % 20;
//                        NSPoint pc1 = NSMakePoint(p.x + r1, p.y - r2);
//                        NSPoint pc2 = NSMakePoint(p.x - r1, p.y + r2);
//                        [path curveToPoint:p controlPoint1:pc1 controlPoint2:pc2];
                        [pathLines lineToPoint:[point getPoint]];
                    }
                }];
                
                [black set];
                [pathLines stroke];
                if (DEBUGMODE) {
                    [red set];
                    [pathSinglePoint fill];
                    [pathSinglePoint removeAllPoints];
                }
                [pathLines removeAllPoints];
//                [self setNeedsDisplay:YES];
            }
        }];
    }
    
    
    
//    if (CGRectIntersectsRect(dock.frame, dirtyRect)) {
//        [dock setNeedsDisplay];
//    }

//    [self setNeedsDisplayInRect:[controls[0] frame]];
//    [self updateCell:controls[0]];
//    [controls[0] drawFrame:[controls[0] frame] inView:self];
//    [self drawCellInside:btn1];
    
}

@end





