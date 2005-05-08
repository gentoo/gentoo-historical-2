# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvcgi/dvcgi-0.5.13.ebuild,v 1.1 2005/05/08 13:07:30 ka0ttic Exp $

DESCRIPTION="dvcgi provides a C++ interface for C++ cgi programs"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvcgi/html/"
SRC_URI="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvcgi/download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE="doc"

DEPEND="dev-libs/dvutil
	dev-libs/dvnet"

src_unpack() {
	unpack ${A}
	cd ${S}
	# install API docs manually if USE=doc
	sed -i 's/^\(SUBDIRS =.*\)doc\(.*\)$/\1\2/' Makefile.in || \
		die "sed Makefile.in failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog AUTHORS README NEWS

	if use doc ; then
		# dvutil provides dispatch.h.3
		rm doc/man/man3/dispatch.h.3
		doman doc/man/*/*.[0-9]
		dohtml -r doc/html/*
	fi
}
