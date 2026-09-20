## Mermaid Plugin for Markup

A Mermaid plugin for Markup that allows for the creation of Mermaid diagrams in Markdown files. It utilizes the [mermaid-cli](https://github.com/mermaid-js/mermaid-cli) to generate the diagrams. Because the mermaid syntax includes `-->` which is the end token for a HTML comment, the mermaid diagram must utilize the fence syntax rather than the tag or block syntax.

Unlike the tag and block syntax, the fence syntax is destructive in that the source is no longer preserved in the output. It is strongly recommented to utilize the output option and to avoid overwriting the source files.

## Config

This plugin utilizes the following config options within a `markup.yaml` config file:

```yaml
plugins:
  mermaid:
    command: markup_mermaid
    replace: true

    # Example to enable the max logging
    args:
      - log
      - FINEST

    # Already defaults to false, included for example purposes
    ignore-exit-code: false

    # Already defaults to false, included for example purposes
    post-processor: false
```

---

## Usage

1. Install this plugin:
   ```bash
   dart pub global activate markup_mermaid
   ```
1. Create the config file:
   ```yaml
   plugins:
   mermaid:
     command: markup_mermaid
     replace: true
   ```
1. Run markup to process the file.

---

## Parameters

Like the standard tag syntax, the options are passed as either JSON or YAML format. However, since it has to be on the same line, YAML's not the most useful if you need more than a single parameter so JSON is recommended.

Example:

<!-- markup:ignore -->

````markdown
```mermaid {"outputFormat": "png", "backgroundColor": "#000", "width": 800}
flowchart TD
    Start --> Stop
```
````

<!-- /markup:ignore -->

| Key               | Type     | Description                                                                                                           |
| ----------------- | -------- | --------------------------------------------------------------------------------------------------------------------- |
| `backgroundColor` | `String` | Background color for pngs/svgs (not pdfs). Example: transparent, red, '#F0F0F0'. (default: "white")                   |
| `height`          | `int`    | Height of the page (default: 600)                                                                                     |
| `output`          | `String` | The filename to output the diagram to.                                                                                |
| `outputFormat`    | `String` | Output format for the generated image. (choices: "svg", "png", "pdf", default: Loaded from the output file extension) |
| `scale`           | `int`    | Puppeteer scale factor (default: 1)                                                                                   |
| `theme`           | `String` | Theme of the chart (choices: "default", "forest", "dark", "neutral", default: "default")                              |
| `title`           | `String` | The image title to use within the markdown. Also known as the "alt text". Defaults to the output path.                |
| `width`           | `int`    | Width of the page (default: 800)                                                                                      |
