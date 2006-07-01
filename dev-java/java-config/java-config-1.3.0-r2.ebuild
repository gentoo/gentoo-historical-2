# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-config/java-config-1.3.0-r2.ebuild,v 1.3 2006/07/01 19:11:13 nichoj Exp $

inherit distutils eutils

DESCRIPTION="Java environment configuration tool"
HOMEPAGE="http://www.gentoo.org/proj/en/java/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="virtual/python
	dev-java/java-config-wrapper"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-regexp.patch
}

src_install() {
	distutils_src_install
	newbin java-config java-config-1
	doman java-config.1

	doenvd 30java-finalclasspath
}

pkg_postinst() {
	einfo "The way Java is handled on Gentoo has been recently updated."
	einfo "If you have not done so already, you should follow the"
	einfo "instructions available at:"
	einfo "http://www.gentoo.org/proj/en/java/java-upgrade.xml"
}
