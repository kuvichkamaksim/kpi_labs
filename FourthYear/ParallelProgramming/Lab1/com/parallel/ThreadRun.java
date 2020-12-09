package com.parallel;

public class ThreadRun extends ConsistentRun {
    private final int threads;

    public ThreadRun(int[][] array, int rows, int columns, int threads) {
        super(array, rows, columns);
        this.threads = threads;
    }

    @Override
    public void calculate() {
        long startTime = System.nanoTime();
        int [] arrayOfThreadSizes = new int[threads];
        float rowPool = rows;
        int rowsPerThread;

        for (int i = 0; i < threads; i++) {
            rowsPerThread = (int) Math.ceil(rowPool / (float) (threads - i));
            arrayOfThreadSizes[i] = rowsPerThread;
            rowPool -= rowsPerThread;
        }

        MirrorArrayThread[] threadsArray = new MirrorArrayThread[threads];

        int absRowIndex = 0;
        for (int i = 0; i < threads; i++) {
            threadsArray[i] = new MirrorArrayThread(this.array, absRowIndex, arrayOfThreadSizes[i], this.columns);
            threadsArray[i].start();

            absRowIndex += arrayOfThreadSizes[i];
        }

        for (int i = 0; i < threads; i++) {
            try {
                threadsArray[i].join();
            } catch (InterruptedException ignored) {}
        }

        long endTime = System.nanoTime();
        this.runTime = endTime - startTime;
    }
}
