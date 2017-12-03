#ifndef QLIST_MM
#define QLIST_MM

#import "QList.h"

QList::QList() {
    List = [[NSMutableArray alloc] init];
}
QList::~QList() {
//    NSLog(@"Warning, trying to delete QList");
}
void QList::append(id object) {
    [List addObject:object];
}

id QList::at(int i) {
    if (i < 0 || i >= [List count]) {
        //here i will cause the app to crash, we should set it to 0
        i = 0;
    }
    return [List objectAtIndex:i];
}

int QList::size() {
    return [List count];
}

bool QList::isEmpty() {
    if ([List count] == 0)
        return true;
    return false;
}

id QList::takeLast() {
    id temp = [List lastObject];
    [List removeLastObject];
    return temp;
}

id QList::last() {
    return [List lastObject];
}

void QList::prepend(id object) {
    [List insertObject:object atIndex:0];
}

id QList::takeAt(int i) {
    id temp = at(i);
    [List removeObjectAtIndex:i];
    return temp;
}

id QList::takeFirst() {
    return takeAt(0);
}

void QList::clear() {
    [List removeAllObjects];
}

void QList::release() {
    [List release];
    List = nil;
}

#endif