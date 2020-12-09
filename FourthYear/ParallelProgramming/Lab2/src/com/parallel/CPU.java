package com.parallel;

import static java.lang.Thread.interrupted;
import static java.lang.Thread.sleep;

public class CPU extends Thread {
    Queue mainQueue;
    Queue additionalQueue;

    public CPU(ThreadGroup group, String name, Queue mainQueue, Queue additionalQueue) {
        super(group, name);
        this.mainQueue = mainQueue;
        this.additionalQueue = additionalQueue;
    }
    
    public void run() {
        while (!interrupted()) {
            Integer task;
            String queueName = "main queue";

            task = mainQueue.pop();

            // get task from additional queue if main is empty
            if (task == null) {
                task = additionalQueue.pop();
                queueName = "additional queue";

                // wait more if additional queue is empty too
                if (task == null) continue;
            }

            System.out.println(this.getName() + " received task from " + queueName + " with value = " + task);

            try {
                sleep(task);
            } catch (InterruptedException ex) {
                return;
            }
        }
    }
}
