import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MinimalTodoApp());
}

class MinimalTodoApp extends StatelessWidget {
  const MinimalTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minimal Todo',
      home: const TodoHomeScreen(),
    );
  }
}

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final TextEditingController taskController =
      TextEditingController();

  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> saveTasks() async {
    final prefs =
        await SharedPreferences.getInstance();

    List<String> taskStrings =
        tasks.map((task) {
      return '${task['title']}|${task['isCompleted']}';
    }).toList();

    await prefs.setStringList(
      'tasks',
      taskStrings,
    );
  }

  Future<void> loadTasks() async {
    final prefs =
        await SharedPreferences.getInstance();

    List<String>? savedTasks =
        prefs.getStringList('tasks');

    if (savedTasks != null) {
      setState(() {
        tasks = savedTasks.map((task) {
          final parts =
              task.split('|');

          return {
            'title': parts[0],
            'isCompleted':
                parts[1] == 'true',
          };
        }).toList();
      });
    }
  }

  Future<void> addTask() async {
    final newTask =
        taskController.text.trim();

    if (newTask.isEmpty) {
      return;
    }

    setState(() {
      tasks = [
        ...tasks,
        {
          'title': newTask,
          'isCompleted': false,
        }
      ];
    });

    taskController.clear();

    await saveTasks();
  }

  Future<void> deleteTask(
    int index,
  ) async {
    setState(() {
      tasks.removeAt(index);
    });

    await saveTasks();
  }

  Future<void> toggleTask(
    int index,
    bool? value,
  ) async {
    setState(() {
      tasks[index]['isCompleted'] =
          value ?? false;
    });

    await saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 20),

              const Text(
                'Minimal Todo',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Stay focused today',
                style: TextStyle(
                  fontSize: 16,
                  color:
                      Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller:
                          taskController,

                      decoration:
                          InputDecoration(
                        hintText:
                            'Add a task',
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),

                      onSubmitted: (_) {
                        addTask();
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton(
                    onPressed: () {
                      addTask();
                    },
                    child:
                        const Text('Add'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: tasks.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks yet',
                          style:
                              TextStyle(
                            color: Colors
                                .grey
                                .shade600,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            tasks.length,

                        itemBuilder:
                            (
                              context,
                              index,
                            ) {
                          return Card(
                            child:
                                ListTile(
                              leading:
                                  Checkbox(
                                value:
                                    tasks[index]
                                        [
                                        'isCompleted'],

                                onChanged:
                                    (
                                      value,
                                    ) {
                                  toggleTask(
                                    index,
                                    value,
                                  );
                                },
                              ),

                              title: Text(
                                tasks[index]
                                    ['title'],

                                style:
                                    TextStyle(
                                  decoration:
                                      tasks[index]
                                              [
                                              'isCompleted']
                                          ? TextDecoration
                                              .lineThrough
                                          : TextDecoration
                                              .none,
                                ),
                              ),

                              trailing:
                                  IconButton(
                                icon:
                                    const Icon(
                                  Icons
                                      .delete_outline,
                                ),

                                onPressed:
                                    () {
                                  deleteTask(
                                    index,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}