package com.parallel;
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    int arraySize = 10;

    ParallelArray parallelArray = new ParallelArray(arraySize);

    Lambda function;
    function = x -> x % 2 != 0;

    int numberOfOddNumbers = parallelArray.getNumberOfElementsWithCondition(function);
    System.out.println("Number of odd numbers is array: " + numberOfOddNumbers);

    int[][] minAndMax = parallelArray.getMinAndMaxElements();

    System.out.println("\nMin index and value: " + Arrays.toString(minAndMax[0]));
    System.out.println("Max index and value: " + Arrays.toString(minAndMax[1]));

    int controlSum = parallelArray.getControlSum();

    System.out.println("\nControl sum: " + controlSum);
  }
}
