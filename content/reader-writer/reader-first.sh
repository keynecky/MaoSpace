// 读者优先
semaphore rmutex = 1; // reader互斥访问rcount
semaphore wmutex = 1; // reader和writer互斥访问文件
int rcount = 0;

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