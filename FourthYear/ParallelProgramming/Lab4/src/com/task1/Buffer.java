package com.task1;

import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.locks.*;

public class Buffer {
    private final int size;
    private final List<String> queue;
    private final Lock locker;
    private final Condition isNotFull;
    private final Condition isNotEmpty;

    public Buffer(int size) {
        this.size = size;
        this.queue = new ArrayList<>();
        this.locker = new ReentrantLock();
        this.isNotFull = locker.newCondition();
        this.isNotEmpty = locker.newCondition();
    }

    public void push(String message, int producerId){
        locker.lock();

        try {
            while (queue.size() == size) {
                System.out.println("Buffer is full");
                isNotFull.await();
            }

            queue.add(message);
            System.out.println("Producer " + producerId + " pushed a message: " + message);
            isNotEmpty.signalAll();
        } catch (InterruptedException e) {}

        locker.unlock();
    }

    public void pop(int consumerId){
        locker.lock();

        try {
            while (queue.size() <= 0) {
                System.out.println("Buffer is empty");
                isNotEmpty.await();
            }

            String message = queue.remove(0);
            System.out.println("Consumer " + consumerId + " took message: " + message);
            isNotFull.signalAll();
        } catch (InterruptedException e) {}

        locker.unlock();
    }

}
