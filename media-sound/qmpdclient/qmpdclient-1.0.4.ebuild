# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qmpdclient/qmpdclient-1.0.4.ebuild,v 1.1 2006/06/25 20:42:52 ticho Exp $

inherit eutils

DESCRIPTION="An easy to use MPD client written in Qt 4.1"
HOMEPAGE="http://havtknut.tihlde.org/qmpdclient"
SRC_URI="http://havtknut.tihlde.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=x11-libs/qt-4.1"

src_compile() {
#	if use debug; then
#		sed -ie 's/CONFIG -= debug/CONFIG += debug/' ${S}/src/src.pro || \
#				die 'sed failed in debug'
#	fi

	./configure || die "configure failed"
	emake || die "make failed"
}

src_install() {
	# Fix the path
	sed -ie "s%/usr/local%${D}/usr%g" ${S}/src/src.pro || die 'sed failed in path'

	make install || die 'Install failed!'

	dodoc README
	insinto /usr/share/pixmaps
	newins images/qmpdclient64.png 	qmpdclient64.png

	make_desktop_entry qmpdclient "QMPDclient" qmpdclient64.png "KDE;Qt;AudioVideo"
}
