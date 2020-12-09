package com.parallel;

public class ConsistentRun {
    final int[][] array;
    final int rows;
    final int columns;
    long runTime;

    public ConsistentRun(int [][] array, int rows, int columns) {
        this.array = array;
        this.rows = rows;
        this.columns = columns;
        this.runTime = 0;
    }

    public void calculate() {
        long startTime = System.nanoTime();
        int matrixLength = this.columns;
        int middleOfMatrix = this.columns / 2;

        for (int i = 0; i < this.rows; i++) {
            for (int j = 0; j < middleOfMatrix; j++) {
               this.array[i][j] = this.array[i][matrixLength - j - 1];
           }
        }

        long endTime = System.nanoTime();
        this.runTime = endTime - startTime;
    }

    public void print() {
        for (int i = 0; i < this.rows; i++) {
        //     System.out.print("[");
        //     for (int j = 0; j < this.columns; j++) {
        //        System.out.print(this.array[i][j] + ", ");
        //    }
        //    System.out.println("]");
        }
        System.out.println("Calculation time: " + this.runTime + "ns.");
    }

    public long getCalculationTime() {
        return runTime;
    }
}
