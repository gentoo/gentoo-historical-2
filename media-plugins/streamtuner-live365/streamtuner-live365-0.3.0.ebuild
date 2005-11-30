# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: 

DESCRIPTION="A plugin for Streamtuner. It allow to play live365 streams"
SRC_URI="http://savannah.nongnu.org/download/streamtuner/streamtuner-live365.pkg/${PV}/${P}.tar.gz"
HOMEPAGE="http://www.nongnu.org/streamtuner/"
KEYWORDS="~x86"
SLOT="0"
LICENSE="as-is"

DEPEND=">=net-misc/streamtuner-0.9.0"
	

src_compile() {
    econf || die "./configure failed"
    emake || die
}

src_install () {
    make DESTDIR=${D} \
    sysconfdir=${D}/etc \
    install || die
    dodoc COPYING ChangeLog NEWS README INSTALL
} 

