# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gnucap/gnucap-20060830.ebuild,v 1.6 2007/02/08 13:29:50 opfer Exp $

MY_PV="${PV:0:4}-${PV:4:2}-${PV:6}"

DESCRIPTION="GNUCap is the GNU Circuit Analysis Package"
SRC_URI="http://geda.seul.org/dist/gnucap-${MY_PV}.tar.gz"
HOMEPAGE="http://www.geda.seul.org/tools/gnucap"

IUSE="doc examples"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc"

DEPEND="doc? ( virtual/tetex )"
S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A} || die "Failed to unpack!"
	cd ${S}

	# No need to install COPYING and INSTALL
	sed -i \
		-e 's: COPYING INSTALL::' \
		-e 's:COPYING history INSTALL:history:' \
		doc/Makefile.in || die "sed failed"

	if ! use doc ; then
		sed -i \
			-e 's:SUBDIRS = doc examples man:SUBDIRS = doc examples:' \
			Makefile.in || die "sed failed"
	fi

	if ! use examples ; then
		sed -i \
			-e 's:SUBDIRS = doc examples:SUBDIRS = doc:' \
			Makefile.in || die "sed failed"
	fi
}

src_install () {
	make DESTDIR=${D} install || die "Installation failed"
}
