# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/screen/screen-3.9.11-r4.ebuild,v 1.2 2002/11/11 20:30:23 naz Exp $

S=${WORKDIR}/${P}
DESCRIPTION=" Screen is a full-screen window manager that multiplexes a
physical terminal between several processes"
SRC_URI="ftp://ftp.uni-erlangen.de/pub/utilities/screen/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/screen/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64 ~alpha"

DEPEND=">=sys-libs/ncurses-5.2"

src_unpack() {
	unpack ${A}
	cd ${S}
}
src_compile() {
	addpredict "`tty`"
	addpredict "${SSH_TTY}"

	econf \
		--with-sys-screenrc=/etc/screen/screenrc \
		--libexecdir=/usr/lib/misc || die
	emake || die
}

src_install () {
	dobin screen
	insinto /usr/share/terminfo
	doins terminfo/screencap
	insinto /etc/screen
	doins etc/screenrc
	dodoc README ChangeLog INSTALL COPYING TODO NEWS* \
	doc/{FAQ,README.DOTSCREEN,fdpat.ps,window_to_display.ps}
	doman doc/screen.1
	doinfo doc/screen.info*
}
