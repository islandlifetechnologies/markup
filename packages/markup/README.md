![Banner](https://raw.githubusercontent.com/islandlifetechnologies/markup/refs/heads/main/assets/banner-800w.jpg)

**Table of Contents**

<!-- markup:toc /-->

## Introduction

Markup is a package to provide automated processing for Markdown files to be able to simplify the creation and maintenance of documentation.

## Syntax

Like most markdown processors, markup uses comments to annotate the processing that neds to occur. The syntax allows for single tag directives as well as block based directives. However, each directive supports only one of the syntaxes and which one is documented in the directive itself.

All directives take the general form of `<!-- markup:directive`. The difference in what follows is defined by whether it is a single tag format or a block format.

All markup directives must begin on their own line. [Single Tag](#single-tag) forms may span multiple lines after the declaration of the directive.

### Single Tag

Single tags are contained within a single comment itself and the contents of the tag are hidden from the rendered markdown. With the single tag format, the tag must end with `/-->`. This informs the parser that the tag has ended. Single tag formats allow for parameters to follow the directive in either JSON or YAML form. Let's take the example parameters:

```json
{ "file": "my.drawio", "type": "svg" }
```

That can be added in any of the following ways:

<!-- markup:ignore -->

```markdown
<!-- markdown:name {"file": "my.drawio", "type": "svg"} /-->
<!-- markdown:name
{
  "file": "my.drawio",
  "type": "svg"
}
/-->
<!-- markdown:name
file: my.drawio
type: svg
/-->
```

<!-- /markup:ignore -->

### Block Tag

The block tags start and end with markup comment. The content within the tags is visible via the rendered Markdown file. An example of a block tag is:

<!-- markup:ignore -->

```markdown
<!-- markup:output -->

![my.png](my-1.png)

<!-- /markup:output -->
```

<!-- /markup:ignore -->

## Built In Directives

| Directive  | Type     | Description                                                                          |
| ---------- | -------- | ------------------------------------------------------------------------------------ |
| `drawio`   | `single` | Exports a single image from a DrawIO file and then links to the image in the output. |
| `file`     | `single` | Embeds the contents of a single file into the output.                                |
| `ignore`   | `block`  | Disables markup processing for everything within the block.                          |
| `output`   | `block`  | The contents of the block are outputs from other markup directives.                  |
| `process`  | `single` | Executes a process and places the `stdio` from the process into the output.          |
| `template` | `single` | Processes a [template_expression] and places the results into the output.            |
| `toc`      | `single` | Generates a Table of Contents for the document and places it into the output.        |

### `drawio`

**Example**

[drawio.md](https://raw.githubusercontent.com/islandlifetechnologies/markup/refs/heads/main/packages/markup/test/assets/drawio.md)

**Parameters**

| Name    | Type             |      Template      | Description                                                                             |
| ------- | ---------------- | :----------------: | --------------------------------------------------------------------------------------- |
| `file`  | `String`         | :white_check_mark: | The path, relative to the Markdown file, of the DrawIO file to generate the image from. |
| `label` | `String?`        |        :x:         | The label to use within the generated Markdown to link to the generated image.          |
| `index` | `int = 1`        |        :x:         | The tab index of the tab to export from DrawIO.                                         |
| `mode`  | `String = 'svg'` |        :x:         | Either `png` or `svg`. Defiles the file type to export.                                 |
| `width` | `int?`           |        :x:         | Only applies when exporting a `png`. Defines the width to use for the exported image.   |

### `file`

**Example**

[file.md](https://raw.githubusercontent.com/islandlifetechnologies/markup/refs/heads/main/packages/markup/test/assets/file.md)

**Parameters**

| Name   | Type     |      Template      | Description                                                    |
| ------ | -------- | :----------------: | -------------------------------------------------------------- |
| `file` | `String` | :white_check_mark: | The path, relative to the Markdown file, of the file to embed. |

### `ignore`

**Example**

[full_processing.md](https://raw.githubusercontent.com/islandlifetechnologies/markup/refs/heads/main/packages/markup/test/assets/full_processing.md)

**Parameters**

_n/a_

### `output`

**Example**

_n/a_

**Parameters**

_n/a_

### `process`

**Example**

[process.md](https://raw.githubusercontent.com/islandlifetechnologies/markup/refs/heads/main/packages/markup/test/assets/process.md)

**Parameters**

| Name                | Type           |      Template      | Description                                                                      |
| ------------------- | -------------- | :----------------: | -------------------------------------------------------------------------------- |
| `args`              | `List<String>` |        :x:         | The optional arguments to pass to the command.                                   |
| `command`           | `String`       |        :x:         | The command to execute.                                                          |
| `ignore-exit-code`  | `bool = false` |        :x:         | When `true`, ignores non-zero exit codes and uses whatever `stdout` was emitted. |
| `working-directory` | `String = '.'` | :white_check_mark: | The working directory to run the command from.                                   |

### `template`

**Example**

[template.md](https://raw.githubusercontent.com/islandlifetechnologies/markup/refs/heads/main/packages/markup/test/assets/template.md)

**Parameters**

| Name       | Type                    |      Template      | Description                                                                                  |
| ---------- | ----------------------- | :----------------: | -------------------------------------------------------------------------------------------- |
| `context`  | `Map<String, dynamic>?` |        :x:         | Optional context to pass to the template engine for when processing the `file` or `template` |
| `file`     | `String?`               | :white_check_mark: | The file containing the template to process. Either this or `template` is required.          |
| `syntax`   | `String`                |        :x:         | The [Template Syntax] to use when processing the template.                                   |
| `template` | `String?`               | :white_check_mark: | The template to process. Either this or `file` is required.                                  |

### `toc`

**Example**

[toc.md](https://raw.githubusercontent.com/islandlifetechnologies/markup/refs/heads/main/packages/markup/test/assets/toc.md)

**Parameters**

| Name     | Type           | Template | Description                                |
| -------- | -------------- | :------: | ------------------------------------------ |
| `bullet` | `String = '-'` |   :x:    | Character to use for the bullet rendering. |

<!-- links -->

[template_expression]: https://pub.dev/packages/template_expressions
[Template Syntax]: https://pub.dev/packages/template_expressions#template-expression-syntax
