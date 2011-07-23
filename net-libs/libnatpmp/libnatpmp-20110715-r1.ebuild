# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnatpmp/libnatpmp-20110715-r1.ebuild,v 1.1 2011/07/23 10:33:26 blueness Exp $

EAPI=4

inherit eutils

DESCRIPTION="An alternative protocol to UPnP IGD specification."
HOMEPAGE="http://miniupnp.free.fr/nat-pmp.html"
SRC_URI="http://miniupnp.free.fr/files/download.php?file=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/respect-FLAGS.patch
	use !static-libs && epatch "${FILESDIR}"/remove-static-lib.patch
}

src_install() {
	emake PREFIX="${D}" install
}
