# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unarj/unarj-2.63a.ebuild,v 1.5 2002/08/16 02:34:18 murphy Exp $

DESCRIPTION="Utility for opening arj archives."
HOMEPAGE="http://ibiblio.org/pub/Linux/utils/compress/"
SRC_URI="http://ibiblio.org/pub/Linux/utils/compress/${P}.tar.gz"

SLOT="0"
LICENSE="arj"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND=">=sys-apps/baselayout-1.8.0"

src_compile () {
	emake || die
}

src_install () {
	insinto /opt/bin
	doins unarj
	dodoc unarj.txt technote.txt readme.txt
}
