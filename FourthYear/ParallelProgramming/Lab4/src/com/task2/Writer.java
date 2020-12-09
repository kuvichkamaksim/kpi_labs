package com.task2;

import java.util.concurrent.ThreadLocalRandom;

public class Writer extends Thread {
    private static int numberOfWriters = 0;

    private final int id;
    private final Memory memory;

    public Writer(Memory memory) {
        this.memory = memory;
        this.id = Writer.numberOfWriters++;
    }

    @Override
    public void run() {
        while (true) {
            try {
                Thread.sleep(ThreadLocalRandom.current().nextInt(100, 4100));
            } catch (InterruptedException e) {}

            try {
                this.memory.write(id);
            } catch (NullPointerException e) {
                System.out.println(e.getMessage());
            }
        }
    }
}