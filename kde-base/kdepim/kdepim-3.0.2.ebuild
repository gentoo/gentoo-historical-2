# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim/kdepim-3.0.2.ebuild,v 1.10 2002/10/05 05:39:14 drobbins Exp $

IUSE="pda"
inherit kde-dist

DESCRIPTION="KDE $PV - PIM (Personal Information Management) apps: korganizer..."
KEYWORDS="x86 ppc sparc sparc64"
DEPEND="$DEPEND sys-devel/perl"

newdepend "pda? ( >=dev-libs/pilot-link-0.11.1-r1 )"

use pda && myconf="$myconf --with-extra-includes=/usr/include/libpisock"

src_unpack() {
    base_src_unpack

    cd ${S}
    patch -p0 < ${FILESDIR}/kdepim-qt-3.0.5.patch
}

src_install() {
	kde_src_install
	docinto html
	dodoc *.html
}
