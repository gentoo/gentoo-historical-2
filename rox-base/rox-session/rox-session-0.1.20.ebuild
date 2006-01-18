# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-base/rox-session/rox-session-0.1.20.ebuild,v 1.3 2006/01/18 20:36:58 vanquirius Exp $

MY_PN="ROX-Session"
DESCRIPTION="Rox-Session is a really simple session manager"
HOMEPAGE="http://rox.sourceforge.net/rox_session.html"
SRC_URI="mirror://sourceforge/rox/${MY_PN}-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc"
IUSE=""

DEPEND="rox-base/rox"

S="${WORKDIR}/${MY_PN}-${PV}/${MY_PN}"

src_compile() {
	./AppRun --compile || die
}

src_install() {
	rm -rf src || die
	dodir /usr/share/${MY_PN}

	cp -rf * "${D}"/usr/share/${MY_PN} || die
	dobin "${FILESDIR}"/${MY_PN} || die
}
