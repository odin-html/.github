# odin-html

Server-rendered HTML for the [Odin](https://odin-lang.org) programming
language, written in Odin with no dependencies beyond `core:`.

This is the family's root repository (`odin-html/.github`): the organisation
profile, the community files every repository inherits, and the scripts that
check the family out. The libraries are separate repositories.

## The repositories

```
odin-html-builder   elements, attributes, components, render     core: only
      ↑
odin-html-ui        UI components on the builder, one package each,
                    with oh-* custom elements that enhance them in the browser
```

- **[odin-html-builder](https://github.com/odin-html/odin-html-builder)** — the
  HTML builder. An element is an Odin scope, so its closing tag is written when
  the block ends; text and attributes are escaped by default; a render goes to
  any `io.Writer`. Start here if you want to write HTML from Odin.
- **[odin-html-ui](https://github.com/odin-html/odin-html-ui)** — about forty
  shadcn-style components (alert, badge, button, card, dialog, tabs, …) ported
  from templui. Each renders complete markup on the server; the ones that need
  behaviour have a small custom element that adds it. Start here if you want
  ready-made components.

Each depends only downward: ui uses the builder, the builder uses nothing.
Both are being set up; neither has a release yet.

## Layout

Each repository is an Odin collection rooted at the repository, checked out
side by side and never vendored. Packages are imported by their path inside it:

```sh
odin build . -collection:html=../odin-html-builder -collection:ui=../odin-html-ui
```

```odin
import "html:html/h"
import "ui:ui/badge"
```

A program using odin-html-ui declares both collections, because the
components import `html:` themselves.

To get both checkouts beside this one:

```sh
git clone git@github.com:odin-html/.github.git odin-html
cd odin-html
./init.sh   # clones odin-html-builder and odin-html-ui here
./pull.sh   # pull both
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md); they
apply to every repository in the family.

## License

Each repository is MIT-licensed; see its `LICENSE`.
