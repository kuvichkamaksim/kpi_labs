package com.parallel;
import java.util.Arrays;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.IntStream;

public class ParallelArray {
  private int[] array;

  public ParallelArray(int arraySize) {
    int[] array = new int [arraySize];
    for (int i = 0; i < arraySize; i++) {
      array[i] = new Random().nextInt(1000) - 500;
    }

    this.array = array;
    System.out.println("Array created: " + Arrays.toString(this.array));
  }

  public int getNumberOfElementsWithCondition(Lambda function) {
    AtomicInteger numberOfElements = new AtomicInteger(0);

    IntStream.of(this.array).parallel().forEach( x -> {
      if (function.call(x)) {
          int oldValue;
          int newValue;
          do {
            oldValue = numberOfElements.get();
            newValue = oldValue + 1;
          } while (!numberOfElements.compareAndSet(oldValue, newValue));
      }
    });

    return numberOfElements.get();
  }

  public int[][] getMinAndMaxElements() {
    AtomicInteger minElement = new AtomicInteger(0);
    AtomicInteger maxElement = new AtomicInteger(0);

    IntStream.range(0, this.array.length).parallel().forEach( i -> {
      int oldValue;

      // calculate if array[i] is min value
      do {
        oldValue = minElement.get();

        if (this.array[oldValue] < this.array[i]) {
          break;
        }
      } while (!minElement.compareAndSet(oldValue, i));

      // calculate if array[i] is max value
      do {
        oldValue = maxElement.get();

        if (this.array[oldValue] > this.array[i]) {
          break;
        }
      } while (!maxElement.compareAndSet(oldValue, i));
    });

    int[][] result = {
      {minElement.get(), this.array[minElement.get()]},
      {maxElement.get(), this.array[maxElement.get()]},
    };

    return result;
  }

  public int getControlSum() {
    AtomicInteger sum = new AtomicInteger(0);

    IntStream.of(this.array).parallel().forEach( x -> {
      int oldValue;
      int newValue;

      do {
        oldValue = sum.get();
        newValue = oldValue ^ x;
      } while (!sum.compareAndSet(oldValue, newValue));
    });

    return sum.get();
  }
}
