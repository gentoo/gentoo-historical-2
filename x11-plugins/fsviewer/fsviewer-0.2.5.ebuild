# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/fsviewer/fsviewer-0.2.5.ebuild,v 1.1 2005/06/22 21:38:59 smithj Exp $

inherit eutils

MY_PN="FSViewer"

DESCRIPTION="file system viewer for Window Maker"
HOMEPAGE="http://www.bayernline.de/~gscholz/linux/fsviewer/"
SRC_URI="http://www.bayernline.de/~gscholz/linux/${PN}/${MY_PN}.app-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

IUSE=""

DEPEND="virtual/x11
	x11-wm/windowmaker"

S="${WORKDIR}/${MY_PN}.app-${PV}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-windowmaker.patch
}

src_compile() {
	econf --with-appspath=/usr/lib/GNUstep \
		--with-extralibs=-lXft \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}
