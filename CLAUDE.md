# odin-html — server-rendered HTML for the Odin programming language

This directory is the shared checkout root for the family's repositories. It is
itself the organisation's `.github` repository — the public profile, the community
files every repository inherits, these scripts and this file — and the family's
projects are **separate repositories**, cloned beside this file by `init.sh` and
ignored by this one's `.gitignore` (`odin-html-*/`). **As of 2026-10-17 there are
two of them, both being set up, neither released.**

The family is written from scratch in Odin with no Odin dependencies beyond `core:`.
Each repository is independently usable and depends only *downward*:

```
odin-html-builder   the HTML builder: elements, attributes,    ← the foundation
      ↓             components, render. core: only.
      ↓
odin-html-ui        server-rendered UI components on the builder, one package
                    per component; a client half (TypeScript custom elements)
                    for the components that need browser behaviour.
```

Each repository is developed with the **Metis** tools and Metis MCP: `.metis/vision.md`
is the strategic source of truth, with initiatives, tasks, ADRs and backlog under
`.metis/`. Read the relevant `vision.md` and ADRs before making design decisions —
they record the *why* behind the contracts described below. This root has no Metis
project of its own, as odin-rdf's has none.

The family is run exactly like [odin-rdf](https://github.com/odin-rdf), the other
public Odin family: the same checkout layout, the same scripts, the same community
files and the same conventions. **Where this file has not settled something, odin-rdf's
convention is the one that applies** until this file says otherwise.

## The projects

### odin-html-builder — `HTML-*` — being set up (2026-10-17), no release

`git@github.com:odin-html/odin-html-builder.git`. Three packages under `html/`:

- **`html/h`** — elements, components and render. Every non-void element proc carries
  `@(deferred_out = close)`, so the caller's scope *is* the element and a missing or
  mismatched close is not expressible. The output sink lives in `context.user_ptr`,
  so a nested component is a plain `proc()` with no writer threaded through it.
  Components that take children are `_open` procs paired with `close_all` through
  `@(deferred_none = h.close_all)`; a component whose close never ran makes the
  render report itself malformed rather than complete. Entry points: `render`,
  `render_with`, `render_to_string`.
- **`html/a`** — attributes: typed constructors (`a.class`, `a.lang`, …) and the
  writer that escapes them.
- **`html/hx`** — htmx attribute helpers, built on `html/a`.

No dependency beyond `core:`. It is the foundation: anything that writes HTML in this
family writes it through `html/h`.

### odin-html-ui — `UI-*` — being set up (2026-10-17), no release

`git@github.com:odin-html/odin-html-ui.git`. A server-rendered UI component library on
the builder, shadcn-style, ported from [templui](https://templui.io), with the
direction to become [Basecoat](https://basecoatui.com)-inspired. About forty
components, **one package per component** under `ui/` (`ui/alert`, `ui/badge`,
`ui/button`, `ui/card`, `ui/dialog`, `ui/tabs`, …), each with its tests beside it.

Components that need browser behaviour have a **client half** in `web/src/ui`: a
`oh-*` custom element that **enhances server-rendered markup and never supplies it** —
the page is complete without JavaScript, and the element only adds behaviour to what
the Odin component already wrote. Each client half has a `*.contract.json` stating
the markup it relies on, and the Odin tests assert the server half against it, so
the two halves cannot drift apart silently.

`web/` is TypeScript, Vite and Tailwind, built with Bun. The Odin side depends
downward on the builder only.

## The placeholder consumer

`odin-html-app/` is a **local-only** project beside the repositories (ignored with
them by `odin-html-*/`, never pushed): the smallest program that renders a page with
one builder element and one ui component. It is the family's stand-in for a real
consumer — a need for a capability is stated against it, with evidence that stands on
its own, the way odin-rdf's needs are stated against `odin-rdf-app`. It declares both
collections and is the first thing to break if the layout below changes.

## Family-wide conventions

- **Libraries, not applications.** Primitives over frameworks: the builder writes HTML
  and the components write markup, and policy stays with consumers. No server, no
  router, no request handling, no templating language — Odin procs are the templates.
- **Markup first, behaviour second.** A component's server half is the component; the
  client half enhances what it rendered and never supplies markup of its own. A
  component that cannot be rendered usefully without JavaScript is a design question
  for an issue, not something to build.
- **Contracts are executable.** The `*.contract.json` beside each client half is the
  boundary between the two languages, and the Odin tests assert against it. A change
  to either half that the contract does not survive changes the contract in the same
  commit.
- **Suite-driven correctness.** odin-html has no W3C suite to vendor; until a
  repository records otherwise in its vision, odin-rdf's rule holds in its general
  form: executable tests define "done", not example programs. Ported components are
  golden-tested against the upstream output they were ported from, with the expected
  class tables restated rather than referenced. Suites run with
  `ODIN_TEST_FAIL_ON_BAD_MEMORY=true`. README examples, once there are READMEs, are
  compiled in `tests/readme`, as in odin-rdf.
- **Consume the interface, don't bypass it.** odin-html-ui reaches the output only
  through the builder's public API. Capability gaps become evidence-backed upstream
  proposals against the builder, never workarounds in a component.
- **Idiomatic Odin.** Explicit memory management, allocator awareness, straightforward
  procedural APIs, streaming over materialization — a render writes to an
  `io.Writer` and builds no tree.
- **Contract-level doc comments** on every public API — lifetimes, ownership and what a
  caller may rely on, not a restatement of the signature.
- **A release is not done until its consumers' Current State is re-read.** As in
  odin-rdf: when a repository here tags a release, walk its consumers, bump the CI pin,
  and re-read their vision's Current State for claims the release just falsified. Amend
  rather than rewrite — the old paragraph stands as the record, with a dated note
  saying what moved. Versioning follows odin-rdf: pre-1.0 `vX.Y.Z` tags, a published
  interface change bumping the minor.
- **Sibling checkouts, reached via collections** — never vendored copies. Each
  collection is a **repository root**, and packages are imported by their path inside
  it, as in odin-rdf:

  ```
  -collection:html=../odin-html-builder     import "html:html/h"
  -collection:ui=../odin-html-ui            import "ui:ui/badge"
  ```

  Declared in each `Makefile` and mirrored in `ols.json`. A collection resolves in the
  *importing* compilation, so anything that uses odin-html-ui must also declare
  `html:`, because the components' own sources import it. A consumer declares both.
  *(The two repositories' sources moved to this layout on 2026-10-17, while being
  set up; before it they imported the builder as `html:h`, with the collection
  pointing at `html/`. Nothing imports that way now.)*

## Commands

Not settled yet: neither repository has its Makefile as of 2026-10-17. Both are to be
`make`-driven as odin-rdf's repositories are, with the same contract:

```
make test    # the full suite, ODIN_TEST_FAIL_ON_BAD_MEMORY=true
make check   # vet every package with -vet -strict-style
make help    # list targets
make clean   # remove build/
```

**A change is not done until `make test` and `make check` are both green**; CI runs
exactly these. Each repository's own section here, and its README, take over the
details once they exist.

odin-html-ui's client half, from `web/` (Bun):

```
bun install
bun run build   # tsc, then vite build
bun run dev     # vite dev server
```

The family root itself:

```
./init.sh   # clone odin-html-builder and odin-html-ui beside this file
./pull.sh   # pull both
./push.sh   # push both
```
