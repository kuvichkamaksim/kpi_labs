package com.task1;

public class Main {
    public static void main(String[] args) {
        final int bufferSize = 4;
        final int numberOfProducers = 3;
        final int numberOfConsumers = 5;

        Buffer buffer = new Buffer(bufferSize);

        for (int i = 0; i < numberOfProducers; i++) {
            new Producer(buffer).start();
        }

        for (int i = 0; i < numberOfConsumers; i++) {
            new Consumer(buffer).start();
        }
    }
}
