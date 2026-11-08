# Portable: works with FreeBSD make (bmake) and GNU make.
# Requires groff from ports/pkg:  pkg install groff

NAME  = document
GROFF = groff -t -ms

all: ${NAME}.pdf

pdf: ${NAME}.pdf

txt: ${NAME}.txt

${NAME}.pdf: ${NAME}.ms
	${GROFF} -Tpdf ${NAME}.ms > ${NAME}.pdf

${NAME}.txt: ${NAME}.ms
	${GROFF} -Tutf8 ${NAME}.ms | col -bx > ${NAME}.txt

view: ${NAME}.txt
	less ${NAME}.txt

clean:
	rm -f ${NAME}.pdf ${NAME}.txt

.PHONY: all pdf txt view clean
