`wordperfect-pdftotext`
=======================

This repository contains a patch enabling Poppler to convert characters written with the "WP Typographic Symbols" font into their Unicode counteparts. It also contains a `Dockerfile` which builds a `pdftotext` executable patched in this way.

Example
-------

```console
$ wget http://www.illinoiscourts.gov/Opinions/SupremeCourt/2006/June/99977.pdf
$ pdftotext -f 27 -l 27 99977.pdf - | tail -n 10
The court Areject[s] the dissent=s attempt@ (slip op. at 11) to
distinguish Estelle. The court=s rejection is made without any real
discussion of the salient points of the United States Supreme Court=s
analysis as it fails to discuss the importance the invited-error doctrine
had on the United State Supreme Court=s analysis in refusing to
excuse the defendant=s procedural default.

-27-



$ docker run -i --rm willglynn/wordperfect-pdftotext -f 27 -l 27 - - < 99977.pdf | tail -n 10
The court “reject[s] the dissent’s attempt” (slip op. at 11) to
distinguish Estelle. The court’s rejection is made without any real
discussion of the salient points of the United States Supreme Court’s
analysis as it fails to discuss the importance the invited-error doctrine
had on the United State Supreme Court’s analysis in refusing to
excuse the defendant’s procedural default.

-27-


```
