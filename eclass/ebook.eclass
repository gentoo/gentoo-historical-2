# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/ebook.eclass,v 1.13 2004/02/25 17:30:11 aliz Exp $
#
# Author Francisco Gimeno <kikov@fco-gimeno.com>
# Mantainer Jos� Alberto Su�rez L�pez <bass@gentoo.org>
# 
# Latest changes thanks to Kris Verbeeck
# The ebook eclass defines some default functions and variables to 
# install ebooks. 

ECLASS=ebook
INHERITED="$INHERITED $ECLASS"
HOMEPAGE="http://lidn.sourceforge.net"

SLOT="0"
LICENSE="OPL"
KEYWORDS="x86 ppc amd64"

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

if [ "${EBOOKEXT}" = "" ]; then
	ext="tar.gz"
else
	ext="${EBOOKEXT}"
fi

if [ "${SRC}" = "" ]; then
	SRC="${_src}"
fi
if [ "${SRC_URI}" = "" ]; then
	SRC_URI="http://lidn.sourceforge.net/books_download/${SRC}.${ext}"
fi    
    
# Default directory to install de ebook devhelped book
if [ "${DEVHELPROOT}" = "" ]; then
	DEVHELPROOT="usr/share/devhelp"
fi
if [ "${RDEPEND}" = "" ]; then
	# FIXME: newdepend sets both DEPEND and RDEPEND
	# this should be changed to newrdepend, but that doesn't exist right now.
	newdepend ">=dev-util/devhelp-0.6"
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
	EBOOKDEVHELPFILE=${_ebookdevhelpfile}".devhelp"
fi

S=${WORKDIR}
ebook_src_unpack() {
	debug-print-function $FUNCNAME $*
	unpack ${SRC}.${ext}
}

ebook_src_install() {
	debug-print-function $FUNCNAME $*
	
	dodir ${DEVHELPROOT}/books
	dodir ${DEVHELPROOT}/books/${EBOOKDESTDIR}
	echo EBOOKSRCDIR= ${EBOOKSRCDIR}
	cp ${S}/book.devhelp ${D}${DEVHELPROOT}/books/${EBOOKDESTDIR}/${EBOOKDEVHELPFILE}
	cp -R ${S}/book/* ${D}${DEVHELPROOT}/books/${EBOOKDESTDIR}
}

EXPORT_FUNCTIONS src_unpack src_install
