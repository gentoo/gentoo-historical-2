# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Philippe Namias <pnamias@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-gfx/kuickshow/kuickshow-0.8-r1.ebuild,v 1.7 2001/09/29 21:03:26 danarmak Exp $


A=${P}.tgz
S=${WORKDIR}/${P}
DESCRIPTION="Kuickshow image loader for kde2"
SRC_URI="http://master.kde.org/~pfeiffer/kuickshow/${A}"
HOMEPAGE="http://master.kde.org/~pfeiffer/kuickshow/"

DEPEND=">=kde-base/kdelibs-2.1.1 sys-apps/which
	>=media-libs/imlib-1.9.10"
RDEPEND=">=kde-base/kdelibs-2.1.1
	>=media-libs/imlib-1.9.10"

RDEPEND=$DEPEND

src_compile() {
    local myconf
    if [ "`use qtmt`" ]
    then
      myconf="--enable-mt"
    fi
      myconf="$myconf --enable-mitshm"
    try CXXFLAGS="-I/usr/X11R6/include $CXXFLAGS" ./configure --prefix=${KDEDIR} --host=${CHOST} $myconf
    try make

}

src_install () {

    try make DESTDIR=${D} install
    dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}

