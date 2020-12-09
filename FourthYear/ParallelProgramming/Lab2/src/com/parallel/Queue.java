package com.parallel;

import java.util.LinkedList;

public class Queue {
    private LinkedList<Integer> list = new LinkedList<>();
    private Integer maxSize;

    public Queue(Integer maxSize) {
        this.maxSize = maxSize;
    }

    public synchronized void push(Integer val) {
    	while (list.size() >= this.maxSize) {
            try {
                wait();
            } catch (InterruptedException ex) {
                return;
            }
        }

        list.add(val);
    }
    
    public synchronized Integer pop() {
        if (list.size() == 0) {
            return null;
        }
        
        Integer temp = list.pop();
        
        notifyAll();
        return temp;
    }
}
