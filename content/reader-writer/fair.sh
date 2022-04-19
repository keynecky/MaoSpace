// 读者和写者公平竞争
semaphore mutex = 1;
semaphore rmutex = 1;
semaphore wmutex = 1;
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