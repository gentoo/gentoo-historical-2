# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/pam_usb/pam_usb-0.2.2.ebuild,v 1.3 2004/05/26 11:21:50 kugelfang Exp $

inherit eutils

DESCRIPTION="A PAM module that enables authentication using an USB-Storage device (such as an USB Pen) through DSA private/public keys."
SRC_URI="http://www.pamusb.org/releases/${P}.tar.gz"
HOMEPAGE="http://www.pamusb.org/"

IUSE="pam ssl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa ~mips ~amd64"

RDEPEND="sys-libs/pam"
DEPEND="ssl? ( dev-libs/openssl )
	sys-libs/pam"

src_compile() {
	if [ "${ARCH}" = "amd64" ]; then
		# append-flags / CFLAGS doesnt work...
		sed -i -e "s/CFLAGS. *=/& -fPIC/" src/Makefile
	fi
	emake || die "make failed"
}

src_install() {
	dodir /lib/security /usr/bin /usr/share/man/man1

	einstall DESTDIR=${D} || die "einstall failed"
	dodoc AUTHORS COPYING Changelog README TODO
}
