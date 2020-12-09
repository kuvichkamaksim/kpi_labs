package com.task1;

import java.util.concurrent.ThreadLocalRandom;

public class Producer extends Thread {
    private static int numberOfProducers = 0;

    private final int id;
    private final Buffer buffer;

    public Producer(Buffer buffer) {
        this.id = numberOfProducers++;
        this.buffer = buffer;
    }

    @Override
    public void run() {
        int messageId = 0;

        while (true) {
            buffer.push(Integer.toString(messageId), id);
            try {
                Thread.sleep(ThreadLocalRandom.current().nextInt(100, 1600));
            } catch (InterruptedException e) {}

            messageId++;
        }
    }
}
