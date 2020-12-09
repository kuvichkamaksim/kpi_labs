package com.task1;

import java.util.concurrent.ThreadLocalRandom;

public class Consumer extends Thread {
    private static int numberOfConsumers = 0;

    private final int id;
    private final Buffer buffer;

    public Consumer(Buffer buffer) {
        this.id = numberOfConsumers++;
        this.buffer = buffer;
    }

    @Override
    public void run() {
        while (true) {
            buffer.pop(id);

            try {
                Thread.sleep(ThreadLocalRandom.current().nextInt(100, 3100));
            } catch (InterruptedException e) {}
        }
    }
}
