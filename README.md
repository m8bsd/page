# Simple roff project (FreeBSD)

A minimal groff document using the `ms` macro package.

## Files

- `document.ms` - the source document
- `Makefile` - build rules (works with FreeBSD `make`)

## Requirements

FreeBSD's base system only includes `mandoc`, so install groff:

    pkg install groff

This puts `groff` in `/usr/local/bin`. Make sure that is in your `PATH`.

## Build

    make          # builds document.pdf
    make txt      # builds plain-text document.txt
    make view     # preview in the terminal
    make clean    # remove generated files

Without make:

    groff -t -ms -Tpdf document.ms > document.pdf
    groff -t -ms -Tutf8 document.ms | less

## Notes

- If you only want to use what ships with the base system, `mandoc`
  handles man pages (`-man` / `-mdoc`), but not the `ms` macros or
  `tbl`-heavy documents like this one. Use groff for those.
- Open the PDF with a viewer such as `pkg install zathura-pdf-poppler`
  or `pkg install xpdf`.

## Cheat sheet

| Request | Meaning |
|---------|---------|
| `.TL` / `.AU` / `.AI` | Title, author, institution |
| `.AB` / `.AE` | Abstract begin / end |
| `.NH [level]` | Numbered heading |
| `.PP` | New paragraph |
| `.IP mark indent` | Indented list item |
| `.DS` / `.DE` | Display (preformatted) block |
| `.TS` / `.TE` | Table (needs `-t`) |
| `\fBbold\fP`, `\fIitalic\fP` | Inline fonts |
