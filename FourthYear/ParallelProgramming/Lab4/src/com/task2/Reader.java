package com.task2;

import java.util.concurrent.ThreadLocalRandom;

public class Reader extends Thread {
    private static int numberOfReaders = 0;

    private final int id;
    private final Memory memory;

    public Reader(Memory memory) {
        this.memory = memory;
        this.id = Reader.numberOfReaders++;
    }

    @Override
    public void run() {
        while (true) {
            try {
                Thread.sleep(ThreadLocalRandom.current().nextInt(100, 4100));
            } catch (InterruptedException e) {}

            memory.read(id);
        }
    }
}