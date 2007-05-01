# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/worker/worker-2.14.4.ebuild,v 1.2 2007/05/01 09:36:29 armin76 Exp $

inherit eutils

DESCRIPTION="Worker Filemanager: Amiga Directory Opus 4 clone"
HOMEPAGE="http://www.boomerangsworld.de/worker/"
SRC_URI="http://www.boomerangsworld.de/worker/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="avfs unicode"
#S="${WORKDIR}/${P/_}"

DEPEND="|| ( x11-libs/libSM virtual/x11 )
	avfs? ( sys-fs/avfs )"

src_compile() {
	econf	$(use_enable unicode utf-8) \
		$(use_with avfs) || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	einstall || die "make install failed"
	doman man/worker.1
	dodoc AUTHORS ChangeLog INSTALL NEWS README README_LARGEFILES THANKS
	make_desktop_entry ${PN} Worker WorkerIcon.xpm "FileManager"
}
