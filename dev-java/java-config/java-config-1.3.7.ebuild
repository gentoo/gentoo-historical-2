# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-config/java-config-1.3.7.ebuild,v 1.7 2006/10/15 15:59:55 nichoj Exp $

inherit base distutils eutils

DESCRIPTION="Java environment configuration tool"
HOMEPAGE="http://www.gentoo.org/proj/en/java/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="virtual/python
	dev-java/java-config-wrapper"

src_install() {
	distutils_src_install
	newbin java-config java-config-1
	doman java-config.1

	doenvd 30java-finalclasspath
}

pkg_postinst() {
	elog "The way Java is handled on Gentoo has been recently updated."
	elog "If you have not done so already, you should follow the"
	elog "instructions available at:"
	elog "\thttp://www.gentoo.org/proj/en/java/java-upgrade.xml"
	elog
	elog "While we are moving towards the new Java system, we only allow"
	elog "1.3 or 1.4 JDKs to be used with java-config-1 to ensure"
	elog "backwards compatibility with the old system."
	elog "For more details about this, please see:"
	elog "\thttps://overlays.gentoo.org/proj/java/wiki/Why_We_Need_Java14"
}
