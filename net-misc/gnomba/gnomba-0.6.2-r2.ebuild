# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gnomba/gnomba-0.6.2-r2.ebuild,v 1.1 2006/11/05 20:03:33 allanonjl Exp $

inherit eutils

DESCRIPTION="Gnome Samba Browser"
SRC_URI="http://gnomba.sourceforge.net/src/${P}.tar.gz"
HOMEPAGE="http://gnomba.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="~sparc ~x86"
SLOT="0"

IUSE="debug"
DEPEND="gnome-base/gnome-libs"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	epatch "${FILESDIR}/${P}-gcc-fix.patch"
}

src_compile() {
	econf `use_enable debug` || die "econf failed"
	# We touch the Makefile here, because the configure script
	# touches Makefile.in and we want to avoid the recreation
	touch Makefile
	emake \
		CODEPAGEDIR=/var/lib/samba/codepages \
		LMHOSTSFILE=/etc/samba/lmhosts \
		SMB_PASSWD_FILE=/etc/samba/private/smbpasswd \
		PASSWD_PROGRAM=/usr/bin/passwd \
		DRIVERFILE=/etc/samba/printers.def \
		|| die "emake failed"
}

src_install() {
	edos2unix gnomba.desktop

	einstall || die "einstall failed"
	dodoc AUTHORS BUGS COPYING ChangeLog HACKING INSTALL NEWS README TODO
}
