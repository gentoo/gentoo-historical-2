# Copyright 2001-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-config/java-config-0.2.6.ebuild,v 1.2 2002/10/04 05:10:56 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Gentoo-specific configuration for Java"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/~karltk/projects/java-config"
DEPEND=""
#RDEPEND=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64"

src_install () {
	dobin ${FILESDIR}/${PV}/java-config
	doman ${FILESDIR}/${PV}/java-config.1
}
