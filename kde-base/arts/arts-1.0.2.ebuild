# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/kde-base/arts/arts-1.0.2.ebuild,v 1.11 2002/08/13 09:26:02 danarmak Exp $
inherit kde-base flag-o-matic

SRC_URI="mirror://kde/stable/3.0.2/src/${P}.tar.bz2"
KEYWORDS="x86 ppc"
HOMEPAGE="http://multimedia.kde.org"
DESCRIPTION="KDE 3.x Sound Server"
set-kdedir 3
need-qt 3.0.3

if [ "${COMPILER}" == "gcc3" ]; then
# GCC 3.1 kinda makes arts buggy and prone to crashes when compiled with 
# these.. Even starting a compile shuts down the arts server
filter-flags "-fomit-frame-pointer -fstrength-reduce"

fi

SLOT="1"
LICENSE="GPL-2 LGPL-2"

use alsa && myconf="$myconf --enable-alsa" || myconf="$myconf --disable-alsa"

src_unpack() {
    
    base_src_unpack
    
    kde_sandbox_patch ${S}/soundserver

}

src_install() {

    kde_src_install
    dodoc ${S}/doc/{NEWS,README,TODO}

}
