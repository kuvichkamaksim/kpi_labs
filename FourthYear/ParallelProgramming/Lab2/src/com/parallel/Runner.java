package com.parallel;

public class Runner {
    public static void main(String[] args) throws InterruptedException {
        Integer firstQueueSize = 10;
        Integer secondQueueSize = 20;

        Queue firstQueue = new Queue(firstQueueSize);
        Queue secondQueue = new Queue(secondQueueSize);

        ThreadGroup CPUsGroup = new ThreadGroup("CPUsGroup");

        CPU firstCPU = new CPU(CPUsGroup, "CPU 1", firstQueue, secondQueue);
        CPU secondCPU = new CPU(CPUsGroup, "CPU 2", secondQueue, firstQueue);
        
        firstCPU.start();
        secondCPU.start();

        new TaskProducer(firstQueue).start();
        new TaskProducer(secondQueue).start();
    }
}
