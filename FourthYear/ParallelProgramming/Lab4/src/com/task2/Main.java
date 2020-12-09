package com.task2;

import java.util.concurrent.*;

public class Main {
    public static void main(String[] args) {
        final int numberOfReaders = 5;
        final int numberOfWriters = 2;

        Semaphore readSemaphore = new Semaphore(1, true);
        Semaphore writeSemaphore = new Semaphore(1, true);
        Semaphore readRequest = new Semaphore(1, true);
        Semaphore resourceSemaphore = new Semaphore(1, true);

        Memory memory = new Memory(readSemaphore, writeSemaphore, readRequest, resourceSemaphore);

        for (int i = 0; i < numberOfReaders; i++) {
            new Reader(memory).start();
        }

        for (int i = 0; i < numberOfWriters; i++) {
            new Writer(memory).start();
        }
    }
}