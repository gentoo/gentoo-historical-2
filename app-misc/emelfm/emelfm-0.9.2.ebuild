# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-misc/emelfm/emelfm-0.9.2.ebuild,v 1.2 2002/07/11 06:30:16 drobbins Exp $

S=${WORKDIR}/${P}

DESCRIPTION="A file manager that implements the popular two-pane design."
SRC_URI="http://emelfm.sourceforge.net/${P}.tar.gz"
HOMEPAGE="http://emelfm.sourceforge.net/"

DEPEND="virtual/glibc
	=x11-libs/gtk+-1.2*"

src_unpack() {
	unpack ${A}
	patch -p0 <${FILESDIR}/po-cs-po-gentoo.patch
	patch -p0 <${FILESDIR}/makefile-nls-gentoo.patch
}

src_compile() {
	local myconf 

	if use nls ; then
		make PREFIX=/usr \
			CC="gcc ${CFLAGS}" \
			NLS=-DENABLE_NLS || die
	else 
		make PREFIX=/usr \
			CC="gcc ${CFLAGS}" \
			NLS= || die
	fi
}

src_install () {
	dodir /usr/bin

	if use nls ; then
		make PREFIX=${D}/usr \
			NLS=-DENABLE_NLS \
			DOC_DIR=${D}/usr/share/doc/${P} \
			install || die
	else 
		make PREFIX=${D}/usr NLS= \
			DOC_DIR=${D}/usr/share/doc/${P} \
			install || die
	fi

	gzip ${D}/usr/share/doc/${P}/*.txt
}
