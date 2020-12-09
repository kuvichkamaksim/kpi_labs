package com.parallel;

import java.util.Random;

public class TaskProducer extends Thread {
    Queue queue;

    public TaskProducer(Queue queue) {
        this.queue = queue;
    }
    
    public void run() {
        while (!interrupted()) {
            // generate task with random value between 100 and 1100
            int nextTaskValue = new Random().nextInt(1000) + 100;
            queue.push(nextTaskValue);

            try {
                sleep(1000);
            } catch (InterruptedException ex) {
                return;
            }
        }
    }
}
