# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/arts/arts-1.1.0.4.ebuild,v 1.2 2002/11/20 14:06:54 danarmak Exp $
inherit kde-base flag-o-matic

# this is the arts 1.1.0 from kde 3.1, as opposed to the arts 1.1.0 from kde 3.1 beta2

S=$WORKDIR/$PN-1.1.0
SRC_URI="mirror://gentoo/arts-1.1.0-kde31.tar.bz2"
KEYWORDS="x86"
HOMEPAGE="http://multimedia.kde.org"
DESCRIPTION="aRts, the KDE sound (and all-around multimedia) server/output manager"
set-kdedir 3.1
need-qt 3.1.0

if [ "${COMPILER}" == "gcc3" ]; then
    # GCC 3.1 kinda makes arts buggy and prone to crashes when compiled with 
    # these.. Even starting a compile shuts down the arts server
    filter-flags "-fomit-frame-pointer -fstrength-reduce"
fi

SLOT="3.1"
LICENSE="GPL-2 LGPL-2"

use alsa && myconf="$myconf --enable-alsa" || myconf="$myconf --disable-alsa"

set_enable_final

src_unpack() {

    base_src_unpack
    
    kde_sandbox_patch ${S}/soundserver

}

src_install() {

    kde_src_install

    dodoc ${S}/doc/{NEWS,README,TODO}

}
