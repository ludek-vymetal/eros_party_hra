import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/community_task.dart';
import '../models/player.dart';
import '../services/community_task_service.dart';
import '../services/task_bank_loader.dart';
import '../services/task_bank_storage.dart';

class CommunityTasksScreen extends StatelessWidget {
  const CommunityTasksScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.communityTasks,
        ),
      ),
      body: StreamBuilder<List<CommunityTask>>(
        stream:
            CommunityTaskService.latestTasks(),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                l10n.communityLoadError,
              ),
            );
          }

          final tasks =
              snapshot.data ?? [];

          if (tasks.isEmpty) {
            return Center(
              child: Text(
                l10n.noCommunityTasks,
              ),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (
              context,
              index,
            ) {
              final task =
                  tasks[index];

              return Card(
                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  title: Text(
                    task.text,
                  ),
                  subtitle: Text(
                    '❤️ ${task.likes}',
                  ),
                  trailing: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      // 📥 IMPORT
                      // 📥 IMPORT
                    IconButton(
                      icon: const Icon(
                        Icons.download,
                      ),
                      tooltip: l10n.importTask,
                      onPressed: () async {
                        final bank =
                            await TaskBankLoader.load();

                        final gender =
                            task.gender == 'female'
                                ? Gender.female
                                : Gender.male;

                        final existingTasks =
                            bank.tasks[gender]
                                ?[task.difficulty] ??
                            [];

                        if (existingTasks.contains(
                          task.text,
                        )) {
                          if (!context.mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.taskAlreadyImported,
                              ),
                            ),
                          );

                          return;
                        }

                        bank.addTask(
                          gender,
                          task.difficulty,
                          task.text,
                        );

                        await TaskBankStorage.save(
                          bank,
                        );

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.taskImported,
                            ),
                          ),
                        );
                      },
                    ),

                      // 👍 LIKE
                      IconButton(
                        icon: const Icon(
                          Icons.thumb_up,
                        ),
                        tooltip:
                            l10n.likes,
                        onPressed: () {
                          CommunityTaskService
                              .likeTask(
                            task.id,
                          );
                        },
                      ),

                      // 🚩 REPORT
                      IconButton(
                        icon: const Icon(
                          Icons.flag,
                        ),
                        tooltip:
                            l10n.reportTask,
                        onPressed:
                            () async {
                          final confirm =
                              await showDialog<
                                  bool>(
                            context:
                                context,
                            builder:
                                (
                                  context,
                                ) {
                              return AlertDialog(
                                title:
                                    Text(
                                  l10n
                                      .reportTask,
                                ),
                                content:
                                    Text(
                                  l10n
                                      .reportTaskQuestion,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () {
                                      Navigator.pop(
                                        context,
                                        false,
                                      );
                                    },
                                    child:
                                        const Text(
                                      'NE',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        () {
                                      Navigator.pop(
                                        context,
                                        true,
                                      );
                                    },
                                    child:
                                        const Text(
                                      'ANO',
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm !=
                              true) {
                            return;
                          }

                          await CommunityTaskService
                              .reportTask(
                            task.id,
                          );

                          if (!context
                              .mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content:
                                  Text(
                                l10n
                                    .taskReported,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}