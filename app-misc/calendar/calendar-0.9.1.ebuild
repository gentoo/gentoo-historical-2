# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/calendar/calendar-0.9.1.ebuild,v 1.5 2004/01/09 23:27:51 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Standard unix calendar program for Linux, ported from OpenBSD."
HOMEPAGE="http://bsdcalendar.sourceforge.net/"
SRC_URI="http://bsdcalendar.sourceforge.net/${P}.tar.bz2"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ~ppc ~sparc alpha ~mips ~arm ~hppa"

DEPEND="virtual/glibc"

src_compile() {
	emake || die
}
src_install() {
	dodoc README TODO
	cp -R ${S}/calendars ${D}/usr/share/calendar
	exeinto /usr/bin
	doexe calendar
	doman calendar.1
}
