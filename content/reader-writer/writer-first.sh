// 写者优先
semaphore mutex = 1; // writer阻塞reader
semaphore rmutex = 1; // reader互斥访问rcount
semaphore wmutex = 1; // writer互斥访问wcount
semaphore ws; // reader和writer互斥访问文件
int rcount = 0;
int wcount = 0;

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
        P(mutex); // 第一个writer阻塞之后的reader
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