# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-config/java-config-1.2.6.ebuild,v 1.2 2004/02/18 09:40:05 dholm Exp $

inherit distutils

S=${WORKDIR}/${P}
DESCRIPTION=" Java enviroment configuration tool"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/java-config-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
RDEPEND="virtual/python"
#DEPEND="$DEPEND"
KEYWORDS="x86 ~alpha ~ia64 amd64 ~sparc ppc"
IUSE=""

src_install() {
	distutils_src_install
	dobin ${S}/java-config
	doman ${S}/java-config.1

	insinto /etc/env.d
	doins ${S}/30java-finalclasspath
}
