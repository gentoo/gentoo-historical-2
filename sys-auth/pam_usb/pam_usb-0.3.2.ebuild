# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_usb/pam_usb-0.3.2.ebuild,v 1.4 2008/03/24 15:43:08 armin76 Exp $

inherit eutils pam

DESCRIPTION="A PAM module that enables authentication using an USB-Storage device (such as an USB Pen) through DSA private/public keys."
SRC_URI="mirror://sourceforge/pamusb/${P}.tar.gz"
HOMEPAGE="http://www.pamusb.org/"

IUSE="ssl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~ia64 ~mips ~ppc ~sparc x86"

DEPEND="ssl? ( dev-libs/openssl )
	sys-libs/pam
	sys-apps/hotplug-base"

src_compile() {
	emake || die "make failed"
}

src_install() {
	dodir $(getpam_mod_dir) /usr/bin /usr/share/man/man1
	dodir /etc/hotplug.d /etc/pam.d /etc/pam_usb

	einstall DESTDIR=${D} PAM_MODULES="${D}/$(getpam_mod_dir)" || die "einstall failed"
	dodoc AUTHORS Changelog README
}
