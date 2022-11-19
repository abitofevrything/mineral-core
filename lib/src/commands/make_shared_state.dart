import 'dart:io';

import 'package:args/args.dart';
import 'package:interact/interact.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/managers/cli_manager.dart';
import 'package:path/path.dart';

class MakeSharedState extends MineralCliCommand {
  @override
  String name = 'make:state';

  @override
  String description = 'Make a new state file';

  @override
  Future<void> handle (ArgResults args) async {
    if (args.arguments.length == 1) {
      Console.error(message: 'The name argument is not defined');
      return;
    }

    String filename = args.arguments.elementAt(1).capitalCase;

    final useExistLocation = Confirm(
      prompt: 'Do you want to use an existing location on your disk ?',
      defaultValue: true,
    ).interact();

    late File file;

    if (useExistLocation) {
      List<Directory> directories = await getDirectories();

      final location = Console.cli.choice(
        label: 'Where do you want to place your file ?',
        list: directories,
        items: directories.map((directory) => directory.path
          .replaceAll(join(Directory.current.path, 'src'), 'App')
          .replaceAll('\\', '/'))
          .toList()
      );

      file = File(join(location.path, '${filename.snakeCase}.dart'));
    } else {
      final location = Input(
        prompt: 'Target folder location',
        defaultValue: 'App/folder',
      ).interact();

      file = File(join(Directory.current.path, 'src', location.replaceAll('App/', '').replaceAll('App', ''), '${filename.snakeCase}.dart'));
    }

    await file.create(recursive: true);
    await writeFileContent(file, getTemplate(filename));

    Console.cli.success(message: 'File created ${file.uri}');
  }

  String getTemplate (String filename) => '''
import 'package:mineral/framework.dart';

class ${filename.pascalCase} extends MineralState<String> {
  ${filename.pascalCase}(): super('${filename.pascalCase}', '${filename.pascalCase} description');
  
  // Please define your shared methods below
}
  ''';
}