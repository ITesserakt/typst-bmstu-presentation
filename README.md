# Typst package for BMSTU presentations

This repository provides a [Typst](https://typst.app/home/) package for creating presentations utilizing BMSTU style conventions and based on the [`touying`](https://typst.app/universe/package/touying/) presentation framework.

> BMSTU stands for [Bauman Moscow State Technical University](https://bmstu.ru/).

## Installation

Since this package is not yet included in the official [Typst package list](https://github.com/typst/packages), using it requires some manual setup.

One way to do this is by placing the package in your local Typst package directory:

```sh
git clone https://github.com/ITesserakt/typst-bmstu-presentation
mkdir -p $HOME/.local/share/typst/packages/bmstu-presentation/0.1.2
cp -rv typst-bmstu-presentation/* $HOME/.local/share/typst/packages/bmstu-presentation/0.1.2/
```

> These commands are intended for Linux and copy the package contents to your local Typst package path.

## Usage

A simple usage example may look like this:

```typst
#import "@local/bmstu-presentation:0.1.2": *

#show: template.with(
  author: "Some author",
  date: datetime.today().display(),
)

#title-slide(
  title: "Presentation title",
  subtitle: "Presentation subtitle",
)

#slide(title: "Introduction")[
  Hello, world!
]

#end-slide()
```

For more comprehensive example, see `example.typ` and `example.pdf` of the current repository.

The package exposes several helper functions:

| Function      | Description                          |
| ------------- | ------------------------------------ |
| `template`    | Main presentation template           |
| `slide`       | Standard content slide               |
| `title-slide` | BMSTU-styled title slide             |
| `end-slide`   | Final slide                          |
| `block`       | Highlighted content block            |
| `arrow-list`  | Styled list component                |
| `shaded`      | Helper for secondary/emphasized text |

## Fonts

The template is designed around the following fonts:

- Fira Sans
- New Computer Modern Math

To ensure correct rendering, provide the path to your fonts directory for the Typst compiler.

This can be done either via `TYPST_FONT_PATHS` environment variable or the `--font-paths` command line option.

**The first option:**

```sh
export TYPST_FONT_PATHS "${TYPST_FONT_PATHS}:$HOME/.local/share/typst/packages/bmstu-presentation/0.1.2/fonts"
```

**The second option:**

```sh
typst compile --font-paths $HOME/.local/share/typst/packages/bmstu-presentation/0.1.2/fonts <file.typ>
```

## License

This project is distributed under the MIT license.
