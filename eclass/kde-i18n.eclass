# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/kde-i18n.eclass,v 1.15 2002/04/20 09:55:11 danarmak Exp $
inherit kde kde.org 
ECLASS=kde-i18n

S=${WORKDIR}/${PN}
DESCRIPTION="KDE ${PV} - i18n: ${PN}"
HOMEPAGE="http://www.kde.org/"

myconf="$myconf --enable-final"

need-kde ${PV}

SRC_URI="$SRC_URI http://www.ibiblio.org/gentoo/distfiles/kde-i18n-gentoo.patch"

kde-i18n_src_unpack() {
    unpack ${A//kde-i18n-gentoo.patch} || die
    cd ${S}
    patch -p0 < ${DISTDIR}/kde-i18n-gentoo.patch
    echo Please ignore possible errors about rejected patch above
}

EXPORT_FUNCTIONS src_unpack