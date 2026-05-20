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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F7FC),
      ),
      home: const TodoHomeScreen(),
    );
  }
}

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() =>
      _TodoHomeScreenState();
}

class _TodoHomeScreenState
    extends State<TodoHomeScreen> {
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

    final taskStrings = tasks.map((task) {
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

    final savedTasks =
        prefs.getStringList('tasks');

    if (savedTasks != null) {
      setState(() {
        tasks = savedTasks.map((task) {
          final parts = task.split('|');

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

    if (newTask.isEmpty) return;

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
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),

              const Text(
                'Minimal Todo',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      Color(0xFF2D2A35),
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                'Stay focused today',
                style: TextStyle(
                  fontSize: 15,
                  color:
                      Color(0xFF7A7488),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      offset:
                          Offset(0, 2),
                      color:
                          Color(0x09000000),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            taskController,
                        decoration:
                            const InputDecoration(
                          hintText:
                              'Add a task...',
                          border:
                              InputBorder
                                  .none,
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(
                            horizontal:
                                14,
                            vertical:
                                10,
                          ),
                        ),
                        onSubmitted:
                            (_) {
                          addTask();
                        },
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xFF8B6CF6,
                        ),
                        elevation: 0,
                        minimumSize:
                            const Size(
                          42,
                          42,
                        ),
                        padding:
                            EdgeInsets.zero,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                      child: const Text(
                        '+',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks yet',
                          style:
                              TextStyle(
                            color:
                                Color(
                              0xFF8D879B,
                            ),
                            fontSize:
                                15,
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
                          return Container(
                            margin:
                                const EdgeInsets.only(
                              bottom: 6,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.white,
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius:
                                      6,
                                  offset:
                                      Offset(
                                    0,
                                    2,
                                  ),
                                  color:
                                      Color(
                                    0x05000000,
                                  ),
                                ),
                              ],
                            ),
                            child:
                                ListTile(
                              dense: true,
                              minVerticalPadding:
                                  0,
                              horizontalTitleGap:
                                  4,
                              visualDensity:
                                  const VisualDensity(
                                vertical:
                                    -2,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    10,
                                vertical:
                                    0,
                              ),

                              leading:
                                  Checkbox(
                                activeColor:
                                    const Color(
                                  0xFF8B6CF6,
                                ),
                                visualDensity:
                                    const VisualDensity(
                                  horizontal:
                                      -4,
                                  vertical:
                                      -4,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize
                                        .shrinkWrap,
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
                                softWrap:
                                    true,
                                style:
                                    TextStyle(
                                  fontSize:
                                      15,
                                  height:
                                      1.2,
                                  color:
                                      const Color(
                                    0xFF2D2A35,
                                  ),
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
                                constraints:
                                    const BoxConstraints(),
                                padding:
                                    EdgeInsets.zero,
                                icon:
                                    const Icon(
                                  Icons
                                      .delete_outline_rounded,
                                  size:
                                      22,
                                  color:
                                      Color(
                                    0xFF8D879B,
                                  ),
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