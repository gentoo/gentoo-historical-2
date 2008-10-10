# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/overnet/overnet-1.3.0.ebuild,v 1.4 2008/10/10 10:54:25 flameeyes Exp $

DESCRIPTION="Overnet is the successor of eDonkey2000 that allows you to share files with millions of other people across the globe."
HOMEPAGE="http://www.overnet.com"
SRC_URI="http://www.zen18864.zen.co.uk/overnet/${PV}/overnetclc_${PV}_i386.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

S="${WORKDIR}"

RESTRICT="strip"

src_compile() {
	einfo "Distributed in binary.  No compilation required."
}

src_install() {
	mv usr "${D}"
}

pkg_postinst() {
	einfo "From now on this is the overnet only core."
	einfo "For the edonkey/overnet hybrid core install net-p2p/edonkey"
}
