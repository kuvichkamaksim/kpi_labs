package com.parallel;

public class Main {
    public static void main(String[] args) {
		int matrixRows = 1000;
		int matrixColumns = 20000;
		int threads = 4;

		int [][] array = generateMatrix(matrixRows, matrixColumns);
		System.out.println("Matrix rows: " + matrixRows + ".");
		System.out.println("Matrix columns: " + matrixColumns + ".");
		System.out.println("Threads: " + threads + ".");

		// Consistent run process
		ConsistentRun consistentRun = new ConsistentRun(array, matrixRows, matrixColumns);
		System.out.println("-----Consistent run initialized.------");
		consistentRun.calculate();
		long consistentTime = consistentRun.getCalculationTime();
		consistentRun.print();

		// Thread run process
		ThreadRun threadRun = new ThreadRun(array, matrixRows, matrixColumns, threads);
		System.out.println("--------Thread run initialized.-------");
		threadRun.calculate();
		long threadTime = threadRun.getCalculationTime();
		threadRun.print();

		double speedUpFactor = (double)consistentTime / (double)threadTime;
		System.out.println("Speed up factor: " + speedUpFactor + ".");

		double efficiency = speedUpFactor/ (double)threads;
		System.out.println("Efficiency: " + efficiency + ".");
    }

	public static int [][] generateMatrix(int a, int b) {
		int [][] array = new int[a][b];
		for (int i = 0; i < a ; i++) {
			for (int j = 0; j < b; j++) {
				array[i][j] = ((int)(Math.random() * 100));
			}
		}
		return array;
	}
}
