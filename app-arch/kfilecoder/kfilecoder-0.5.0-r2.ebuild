# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Philippe Namias <pnamias@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-arch/kfilecoder/kfilecoder-0.5.0-r2.ebuild,v 1.3 2002/07/01 21:33:30 danarmak Exp $

inherit kde-base || die

DESCRIPTION="Archiver with passwd management "
SRC_URI="http://download.sourceforge.net/kfilecoder/${P}.tar.bz2"
HOMEPAGE="http://kfilecoder.sourceforge.net"
LICENSE="GPL-2"

need-kde 2.1.1

src_compile() {
    rm config.cache
    kde_src_compile
}

src_install () {
    make DESTDIR=${D} kde_locale=${D}/usr/share/locale install || die
    kde_src_install dodoc
}

