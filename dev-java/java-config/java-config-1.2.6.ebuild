# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-config/java-config-1.2.6.ebuild,v 1.7 2004/06/24 22:30:57 agriffis Exp $

inherit distutils

DESCRIPTION=" Java enviroment configuration tool"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/java-config-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
RDEPEND="virtual/python"
KEYWORDS="x86 alpha ia64 amd64 sparc ppc hppa"
IUSE=""

src_install() {
	distutils_src_install
	dobin ${S}/java-config
	doman ${S}/java-config.1

	insinto /etc/env.d
	doins ${S}/30java-finalclasspath
}
