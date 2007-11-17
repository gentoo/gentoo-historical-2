# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/mrouted/mrouted-3.9_beta3.ebuild,v 1.13 2007/11/17 23:03:46 vapier Exp $

inherit eutils

MY_P="${P/_}+IOS12"
DEB_PVER=3
DESCRIPTION="IP multicast routing daemon"
HOMEPAGE="http://freshmeat.net/projects/mrouted/?topic_id=87%2C150"
SRC_URI="ftp://ftp.research.att.com/dist/fenner/mrouted/${MY_P}.tar.gz
	mirror://debian/pool/non-free/m/mrouted/mrouted_${PV/_/-}-${DEB_PVER}.diff.gz"

LICENSE="Stanford"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-util/yacc"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/mrouted_${PV/_/-}-${DEB_PVER}.diff
	sed -i "/^CFLAGS/s:-O:${CFLAGS}:" Makefile
}

src_install() {
	dobin mrouted || die
	doman mrouted.8 || die

	insinto /etc
	doins mrouted.conf || die
	newinitd "${FILESDIR}"/mrouted.rc mrouted || die
}
