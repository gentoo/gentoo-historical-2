# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdbakeoven/cdbakeoven-1.7.1.ebuild,v 1.1 2001/12/10 17:50:59 verwilst Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base || die

need-kdelibs 2.2
need-qt 2.2

DESCRIPTION="CDBakeOven, KDE CD Writing Software"
SRC_URI="http://prdownloads.sourceforge.net/cdbakeoven/cdbakeoven_generic-${PV}.tar.bz2"
HOMEPAGE="http://cdbakeoven.sourceforge.net"

S=${WORKDIR}/cdbakeoven_generic-${PV}

NEWDEPEND=">=kde-base/kdebase-2.2
	>=media-libs/libogg-1.0_rc2
	>=media-sound/mpg123-0.59
	>=media-sound/cdparanoia-3.9.8
	>=app-cdr/cdrtools-1.11"

DEPEND="$DEPEND $NEWDEPEND"
RDEPEND="$RDEPEND $NEWDEPEND"

src_unpack() {

    base_src_unpack
    cd ${S}
    ln -s Makefile.dist Makefile.cvs
    kde-objprelink-patch

}

