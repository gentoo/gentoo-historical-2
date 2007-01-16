# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/slib/slib-2.4.6.ebuild,v 1.3 2007/01/16 14:13:13 hkbst Exp $

MY_P=${PN}2d6
S=${WORKDIR}/${PN}
DESCRIPTION="library providing functions for Scheme implementations"
SRC_URI="http://swissnet.ai.mit.edu/ftpdir/scm/OLD/${MY_P}.zip"
HOMEPAGE="http://swissnet.ai.mit.edu/~jaffer/SLIB.html"

SLOT="0"
LICENSE="public-domain BSD"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

RDEPEND="=dev-scheme/guile-1.6.7"
DEPEND="${RDEPEND}
	>=app-arch/unzip-5.21"

RESTRICT="test"

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
