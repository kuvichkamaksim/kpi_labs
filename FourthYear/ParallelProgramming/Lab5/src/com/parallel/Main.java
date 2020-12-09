package com.parallel;

import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Main {
    static final int numberOfArrays = 2;
    static final int arraySize = 100;

    public static void main(String[] args) throws ExecutionException, InterruptedException {

        int[][] arrays = new int[numberOfArrays][arraySize];
        for (int i = 0; i < numberOfArrays; ++i) {
            for (int j = 0; j < arraySize; j++) {
                arrays[i][j] = new Random().nextInt(1000);
            }
        }

        List<CompletableFuture<int[]>> futuresList = new ArrayList<>();
        futuresList.add(CompletableFuture
                .supplyAsync(() -> removeNumbersLessThan60Percents(arrays[0])));
        futuresList.add(CompletableFuture
                .supplyAsync(() -> removeOddNumbers(arrays[1])));

        CompletableFuture<List<Integer>> allFutures = CompletableFuture
                        .allOf(futuresList.toArray(new CompletableFuture[0]))
                        .thenApply((i) -> {
                    List<Integer> resultArray = new ArrayList<>();

                    List<int[]> resultsOfFutures = futuresList.stream()
                            .map(future -> future.join())
                            .collect(Collectors.toList());

                    IntStream.range(0, resultsOfFutures.size()).forEach(index -> {
                        int[] arr = resultsOfFutures.get(index);
                        System.out.println("Array number " + index + ": " + Arrays.toString(arr));
                        Arrays.stream(arr).forEach(item -> {
                            if (areBothArraysContainItem(resultsOfFutures, item))
                                resultArray.add(item);
                        });
                    });

                    resultArray.sort(Comparator.comparingInt(a -> a));
                    return new ArrayList<>(new HashSet<>(resultArray));
                });

        List<Integer> resultArray = allFutures.get();
        if (resultArray.size() > 0) {
            System.out.println("\nResult: " + allFutures.get());
        } else {
            System.out.println("\nNo common elements found :(");
        }
    }

    public static int[] removeNumbersLessThan60Percents(int[] array) {
        try {
            Thread.sleep((int) (Math.random() * 1000));
        } catch (InterruptedException e) {}

        int maxItem = IntStream.of(array).max().getAsInt();
        double checkValue = maxItem * 0.6;

        return IntStream.of(array)
                .filter(x -> x > checkValue)
                .sorted()
                .toArray();
    }

    public static int[] removeOddNumbers(int[] array) {
        try {
            Thread.sleep((int) (Math.random() * 1000));
        } catch (InterruptedException e) {}

        return IntStream.of(array)
                .filter(i -> i % 2 == 0)
                .sorted()
                .toArray();
    }

    public static boolean areBothArraysContainItem(List<int[]> arrays, int item) {
        return arrays.stream().allMatch(array -> isContain(array, item));
    }

    public static boolean isContain(int[] array, int value) {
        for (int item: array) {
            if (item == value) {
                return true;
            }
        }
        return false;
    }
}