# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/slib/slib-2.4.2.ebuild,v 1.11 2003/09/06 22:29:25 msterret Exp $

MY_P=${PN}2d2
S=${WORKDIR}/${PN}
DESCRIPTION="library providing functions for Scheme implementations"
SRC_URI="http://swissnet.ai.mit.edu/ftpdir/scm/${MY_P}.zip"
HOMEPAGE="http://swissnet.ai.mit.edu/~jaffer/SLIB.html"

SLOT="0"
LICENSE="public-domain BSD"
KEYWORDS="x86 sparc"

RDEPEND=">=dev-util/guile-1.4"
DEPEND="${RDEPEND}
	>=app-arch/unzip-5.21
	>=dev-util/guile-1.4"

src_install() {
	insinto /usr/share/guile/site/slib
	doins *.scm
	dodoc ANNOUNCE ChangeLog FAQ README
	doinfo slib.info
}

pkg_postinst() {
	if [ "${ROOT}" == "/" ] ; then
		einfo "Installing..."
		guile -c "(use-modules (ice-9 slib)) (require 'new-catalog)" "/"
	fi
}
