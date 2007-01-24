# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/slib/slib-3.1.4-r1.ebuild,v 1.1 2007/01/24 16:59:50 hkbst Exp $

inherit versionator eutils

#version magic thanks to masterdriverz and UberLord using bash array instead of tr
trarr="0abcdefghi"
MY_PV="$(get_version_component_range 1)${trarr:$(get_version_component_range 2):1}$(get_version_component_range 3)"

MY_P=${PN}${MY_PV}
S=${WORKDIR}/${PN}
DESCRIPTION="library providing functions for Scheme implementations"
SRC_URI="http://swiss.csail.mit.edu/ftpdir/scm/${MY_P}.zip"

HOMEPAGE="http://swiss.csail.mit.edu/~jaffer/SLIB"

SLOT="0"
LICENSE="public-domain BSD"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

#unzip for unpacking
#depend on guile for now, until slib actually works with another scheme implementation in portage
RDEPEND="~dev-scheme/guile-1.6.8"
DEPEND="app-arch/unzip
	${RDEPEND}"

# slib tests rely on scm being installed. It isn't even in portage :(
RESTRICT="test"

# maybe also do "make infoz"

src_install() {
	insinto /usr/share/slib/ #don't install directly into guile dir
	doins *.scm
	doins *.init
	dodoc ANNOUNCE ChangeLog FAQ README
	doinfo slib.info
	dosym /usr/share/slib/ /usr/share/guile/slib # link from guile dir
}

pkg_postinst() {
	einfo "Installing slib for guile..."
	${ROOT}/usr/bin/guile -c "(use-modules (ice-9 slib)) (require 'new-catalog)"
}
