# Security Policy

This policy covers every repository in the
[odin-html](https://github.com/odin-html) organization.

## Reporting a vulnerability

Please report security issues privately, through GitHub's **private
vulnerability reporting**: open the affected repository, go to the
**Security** tab, and choose **Report a vulnerability**. That keeps the
report visible only to the maintainers until a fix exists.

Please do not open a public issue for a suspected vulnerability.

Useful things to include: the affected repository and commit, the code
that triggers the problem (the element or component call and the values
passed to it), the markup it produced, and what you observed — markup a
browser parses differently from what the call meant, a crash, or a hang.

## What is in scope

These are **libraries** that write untrusted values into HTML, which is
where the interesting failures live:

- Escaping failures: text or an attribute value that reaches the output
  unescaped, or escaped for the wrong context, so that a caller-supplied
  string can open an element, close an attribute or inject script.
- In odin-html-ui's client half, a custom element that turns
  server-rendered text into markup or script it was not meant to be.
- Memory safety and unbounded allocation driven by the values being
  rendered.

Out of scope: anything that requires the caller to violate a documented
contract. In particular, output the API documents as **raw** — written to
the page without escaping — is the caller's to make safe, and using it with
untrusted input is a caller bug, not a vulnerability.

## Supported versions

The projects are pre-1.0 and under active development, with no release yet.
Fixes land on `main`; there are no maintained release branches.
