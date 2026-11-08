.\" document.ms - a simple groff document using the ms macros
.\" Build with: make   (or: groff -ms -Tpdf document.ms > document.pdf)
.TL
My First Roff Document
.AU
Your Name
.AI
Your Organization
.AB
This is a small example showing the basics of writing documents
with groff and the \f[I]ms\f[] macro package: headings, paragraphs,
lists, emphasis, code blocks, and a table.
.AE
.NH
Introduction
.PP
roff is a family of text formatting languages dating back to the 1960s.
Today the most common implementation is \fBgroff\fP, the GNU version.
Documents are plain text files with formatting requests that begin
with a dot at the start of a line.
.PP
Text can be \fIitalic\fP, \fBbold\fP, or \f[CW]monospaced\fP.
.NH
Lists
.PP
Here is a bulleted list:
.IP \(bu 2
First item
.IP \(bu 2
Second item
.IP \(bu 2
Third item
.PP
And a numbered list:
.IP 1. 3
Write the source file.
.IP 2. 3
Run groff.
.IP 3. 3
Read the output.
.NH
Code Example
.PP
Preformatted text goes between display markers:
.DS L
.ft CW
$ groff -ms -Tpdf document.ms > document.pdf
$ groff -ms -Tutf8 document.ms | less
.ft
.DE
.NH 2
A Subsection
.PP
Subsections use \fB.NH 2\fP.  Section numbers are generated
automatically.
.NH
A Table
.PP
Tables are written with the \fBtbl\fP preprocessor
(enabled by the \fB-t\fP flag in the Makefile).
.TS
center box;
cb cb cb
l  l  r.
Tool	Purpose	Year
roff	Original formatter	1970
troff	Typesetter output	1973
groff	GNU implementation	1990
.TE
.NH
Conclusion
.PP
That is all you need to get started.  Edit \fBdocument.ms\fP,
run \fBmake\fP, and see the result.
