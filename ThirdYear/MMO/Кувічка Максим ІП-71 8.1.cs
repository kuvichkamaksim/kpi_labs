using System;
using System.Collections.Generic;
using System.Linq;

namespace BranchesAndBoundaries
{
      class Program {
      static void Main(string[] args) {
        List<Task> initialTasks = new List<Task>();

        Task task1 = new Task() {
          taskIndex = 1,
          processTime = 10,
          finishTime = 19,
          penaltyForWeekendBeforePolicyLine = 1,
          penaltyForWeekend = 8
        };

        Task task2 = new Task() {
          taskIndex = 2,
          processTime = 13,
          finishTime = 34,
          penaltyForWeekendBeforePolicyLine = 8,
          penaltyForWeekend = 1
        };

        Task task3 = new Task() {
          taskIndex = 3,
          processTime = 12,
          finishTime = 14,
          penaltyForWeekendBeforePolicyLine = 6,
          penaltyForWeekend = 2
        };

        Task task4 = new Task() {
          taskIndex = 4,
          processTime = 13,
          finishTime = 5,
          penaltyForWeekendBeforePolicyLine = 5,
          penaltyForWeekend = 9
        };

        initialTasks.Add(task1);
        initialTasks.Add(task2);
        initialTasks.Add(task3);
        initialTasks.Add(task4);

        (Scheme result, float removedPercentage) = new Separator(initialTasks).GetBestPlan();

        Console.WriteLine("\nKuvichka Maksym, IP-71 lab 8.1\n");
        Console.WriteLine($"({string.Join(", ", result.tasks.Select(t => t.taskIndex))})");
        Console.WriteLine($"F(opt) = {result.currPenalty}");
        Console.WriteLine($"removedPercentage = {removedPercentage}% \n");
      }
    }

    public class Task {
      public int penaltyForWeekend { get; set; }
      public int processTime { get; set; }
      public int taskIndex { get; set; }
      public int finishTime { get; set; }
      public int startTime { get; set; }
      public int penaltyForWeekendBeforePolicyLine { get; set; }
      public int CurrentPenalty {
        get {
          int deviation = finishTime - (processTime + startTime);
          if (deviation > 0)
              return deviation * penaltyForWeekendBeforePolicyLine;
          return Math.Abs(deviation) * penaltyForWeekend;
        }
      }

      public Task copyTask() {
        return (Task)this.MemberwiseClone();
      }
    }

    public class Scheme {
      public int currPenalty {
        get {
          return tasks.Sum(t => t.CurrentPenalty);
        }
      }
      public LinkedList<Task> tasks { get; }

      public Scheme(Task appendedTask, LinkedList<Task> currentScheme = null) {
        if (currentScheme == null) currentScheme = new LinkedList<Task>();

        if (appendedTask != null) currentScheme.AddLast(appendedTask);

        LinkedListNode<Task> currentTask = currentScheme.First;

        int currentDuration = 0;
        while (currentTask.Next != null) {
          currentDuration += currentTask.Value.processTime;
          currentTask.Next.Value.startTime = currentDuration;

          currentTask = currentTask.Next;
        }

        tasks = currentScheme;
      }

      public Scheme copyScheme() {
        LinkedList<Task> listOfClones = new LinkedList<Task>();

        foreach (Task task in tasks) {
          listOfClones.AddLast(task.copyTask());
        }

        return new Scheme(null, listOfClones);
      }
    }

    public class Separator {
      private IReadOnlyList<Task> _tasks;
      private List<Scheme> _currentPlans;
      private Scheme _record;

      public Separator(List<Task> tasks) {
        _tasks = tasks;
        _currentPlans = new List<Scheme>();
      }

      public (Scheme, float) GetBestPlan() {
        foreach (Task task in _tasks) {
          _currentPlans.Add(new Scheme(task.copyTask()));
        }

        Scheme bestPlan = null;
        List<int> bestPlanTaskIndexes = null;
        int allPlansLength = _currentPlans.Count;
        int removedPlansCount = 0;
        int currentMinFine;
        List<Scheme> recordCandidates;
        while (!_currentPlans.All(p => p.tasks.Count == _tasks.Count && p.currPenalty == _record.currPenalty)) {
          currentMinFine = _currentPlans.Min(p => p.currPenalty);

          // get all schemes that consist of all tasks
          recordCandidates = _currentPlans.Where(plan => plan.tasks.Count == _tasks.Count).ToList();
          // get scheme with min penalty
          _record = recordCandidates.FirstOrDefault(c => c.currPenalty == recordCandidates.Min(rc => rc.currPenalty));

          if (_record != null) {
            removedPlansCount += _currentPlans.RemoveAll(p => p.currPenalty > _record.currPenalty ||
              (p.currPenalty == _record.currPenalty && p.tasks.Count < _tasks.Count));
          }

          // get scheme with min penalty and where algorithm is not finished yet
          bestPlan = _currentPlans.FirstOrDefault(plan => plan.currPenalty == currentMinFine && plan.tasks.Count < _tasks.Count);

          if (bestPlan == null) continue;

          bestPlanTaskIndexes = bestPlan.tasks.Select(t => t.taskIndex).ToList();

          foreach (Task task in _tasks.Where(t => !bestPlanTaskIndexes.Any(n => n == t.taskIndex))) {
            _currentPlans.Add(new Scheme(task.copyTask(), bestPlan.copyScheme().tasks));
            allPlansLength++;
          }

          // remove bestPlan so not to use it any more
          if (_currentPlans.Count != 1) _currentPlans.Remove(bestPlan);
        }

        return (_currentPlans.First(),
            removedPlansCount * 100 / allPlansLength);
      }
    }
}
