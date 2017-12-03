#ifndef QLIST_H
#define QLIST_H

#import <Foundation/Foundation.h>

class QList {
    NSMutableArray* List;
    
public:
    QList();
    ~QList();
    void append(id);
    id at (int i);
    int size();
    bool isEmpty();
    id takeLast();
    id last();
    void prepend(id);
    id takeAt(int i);
    id takeFirst();
    void clear();
    void release();
};

#endif