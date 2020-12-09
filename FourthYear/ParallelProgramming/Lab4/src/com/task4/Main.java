package com.task4;

import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

public class Main {
    public static void main(String[] args) {
        int numberOfBarbers = 3;
        int numberOfWaitingSeats = 10;

        AtomicInteger waitingSeats = new AtomicInteger(numberOfWaitingSeats);
        
        final Semaphore barbersSemaphore = new Semaphore(numberOfBarbers, true);
        final Semaphore clientsSemaphore = new Semaphore(0, true);

        for (int i = 0; i < numberOfBarbers; i++) {
            new Barber(barbersSemaphore, clientsSemaphore).start();
        }

        while (true) {
            try {
                // Sleep until next client gets in
                Thread.sleep(ThreadLocalRandom.current().nextInt(100, 1100));
            } catch (InterruptedException e) {}

            System.out.println("Client walks in");

            if (waitingSeats.get() > 0) {
                new Client(waitingSeats, barbersSemaphore, clientsSemaphore).start();
            } else {
                System.out.println("Client walks out, no free seats");
            }
        }
    }
}
