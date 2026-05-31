import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

import '../models/player.dart';
import '../services/task_bank.dart';
import '../services/task_bank_loader.dart';
import '../services/task_bank_storage.dart';

import '../models/task_qr_package.dart';
import 'task_qr_export_screen.dart';
import 'task_editor_screen.dart';
import '../services/community_task_service.dart';

import 'community_tasks_screen.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({
    super.key,
  });

  @override
  State<TaskManagerScreen> createState() =>
      _TaskManagerScreenState();
}

class _TaskManagerScreenState
    extends State<TaskManagerScreen> {
  TaskBank? _bank;

  Gender _gender = Gender.male;

  int _difficulty = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bank =
        await TaskBankLoader.load();

    if (!mounted) return;

    setState(() {
      _bank = bank;
    });
  }

  List<String> get _tasks =>
      _bank?.tasks[_gender]?[_difficulty] ??
      [];

  Future<void> _save() async {
    if (_bank != null) {
      await TaskBankStorage.save(
        _bank!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!;

    if (_bank == null) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.taskManagerTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.public,
            ),
            tooltip: l10n.communityTasks,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const CommunityTasksScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [

          // 🎚️ FILTRY
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              DropdownButton<Gender>(
                value: _gender,
                items: [
                  DropdownMenuItem(
                    value: Gender.male,
                    child: Text(
                      l10n.male,
                    ),
                  ),
                  DropdownMenuItem(
                    value: Gender.female,
                    child: Text(
                      l10n.female,
                    ),
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    _gender = v!;
                  });
                },
              ),
              const SizedBox(
                width: 20,
              ),
              DropdownButton<int>(
                value: _difficulty,
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text('1'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('2'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('3'),
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    _difficulty = v!;
                  });
                },
              ),
            ],
          ),

          const Divider(),

          // 📜 TASK LIST
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Text(
                      l10n.noTasksYet,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        _tasks.length,
                    itemBuilder:
                        (_, i) => ListTile(
                      title: Text(
                        _tasks[i],
                      ),

                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.public,
                            ),
                            tooltip: l10n
                                .shareToCommunity,
                            onPressed: () async {
                              final messenger =
                                  ScaffoldMessenger.of(
                                context,
                              );

                              try {
                                await CommunityTaskService
                                    .uploadTask(
                                  text: _tasks[i],
                                  gender:
                                      _gender.name,
                                  difficulty:
                                      _difficulty,
                                  anonymous:
                                      false,
                                );

                                if (!mounted) {
                                  return;
                                }

                                messenger
                                    .showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(
                                      l10n
                                          .taskShared,
                                    ),
                                  ),
                                );
                              } catch (_) {
                                if (!mounted) {
                                  return;
                                }

                                messenger
                                    .showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(
                                      l10n
                                          .taskShareFailed,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                            ),
                            onPressed: () async {
                              _bank!
                                  .removeTask(
                                _gender,
                                _difficulty,
                                i,
                              );

                              await _save();

                              setState(() {});
                            },
                          ),
                        ],
                      ),

                      // ✏️ EDIT
                      onTap: () async {
                        final edited =
                            await Navigator.push<
                                String>(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                TaskEditorScreen(
                              initialText:
                                  _tasks[i],
                            ),
                          ),
                        );

                        if (edited != null &&
                            edited
                                .trim()
                                .isNotEmpty) {
                          _bank!.updateTask(
                            _gender,
                            _difficulty,
                            i,
                            edited.trim(),
                          );

                          await _save();

                          setState(() {});
                        }
                      },
                    ),
                  ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(
              16,
            ),
            child: Column(
              children: [
                // ➕ ADD TASK
                ElevatedButton(
                  onPressed: () async {
                    final text =
                        await Navigator.push<
                            String>(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const TaskEditorScreen(),
                      ),
                    );

                    if (text != null &&
                        text
                            .trim()
                            .isNotEmpty) {
                      _bank!.addTask(
                        _gender,
                        _difficulty,
                        text.trim(),
                      );

                      await _save();

                      setState(() {});
                    }
                  },
                  child: Text(
                    l10n.addTask,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                // 📤 EXPORT QR
                ElevatedButton(
                  onPressed:
                      _tasks.isEmpty
                          ? null
                          : () {
                              final package =
                                  TaskQrPackage(
                                gender:
                                    _gender,
                                difficulty:
                                    _difficulty,
                                tasks:
                                    List.of(
                                  _tasks,
                                ),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TaskQrExportScreen(
                                    data: package
                                        .toJsonString(),
                                  ),
                                ),
                              );
                            },
                  child: Text(
                    l10n.exportQr,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}