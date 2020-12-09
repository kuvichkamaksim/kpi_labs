package com.task3;

import java.util.concurrent.ThreadLocalRandom;

public class Philosopher extends Thread {
    private static int numberOfPhilosophers = 0;

    private final int id;
    private final Fork leftFork;
    private final Fork rightFork;

    public Philosopher(Fork leftFork, Fork rightFork) {
        this.id = numberOfPhilosophers++;
        this.leftFork = leftFork;
        this.rightFork = rightFork;
    }

    @Override
    public void run() {
        while (true) {
            printAndSleep("is thinking");

            synchronized (leftFork) {
                printAndSleep("picked up left fork number " + leftFork.getId());

                synchronized (rightFork) {
                    printAndSleep("picked up right fork number " + rightFork.getId() + " and started eating");
                    printAndSleep("dropped right fork number " + rightFork.getId());
                }

                printAndSleep("dropped left fork number " + leftFork.getId() + " and started thinking");
            }
        }
    }

    private void printAndSleep(String message) {
        System.out.println("Philosopher " + id + " " + message);

        try {
            Thread.sleep(ThreadLocalRandom.current().nextInt(100, 3100));
        } catch (InterruptedException exception) {}
    }
}
