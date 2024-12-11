import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tt33/storages/models/mood.dart';

import 'models/trigger.dart';

abstract class AppIsarDatabase {
  static late final Isar _instance;

  static Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();
    return _instance = await Isar.open(
      [TriggerSchema, MoodSchema],
      directory: dir.path,
    );
  }

  static Future<void> addTrigger(Trigger trigger) async {
    await _instance.writeTxn(() async => await _instance.triggers.put(trigger));
  }

  static Future<List<Trigger>> getTriggers() async {
    return await _instance.writeTxn(
      () async => await _instance.triggers.where().findAll(),
    );
  }

  static Future<void> addMood(Mood mood) async {
    print('OLDMOOD ID---------------  ${mood.id}');
    await _instance.writeTxn(() async => await _instance.moods.put(mood));
  }

  static Future<void> updateMood(Mood mood, int id) async {
    final old = await _instance.moods.get(id);
    if (old != null) {
      old.type = mood.type;
      old.reasons = mood.reasons;
      old.comment = mood.comment;

      await _instance.writeTxn(() async => await _instance.moods.put(old));
    }
  }

  static Future<List<Mood>> getMoods() async {
    return await _instance.writeTxn(
      () async => await _instance.moods.where().sortByDateDesc().findAll(),
    );
  }

//
//   static Future<void> addTask(Task task) async {
//     await _instance.writeTxn(() async => await _instance.tasks.put(task));
//   }
//
//   static Future<void> deleteTask(int id) async {
//     await _instance.writeTxn(() async => await _instance.tasks.delete(id));
//   }
//
//   static Future<void> updateTask(int id, Task newTask) async {
//     await _instance.writeTxn(() async {
//       final task = await _instance.tasks.get(id);
//       if (task != null) {
//         task
//           ..type = newTask.type
//           ..name = newTask.name
//           ..date = newTask.date
//           ..done = newTask.done;
//         return await _instance.tasks.put(task);
//       }
//     });
//   }
//
//   static Future<List<Goal>> getGoals() async {
//     return await _instance
//         .writeTxn(() async => await _instance.goals.where().findAll());
//   }
//
//   static Future<void> addGoal(Goal goal) async {
//     await _instance.writeTxn(() async => await _instance.goals.put(goal));
//   }
//
//   static Future<void> deleteGoal(int id) async {
//     await _instance.writeTxn(() async => await _instance.goals.delete(id));
//   }
//
//   static Future<void> updateGoal(int id, Goal newGoal) async {
//     await _instance.writeTxn(() async {
//       final goal = await _instance.goals.get(id);
//       if (goal != null) {
//         goal
//           ..type = newGoal.type
//           ..name = newGoal.name
//           ..dates = newGoal.dates
//           ..value = newGoal.value;
//         return await _instance.goals.put(goal);
//       }
//     });
//   }
//
//   static Future<List<Habit>> getHabits() async {
//     return await _instance
//         .writeTxn(() async => await _instance.habits.where().findAll());
//   }
//
//   static Future<void> addHabit(Habit habit) async {
//     await _instance.writeTxn(() async => await _instance.habits.put(habit));
//   }
//
//   static Future<void> deleteHabit(int id) async {
//     await _instance.writeTxn(() async => await _instance.habits.delete(id));
//   }
//
//   static Future<void> updateHabit(int id, Habit newHabit) async {
//     await _instance.writeTxn(() async {
//       final habit = await _instance.habits.get(id);
//       if (habit != null) {
//         habit
//           ..daily = newHabit.daily
//           ..name = newHabit.name
//           ..number = newHabit.number
//           ..dates = newHabit.dates
//           ..category = newHabit.category;
//         return await _instance.habits.put(habit);
//       }
//     });
//   }
}
