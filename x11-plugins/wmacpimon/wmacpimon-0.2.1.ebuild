# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmacpimon/wmacpimon-0.2.1.ebuild,v 1.6 2007/07/22 05:29:57 dberkholz Exp $

inherit eutils

IUSE=""

DESCRIPTION="WMaker DockApp that monitors the temperature and Speedstep features in new ACPI-based systems."
HOMEPAGE="http://www.vrlteam.org/wmacpimon/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_unpack()
{
	unpack ${A}

	# patch wmacpimon.c file to set default path for
	# wmacpimon.prc to /var/tmp/
	cd ${S}
	epatch ${FILESDIR}/wmacpimon.c.patch
}

src_compile()
{
	make                                                                 \
		CFLAGS="${CFLAGS} -DACPI -Wall -I/usr/X11R6/include"             \
		LDFLAGS="${CFLAGS} -DACPI -L/usr/X11R6/lib -lX11 -lXpm -lXext"   \
		|| die "Compilation failed"
}

src_install()
{
	dobin wmacpimond wmacpimon
	dodoc AUTHORS ChangeLog README
	newinitd ${FILESDIR}/wmacpimon.initscript wmacpimon
}

pkg_postinst()
{
	einfo "Remember to start the wmacpimond daemon"
	einfo "(by issuing the \"/etc/init.d/wmacpimon start\" command)"
	einfo "before you attempt to run wmacpimon..."
}
