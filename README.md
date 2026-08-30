**Table of Contents**

<!-- markup:toc /-->

## Introduction

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

<!-- links -->

[template_expression]: https://pub.dev/packages/template_expressions
