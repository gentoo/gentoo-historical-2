# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmemload/wmmemload-0.1.4.ebuild,v 1.4 2003/09/24 18:57:12 weeve Exp $

S=${WORKDIR}/${P}

DESCRIPTION="dockapp that displays memory and swap space usage."
SRC_URI="http://www.markstaggs.net/wmmemload/${P}.tar.gz"
HOMEPAGE="http://www.markstaggs.net/"

SLOT="0"
KEYWORDS="x86 ~sparc"
LICENSE="GPL-2"

DEPEND="x11-base/xfree"

src_compile() {

	econf || die "configure failed"

	emake || die "parallel make failed"

}

src_install () {

	einstall || die "make install failed"

}

