# Copyright 1999-2002 Gentoo Technologies, Inc. 
# Distributed under the terms of the GNU General Public License v2 
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qtella/qtella-0.5.3-r1.ebuild,v 1.1 2002/07/04 23:48:09 verwilst Exp $

use kde && inherit kde-base 

use kde && need-kde 3 
use kde || DEPEND="$DEPEND >=x11-libs/qt-3*"

LICENSE="GPL-2"
S=${WORKDIR}/${P}
SRC_URI="mirror://sourceforge/qtella/${P}.tar.gz"
HOMEPAGE="http://www.qtella.net"
DESCRIPTION="Excellent QT/KDE Gnutella Client"


src_compile() {

	local myconfig
	use kde && kde_src_compile myconf
        use kde && myconfig="${myconf}"
	use kde || myconfig="--with-kde=no --prefix=/usr --host=${CHOST} \
	--with-x --enable-mitshm --with-xinerama --with-qt-dir=${QTDIR}	\
	--enable-mt --disable-debug --without-debug"
	./configure ${myconfig} || die
	emake || die
}
