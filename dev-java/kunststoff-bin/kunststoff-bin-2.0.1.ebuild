# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/kunststoff-bin/kunststoff-bin-2.0.1.ebuild,v 1.3 2004/06/24 22:38:11 agriffis Exp $

inherit java-pkg

DESCRIPTION="A famous Java Look & Feel from incors.org"
HOMEPAGE="http://www.incors.org"
SRC_URI="http://www.incors.org/${PN/-bin}-${PV//./_}.zip"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64 ~ia64"
IUSE=""
DEPEND=""
RDEPEND=">=virtual/jdk-1.3"
S=${WORKDIR}

src_compile() { :; }

src_install() {
	java-pkg_dojar *.jar
}
