# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/treeline/treeline-0.7.3-r1.ebuild,v 1.3 2004/05/26 20:01:15 taviso Exp $

inherit eutils python

DESCRIPTION="TreeLine is a structured information storage program."
HOMEPAGE="http://www.bellz.org/treeline/"

SRC_URI="http://www.bellz.org/treeline/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"
IUSE="spell"

DEPEND="spell? ( || ( app-text/aspell app-text/ispell ) )
	|| ( dev-python/pyxml dev-libs/expat )
	virtual/python dev-python/PyQt
	>=x11-libs/qt-3.3.0-r1"

S=${WORKDIR}/TreeLine

src_compile() {
	printf '#!/bin/sh\n\nexec python %s/treeline.py $*\n' \
		/usr/lib/treeline > ${T}/treeline
}

src_install() {
	dodir /usr/lib/treeline /usr/share/icons

	insinto /usr/lib/treeline
	doins ${S}/source/*.py ${S}/doc/README.html

	insinto /usr/share/icons
	doins ${S}/icons/*.png

	dodoc ${S}/doc/LICENSE ${S}/doc/*.trl
	dohtml ${S}/doc/README.html

	dobin ${T}/treeline
	prepalldocs
}

pkg_postinst() {
	python_mod_optimize /usr/lib/treeline
}

pkg_postrm() {
	python_mod_cleanup /usr/lib/treeline
}
