# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/halevt/halevt-0.1.4.ebuild,v 1.1 2009/05/30 18:24:23 hwoarang Exp $

EAPI="2"

inherit eutils

DESCRIPTION="A daemon built on ivman that executes arbitrary commands on HAL events"
HOMEPAGE="http://www.environnement.ens.fr/perso/dumas/halevt.html"
SRC_URI="http://www.environnement.ens.fr/perso/dumas/halevt-download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls rpath"

DEPEND=">=sys-apps/hal-0.5.11-r1
		>=sys-apps/dbus-1.2.3-r1
		>=dev-libs/dbus-glib-0.76
		>=dev-libs/boolstuff-0.1.12"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable nls) $(use_enable rpath)
}

src_install () {
	emake DESTDIR="${D}" install || die "install failed"
	doinitd "${FILESDIR}"/${PN} || die "failed to install init script"
	dodoc AUTHORS NEWS README || die "dodoc failed"

	insinto /etc/${PN}/
	doins ${PN}.xml || die "doins ${PN}.xml failed"
}

pkg_postinst() {
	einfo
	einfo "Default config file resides at /etc/halevt/halevt.xml."
	einfo
}
