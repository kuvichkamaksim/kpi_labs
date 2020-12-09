package com.parallel;

public class MirrorArrayThread extends Thread {
    private int [][] matrix;
    private int startIndex;
    private int rowsToBeProccesed;
    private int matrixLength;

    MirrorArrayThread(int [][] matrix, int startIndex, int rowsToBeProccesed, int matrixLength) {
        this.matrix = matrix;
        this.startIndex = startIndex;
        this.rowsToBeProccesed = rowsToBeProccesed;
        this.matrixLength = matrixLength;
    }

    public int[][] getResult() {
        return this.matrix;
    }

    @Override
    public void run() {
        int middleOfMatrix = this.matrixLength / 2;

        for (int i = startIndex; i < this.rowsToBeProccesed; i++) {
            for (int j = 0; j < middleOfMatrix; j++) {
               this.matrix[i][j] = this.matrix[i][matrixLength - j - 1];
           }
        }
    }
}
