# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmSMPmon/wmSMPmon-2.2.ebuild,v 1.7 2004/06/24 23:17:26 agriffis Exp $

S="${WORKDIR}/${PN}-2.x"

IUSE=""
DESCRIPTION="SMP system monitor dockapp"
HOMEPAGE="http://goupilfr.org/?soft=wmsmpmon"
SRC_URI="http://goupilfr.org/arch/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="virtual/glibc
	virtual/x11"

src_unpack() {
	unpack ${A} ; cd ${S}/wmSMPmon

	sed -i -e "s:-Wall -O3 -m486:${CFLAGS}:" Makefile
}

src_compile() {
	make || die "make failed"
	}

src_install() {

	cd ${S}/${PN}
	dobin wmSMPmon

}
