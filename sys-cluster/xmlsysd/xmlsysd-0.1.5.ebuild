# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/xmlsysd/xmlsysd-0.1.5.ebuild,v 1.6 2006/10/28 12:40:08 swegener Exp $

DESCRIPTION="A beowulf monitor daemon."
SRC_URI="http://www.phy.duke.edu/~rgb/Beowulf/xmlsysd/${PN}.tgz"
HOMEPAGE="http://www.phy.duke.edu/~rgb/Beowulf/xmlsysd.php"

KEYWORDS="~x86 ~ppc"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="virtual/inetd
		virtual/libc
		dev-libs/libxml
		sys-libs/zlib
		sys-libs/ncurses"
RDEPEND=""

S=${WORKDIR}/${PN}

src_compile() {
	make || die "Make failed"
}

src_install() {
	dosbin xmlsysd
	doman xmlsysd.8

	insinto /etc/xinetd.d
	newins ${FILESDIR}/xmlsysd.xinetd xmlsysd
	dodoc CHANGES DESIGN README TODO
}


pkg_postinst() {
	einfo "If you havent done so already please execute the following command"
	einfo "\"emerge --config =${CATEGORY}/${PF}\""
	einfo "to add xmlsysd to /etc/services."
	einfo
	einfo "Be sure to edit /etc/xinetd.d/xmylsysd to suit your own options."
	einfo
}

pkg_config() {
	echo "xmlsysd		7887/tcp	# xmlsysd remote system stats" >> /etc/services
	einfo "Added xmlsysd to /etc/services"
}
