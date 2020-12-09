package com.task3;

public class Main {
    public static void main(String[] args) {
        final int numberOfPhilosophers = 5;
        final int numberOfForks = 5;

        Fork[] forks = new Fork[numberOfForks];
        for (int i = 0; i < numberOfForks; i++) {
            forks[i] = new Fork(i);
        }

        for (int i = 0; i < numberOfPhilosophers; i++) {
            Fork leftFork = forks[i];
            Fork rightFork = forks[(i + 1) % numberOfForks];


            if (i == numberOfPhilosophers - 1) {
                new Philosopher(rightFork, leftFork).start();
            } else {
                new Philosopher(leftFork, rightFork).start();
            }
        }
    }
}
