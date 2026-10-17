# odin-html

Server-rendered HTML for the [Odin](https://odin-lang.org) programming
language, written from scratch in Odin, **with no dependencies beyond Odin's
`core:` library**.

Two libraries — a builder, and a component library on top of it. Each depends
only downward, and each is usable on its own.

```
odin-html-builder   elements, attributes, components, render
      |
      +-- odin-html-ui   server-rendered UI components, with custom
                         elements that enhance them in the browser
```

| Project | What it does | Status |
| --- | --- | --- |
| **[odin-html-builder](https://github.com/odin-html/odin-html-builder)** | An HTML builder where the caller's scope is the element: every element closes itself when the block that opened it ends, so a missing or mismatched tag cannot be written. Attributes, components with children, and htmx attribute helpers | Being set up, no release yet |
| **[odin-html-ui](https://github.com/odin-html/odin-html-ui)** | About forty UI components in the shadcn style — alert, badge, button, card, dialog, tabs and more — ported from templui, one package each. Components that need behaviour have a client half: a TypeScript custom element that enhances the server's markup and never supplies it | Being set up, no release yet |

## What these are

Libraries, not applications. The builder writes HTML and the components write
markup; there is no server, router or templating language anywhere in the
family, by design — Odin procedures are the templates.

A page built from these components is complete without JavaScript. Where a
component needs the browser, its client half is a custom element that adds
behaviour to the markup already there, and the contract between the two halves
is a file both sides test against. Everything is idiomatic Odin: explicit
memory management, allocator awareness, and rendering that streams to a writer
rather than building a tree.

Start with [odin-html-builder](https://github.com/odin-html/odin-html-builder)
— everything else in the family writes its HTML through it.
