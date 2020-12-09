package com.task4;

import java.util.concurrent.Semaphore;
import java.util.concurrent.ThreadLocalRandom;

public class Barber extends Thread {
	private final Semaphore barbersSemaphore;
	private final Semaphore clientsSemaphore;

	public Barber(Semaphore barbersSemaphore, Semaphore clientsSemaphore) {
		this.barbersSemaphore = barbersSemaphore;
		this.clientsSemaphore = clientsSemaphore;
	}

	@Override
	public void run() {
		while (true) {
			try {
				// Seat is released in waiting area
				clientsSemaphore.acquire();
				System.out.println("Client is getting a haircut");

                // Do haircut stuff...
                Thread.sleep(ThreadLocalRandom.current().nextInt(1000, 10000 + 1000));

				System.out.println("Client pays and leaves");
				barbersSemaphore.release();
			} catch (InterruptedException e) {}
		}
	}
}
