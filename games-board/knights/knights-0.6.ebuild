# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/knights/knights-0.6.ebuild,v 1.2 2003/11/14 01:47:25 weeve Exp $

inherit kde

need-kde 3

THEME=${PN}-themepack-0.5.9
DESCRIPTION="KDE Chess Interface"
SRC_URI="mirror://sourceforge/knights/${P}.tar.gz
	mirror://sourceforge/knights/${THEME}.tar.gz"
HOMEPAGE="http://knights.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc"

src_compile() {
	./configure \
		--datadir="${KDEDIR}" \
		|| die "./configure failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	cd ../${PN}-themepack || die "Themes seem to be missing."
	insinto ${KDEDIR}/share/apps/knights/themes/
	doins *.tar.gz
}
