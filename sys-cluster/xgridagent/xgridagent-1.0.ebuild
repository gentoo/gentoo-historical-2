# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/xgridagent/xgridagent-1.0.ebuild,v 1.1 2004/06/24 16:30:13 dholm Exp $

DESCRIPTION="A simple system for setting up and using a cluster of OS X machines"
HOMEPAGE="http://www.novajo.ca/xgridagent/"
SRC_URI="http://www.novajo.ca/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~ppc"
IUSE=""
DEPEND=">=net-libs/roadrunner-0.9.1"

src_compile() {
	econf \
		--with-roadrunner-includedir=/usr/include/roadrunner-1.0 \
		--with-roadrunner-libdir=/usr/lib || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin xgridagent
	dodoc README
	insinto /usr/share/${PN}
	doins xgrid.config.xml
}
