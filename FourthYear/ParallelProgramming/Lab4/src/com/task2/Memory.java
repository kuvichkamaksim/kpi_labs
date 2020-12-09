package com.task2;

import java.util.concurrent.Semaphore;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.atomic.AtomicInteger;

public class Memory {
    private final AtomicInteger readersCounter;
    private final AtomicInteger writersCounter;

    private final Semaphore readSemaphore;
    private final Semaphore writeSemaphore;
    private final Semaphore readRequest;
    private final Semaphore resourceSemaphore;

    public Memory(Semaphore readSemaphore, Semaphore writeSemaphore, Semaphore readRequest, Semaphore resourceSemaphore) {
        this.readersCounter = new AtomicInteger(0);
        this.writersCounter = new AtomicInteger(0);

        this.readSemaphore = readSemaphore;
        this.writeSemaphore = writeSemaphore;
        this.readRequest = readRequest;
        this.resourceSemaphore = resourceSemaphore;
    }

    public void read(int readerId) {
        try {
            readRequest.acquire();
            readSemaphore.acquire();
            if (readersCounter.incrementAndGet() == 1) {
                resourceSemaphore.acquire();
            }
            readSemaphore.release();
            readRequest.release();

            System.out.println("Reader " + readerId + " starts reading.");
            Thread.sleep(ThreadLocalRandom.current().nextInt(100, 4100));
            System.out.println("Reader " + readerId + " stops reading.");

            readSemaphore.acquire();
            if (readersCounter.decrementAndGet() == 0) {
                resourceSemaphore.release();
            }
            readSemaphore.release();
        } catch (InterruptedException e) {}
    }

    public void write(int writerId) {
        try {
            writeSemaphore.acquire();
            if (writersCounter.incrementAndGet() == 1) {
                readRequest.acquire();
            }
            writeSemaphore.release();

            resourceSemaphore.acquire();
            System.out.println("Writer " + writerId + " starts writing.");
            Thread.sleep(ThreadLocalRandom.current().nextInt(100, 4100));
            System.out.println("Writer " + writerId + " stops writing.");
            resourceSemaphore.release();

            writeSemaphore.acquire();
            if (writersCounter.decrementAndGet() == 0) {
                readRequest.release();
            }
            writeSemaphore.release();
        } catch (InterruptedException e) {}
    }
}