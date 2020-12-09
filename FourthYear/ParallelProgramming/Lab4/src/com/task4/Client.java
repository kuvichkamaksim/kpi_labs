package com.task4;

import java.util.concurrent.Semaphore;
import java.util.concurrent.atomic.AtomicInteger;

public class Client extends Thread {
	private final AtomicInteger waitingSeats;
	private final Semaphore barbersSemaphore;
	private final Semaphore clientsSemaphore;

	public Client(AtomicInteger waitingSeats, Semaphore barbersSemaphore, Semaphore clientsSemaphore) {
		this.waitingSeats = waitingSeats; 
		this.barbersSemaphore = barbersSemaphore;
		this.clientsSemaphore = clientsSemaphore;
	}

	@Override
	public void run() {
        try {
            clientsSemaphore.release();

            if (barbersSemaphore.hasQueuedThreads()) {
                int seatIndex = waitingSeats.decrementAndGet() + 1;
                System.out.println("Client occupied seat number " + seatIndex);
                
                // Client is waiting for barber to start haircut
                barbersSemaphore.acquire();
                waitingSeats.incrementAndGet();
                System.out.println("Client released seat number " + seatIndex);
            } else {
                barbersSemaphore.acquire();
            }

        } catch (InterruptedException e) {}
    }
}
