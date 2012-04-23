# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/growl-for-linux/growl-for-linux-0.1.ebuild,v 1.2 2012/04/23 20:36:50 mgorny Exp $

EAPI=3
inherit multilib

DESCRIPTION="Growl Implementation For Linux"
HOMEPAGE="http://mattn.github.com/growl-for-linux/"
SRC_URI="mirror://github/mattn/growl-for-linux/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite:3
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/openssl
	net-misc/curl
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install || die

	find "${ED}/usr/$(get_libdir)/growl-for-linux" -name "*.la" -exec rm {} + || die

	dodoc AUTHORS ChangeLog NEWS README* TODO || die
}
