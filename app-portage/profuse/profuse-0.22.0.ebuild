# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/profuse/profuse-0.22.0.ebuild,v 1.4 2005/06/02 23:10:34 dams Exp $

IUSE=""

MY_P=${PN}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="use flags editor, with good features and 3 GUIs (dialog, ncurses and gtk2)."
HOMEPAGE="http://libconf.net/profuse/"
SRC_URI="http://libconf.net/profuse/download/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc ~sparc"
IUSE="gtk ncurses"

DEPEND="dev-lang/perl
>=dev-util/dialog-1.0.20050206
dev-perl/TermReadKey
>=dev-util/libconf-0.39.16
gtk? ( >=dev-perl/gtk2-fu-0.08 )
!ppc4? ( ncurses? ( dev-perl/Curses-UI ) )"

src_compile() {
	emake || die "make failed"
}

src_install() {
	einstall PREFIX=${D}/usr
}
