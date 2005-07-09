# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/profuse/profuse-0.22.0-r1.ebuild,v 1.5 2005/07/09 02:35:44 swegener Exp $

DESCRIPTION="use flags editor, with good features and 3 GUIs (dialog, ncurses and gtk2)."
HOMEPAGE="http://libconf.net/profuse/"
SRC_URI="http://libconf.net/profuse/download/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-*"
IUSE="gtk ncurses"

RDEPEND="dev-lang/perl
>=dev-util/dialog-1.0.20050206
dev-perl/TermReadKey
>=dev-util/libconf-0.39.16
gtk? ( >=dev-perl/gtk2-fu-0.08 )
!ppc64? ( ncurses? ( dev-perl/Curses-UI ) )"

src_install() {
	make install PREFIX="${D}"/usr || die "make install failed"
}
