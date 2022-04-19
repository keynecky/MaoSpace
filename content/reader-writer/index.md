---
title: Reader-Writer Problem
date: "2022-03-11"
# description: "Reader-Writer Problem."
---
## Reader-Writer Problem

The readers-writers problem is a generalization of the mutual exclusion problem. A collection of concurrent threads is accessing a shared object such as a data structure in main memory or a database on disk. Some threads only read the object, while others modify it. Threads that modify the object are called writers. Threads that only read it are called readers. Writers must have exclusive access to the object, but readers may share the object with an unlimited number of other readers. In general, there are an unbounded number of concurrent readers and writers.[1]

Considering the distinct priority of the reader and the writer, there are three different algrithms to solve the reader-writer problem.

### Reader-First Algorithm

Writers have to wait if any reader is using the file while followed readers could access the file unlimitedly. In this algorithm, the writer may starve because of an unbounded number of readers.

```
// reader first 
semaphore rmutex = 1; // reader access rcount exclusively
semaphore wmutex = 1; // reader and writer access file exclusively
int rcount = 0; // count of current reader

reader() {
    P(rmutex);
    if(rcount == 0) {
        P(wmutex);
    }
    rcount++;
    V(rcount);
    read()
    P(rmutex);
    rcount--;
    if(rcount == 0) {
        V(wmutex);
    }
    V(rcount);
}

writer() {
    P(wmutex);
    write();
    V(wmutex);
}
```

### Fair Algorithm

In this algorithm, writer will block followed readers and wait all previous readers to finish their works which could relieve the starvation of writers.

```
// reader and writer race fairly
semaphore mutex = 1; // reader and writer use mutex to block each other
semaphore rmutex = 1; // readers access rcount exclusively
semaphore wmutex = 1; // reader and writer access file exclusively
int rcount = 0;

reader() {
    P(mutex);
    P(rmutex);
    if(rcount == 0) {
        P(wmutex);
    }
    rcount++;
    V(rmutex);
    V(mutex);
    read()
    P(rmutex);
    rcount--;
    if(rcount == 0) {
        V(wmutex);
    }
    V(rcount);
}

writer() {
    P(mutex); 
    P(wmutex);
    write();
    V(wmutex);
    V(mutex);
}
```

### Writer-First Algorithm

In contrast to the Reader-First algorithm, the Writer-First algorithm allows coming writers to cut into the waiting queue of readers and, of course, it may cause the starvation of readers for the same reason.

```
// writer first
semaphore mutex = 1; // writer block reader
semaphore rmutex = 1; // readers access rcount exclusively
semaphore wmutex = 1; // writer access wcount exclusively
semaphore ws; // reader and writer access file exclusively
int rcount = 0; count of current reader
int wcount = 0; count of current writer accessing the file or waiting in the queue

reader() {
    P(mutex);
    P(rmutex);
    if(rcount == 0) {
        P(ws);
    }
    rcount++;
    V(rmutex);
    V(mutex);
    read()
    P(rmutex);
    rcount--;
    if(rcount == 0) {
        V(ws);
    }
    V(rmutex);
}

writer() {
    P(wmutex);
    if(wcount == 0) {
        P(mutex); // the first writer will block followed readers 
    }
    wcount++;
    V(wmutex);
    P(ws);
    write();
    V(ws);
    P(wmutex);
    wcount--;
    if(wcount === 0) {
        V(mutex);
    }
    V(wmutex);
}
```

## Reference
[1] Bryant, Randal E., O'Hallaron David Richard, and O'Hallaron David Richard. Computer systems: a programmer's perspective. Vol. 2. Upper Saddle River: Prentice Hall, 2003.