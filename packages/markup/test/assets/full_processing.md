# Full Processing

## Table of Contents

<!-- markup:toc /-->

## Mermaid

```mermaid
graph LR
    A[Square Rect] -- Link text --> B((Circle))
    A --> C(Round Rect)
    B --> D{Rhombus}
    C --> D
```

```mermaid type: svg
---
title: Animal example
---
classDiagram
    note "From Duck till Zebra"
    Animal <|-- Duck
    note for Duck "can fly<br>can swim<br>can dive<br>can help in debugging"
    Animal <|-- Fish
    Animal <|-- Zebra
    Animal : +int age
    Animal : +String gender
    Animal: +isMammal()
    Animal: +mate()
    class Duck{
        +String beakColor
        +swim()
        +quack()
    }
    class Fish{
        -int sizeInFeet
        -canEat()
    }
    class Zebra{
        +bool is_wild
        +run()
    }
```

```mermaid {"type": "png", "backgroundColor": "#000", "width": 800}
flowchart TD
    Start --> Stop
```

---

## Code with Comment

```bash
# Say Hello
echo "Hello"
```

---

## DrawIO

<!-- markup:drawio {"file": "drawio/infographic.drawio"} /-->

---

## Fences

````
```markdown
<!-- markup:file {"file": "../../LICENSE"} /-->
```
````

<!-- markup:ignore -->

## Ignore

<!-- markup:file {"file": "../../LICENSE"} /-->
<!-- /markup:ignore -->

## Template

<!-- markup:template
template: "# Hello World"
/-->

```

```
