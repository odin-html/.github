# Contributing to the Odin HTML family

This file applies to every repository in the [odin-html](https://github.com/odin-html)
organization: [odin-html-builder](https://github.com/odin-html/odin-html-builder) and
[odin-html-ui](https://github.com/odin-html/odin-html-ui). Both are new — being set
up as of 2026-10-17, with no release yet — so expect the details below to move.

## Getting set up

The projects reach each other through **relative Odin collections**, not
vendored copies or submodules. Each collection is a repository root —
`-collection:html=../odin-html-builder`, `-collection:ui=../odin-html-ui` —
and packages are imported by their path inside it (`html:html/h`,
`ui:ui/badge`). The repositories must therefore sit side by side in one
directory:

```
odin-html/
├── odin-html-builder/
└── odin-html-ui/
```

Clone them into that layout — `init.sh` at the checkout root does it for
both. A collection resolves in the *importing* compilation, not the imported
checkout, so a project that uses the components also needs the builder
present — the components' own sources import `html:`.

The same mechanism carries projects *outside* the family, with one extra hop:
a consumer keeps its own checkout beside `odin-html/` rather than inside it,
and points its collections into that directory instead of at its own
siblings. A consumer — `odin-html-app` here — is laid out like this:

```
workspace/
├── odin-html/       ← the two repositories, as above
└── odin-html-app/   ← -collection:html=../odin-html/odin-html-builder, and so on
```

Nothing in the family requires that shape — the collection flags take any
path, and a consumer that keeps the checkout root elsewhere need only say so
once, in its own build. Keeping it adjacent is what lets the relative paths
committed to a Makefile work on a fresh clone.

## Building and testing

Every repository is to be `make`-driven:

```sh
make test    # the full suite
make check   # vet every package with -vet -strict-style
make help    # list targets
```

odin-html-ui's client half lives in `web/` and is built with Bun
(`bun install`, then `bun run build`).

**A change is not done until `make test` and `make check` are both green.**
CI runs exactly these, so there are no surprises waiting in the pull request.

## What correctness means here

- **Tests define "done."** A component is measured by what it renders, not
  by an example program. Ported components are golden-tested against the
  upstream output they were ported from, with the expected classes restated
  in the test rather than referenced from the component — a table that
  changed on both sides at once would prove nothing.
- **The client contract is tested from both sides.** A component with
  browser behaviour has a client half in `web/src/ui`, a custom element that
  enhances the server-rendered markup and never supplies it. Its
  `*.contract.json` states the markup the element relies on, and the Odin
  tests assert the server half against it. Change the contract in the same
  pull request as whichever half moved.
- **Memory is checked, not assumed.** Suites run with
  `ODIN_TEST_FAIL_ON_BAD_MEMORY=true`, promoting leaks and bad frees from
  warnings a passing build hides into failures.
- **README examples are compiled.** Each repository holds its README's code
  in `tests/readme` so documentation cannot drift from the API. If you
  change an example, change it in both places.

## Design conventions

- **Primitives over frameworks.** The builder writes HTML and the
  components write markup; policy stays with consumers. Servers, routers
  and templating languages are out of scope everywhere in the family.
- **Markup first.** A page built from these components is complete without
  JavaScript; the client half adds behaviour to it.
- **Consume the interface, don't bypass it.** The components reach the
  output only through the builder's public API. If something is missing,
  propose it upstream with the evidence that motivated it rather than
  working around it locally.
- **Idiomatic Odin.** Explicit memory management, allocator awareness,
  streaming over materialization, straightforward procedural APIs.
- **Public APIs carry contract documentation** — lifetimes, ownership, and
  what a caller may rely on, not a restatement of the signature.

## Architecture decisions

Non-obvious decisions are recorded as ADRs in each repository's `.metis/adrs/`
and referenced from the code they govern (`HTML-A-0001`, `UI-A-0001`, and so
on). If you are about to contradict one, that is worth discussing in an
issue first — and if the ADR is simply wrong, saying so is a welcome
contribution.

## Pull requests

Small and focused beats large and comprehensive. Explain *why* in the
commit message; the diff already shows *what*. If a change is a trade-off,
say what you traded and what you considered.

Bug reports are most useful with the code that triggers them — the
component call, its props, and the markup it produced — reduced as far as
you can get it.
