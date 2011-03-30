# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-vmmouse/xf86-input-vmmouse-12.7.0.ebuild,v 1.4 2011/03/30 20:51:51 ssuominen Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="VMWare mouse input driver"
IUSE=""
KEYWORDS="amd64 x86 ~x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	>=x11-proto/inputproto-1.4.1
	x11-proto/randrproto
	x11-proto/xproto"

pkg_setup() {
	CONFIGURE_OPTIONS="
		--with-hal-bin-dir=/punt
		--with-hal-callouts-dir=/punt
		--with-hal-fdi-dir=/punt
		"
}

src_install() {
	xorg-2_src_install
	rm -rf "${D}"/punt
}
