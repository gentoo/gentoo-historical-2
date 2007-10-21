# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_usb/pam_usb-0.4.2.ebuild,v 1.1 2007/10/21 21:44:24 betelgeuse Exp $

inherit eutils pam

DESCRIPTION="pam_usb provides hardware authentication for Linux using ordinary USB Flash Drives."
SRC_URI="mirror://sourceforge/pamusb/${P}.tar.gz"
HOMEPAGE="http://www.pamusb.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

RDEPEND="
	dev-libs/libxml2
	>=sys-libs/pam-0.78-r3
	>=sys-apps/dbus-0.62-r2
	>=sys-apps/hal-0.5.7.1-r3
	>=sys-apps/pmount-0.9.13
	>=dev-python/celementtree-1.0.2
	>=dev-python/dbus-python-0.71
	>=dev-python/pygobject-2.12.3"

DEPEND="
	${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	dodir $(getpam_mod_dir) /usr/bin

	einstall DESTDIR="${D}" PAM_MODULES="${D}/$(getpam_mod_dir)" \
		DOCS_DEST="${D}usr/share/doc/${PF}/" || die "einstall failed"
	dodoc ChangeLog || die
}

pkg_postinst() {
	elog "There are major between 0.3* and 0.4*. Here are the steps from"
	elog "/usr/share/doc/${PF}/UPGRADING that apply on Gentoo:"
	elog "1. Remove .auth directories from home directories"
	elog "2. rm -rf /etc/pam_usb (now as /etc/pamusb.conf)"
	elog "3. now you can use pamusb.conf to disable pamusb for individual"
	elog "   services so check how you want to implement your pam config."
	elog "   (/usr/share/doc/${PF}/CONFIGURATION)"
}
