# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-config/java-config-0.2.8-r2.ebuild,v 1.5 2003/10/22 11:54:14 darkspecter Exp $

IUSE=""

S=${WORKDIR}/${P}
DESCRIPTION="Utility to change the Java Virtual Machine being used"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ~alpha amd64"

DEPEND="virtual/glibc"

src_install () {
	dobin ${FILESDIR}/${PV}/java-config
	doman ${FILESDIR}/${PV}/java-config.1

	insinto /etc/env.d
	doins ${FILESDIR}/${PV}/30java-finalclasspath
}
