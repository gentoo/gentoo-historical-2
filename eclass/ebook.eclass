# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Francisco Gimeno <kikov@fco-gimeno.com>
# Manteiner Jos� Alberto Su�rez L�pez <bass@gentoo.org>
# The ebook eclass defines some default functions and variables to 
# install ebooks. 
ECLASS=ebook
INHERITED="$INHERITED $ECLASS"
HOMEPAGE="http://lidn.sourceforge.net"
# ebook eclass user guide:
# -vars
#
#  EBOOKNAME: the main name of the book ( without versions ), i.e: gtk
#             Required
#  EBOOKVERSION: the version of the book, i.e: 1.2
#	      Required
#  SRC: the main file to download. Default: ${EBOOKNAME}-${EBOOKVERSION}
#  EBOOKDESTDIR: directory inside ${DEVHELPROOT}/books/${EBOOKDIR} where is 
#          installed the book. By default: ${EBOOKNAME}-${EBOOKVERSION} 
#          ( sometimes it is only ${EBOOKNAME} so you will need to modify it )
#  EBOOKSRCDIR: directory where is the unpacked book in html
#  BOOKDEVHELPFILE: book.devhelp is copied with the name  
#          ${EBOOKNAME}-${EBOOKVERSION} by default.
#  BOOKDESTDIR: directory to put into the ebook in html. By default: 
#	   ${EBOOKNAME}-${EBOOKVERSION}.
#  NOVERSION: if it's not empty, then, remove -${EBOOKVERSION} from all
#          vars...
#  DEVHELPROOT: usually usr/share/devhelp
if [ "${NOVERSION}" = "" ]; then
    _src="${EBOOKNAME}-${EBOOKVERSION}"
else
    _src="${EBOOKNAME}"
fi
    _ebookdestdir="${_src}"
    _ebooksrcdir="${_src}"
    _ebookdevhelpfile="${_src}"    

if [ "${SRC}" = "" ]; then
    SRC="${_src}"
fi
if [ "${SRC_URI}" = "" ]; then
    SRC_URI="http://lidn.sourceforge.net/books_download/${SRC}.tar.gz"
fi    
    
# Default directory to install de ebook devhelped book
if [ "${DEVHELPROOT}" = "" ]; then
    DEVHELPROOT="usr/share/devhelp"
fi
if [ "${RDEPEND}" = "" ]; then
    RDEPEND=">=dev-util/devhelp-0.3"
fi
if [ "${DESCRIPTION}" = "" ]; then
    DESCRIPTION="${P} ebook based in $ECLASS eclass"
fi
if [ "${EBOOKDESTDIR}" = "" ]; then
    EBOOKDESTDIR=${_ebookdestdir}
fi
if [ "${EBOOKSRCDIR}" = "" ]; then
    EBOOKSRCDIR=${_ebooksrcdir}
fi
if [ "${EBOOKDEVHELPFILE}" = "" ]; then
    EBOOKDEVHELPFILE=${_ebookdevhelpfile}
fi

S=${WORKDIR}/${EBOOKSRCDIR}
ebook_src_unpack() {
	debug-print-function $FUNCNAME $*
	unpack ${SRC}.tar.gz
}

ebook_src_install() {
	debug-print-function $FUNCNAME $*
	
	dodir ${DEVHELPROOT}/specs
	dodir ${DEVHELPROOT}/books
	dodir ${DEVHELPROOT}/books/${EBOOKDESTDIR}
	echo EBOOKSRCDIR= ${EBOOKSRCDIR}
	cp ${S}/book.devhelp ${D}${DEVHELPROOT}/specs/${EBOOKDEVHELPFILE}
	cp -R ${S}/book/* ${D}${DEVHELPROOT}/books/${EBOOKDESTDIR}
}

EXPORT_FUNCTIONS src_unpack src_install
