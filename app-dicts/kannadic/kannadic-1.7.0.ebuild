# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/kannadic/kannadic-1.7.0.ebuild,v 1.9 2006/03/15 15:44:50 caleb Exp $

DESCRIPTION="Graphical Canna style dictionary editor written for KDE"
HOMEPAGE="http://linux-life.net/program/cc/kde/app/kannadic/"
SRC_URI="http://linux-life.net/program/cc/kde/app/kannadic/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc"
IUSE="debug xinerama"

DEPEND="virtual/libc
	=kde-base/kdelibs-3*
	app-i18n/canna"

src_compile() {
	econf \
		`use_enable debug` \
		`use_with xinerama` \
		|| die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}

pkg_postinst() {
	einfo
	einfo "Currently KannaDic doesn't create a dictionary for you,"
	einfo "so you need to create one manually."
	einfo "e.g) If you are going to add user dictionary named \"personal\", run"
	einfo
	einfo "\t% mkdic user"
	einfo
	einfo "and add [1m:user \"personal\"[0m to (use-dictionary ...) in your ~/.canna"
	einfo "You may need to restart canna server in order to use your dictionary."
	einfo
}
