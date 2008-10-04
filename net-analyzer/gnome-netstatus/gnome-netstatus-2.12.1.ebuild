# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/gnome-netstatus/gnome-netstatus-2.12.1.ebuild,v 1.4 2008/10/04 21:04:23 eva Exp $

inherit eutils gnome2

DESCRIPTION="Network interface information applet"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.3.1
	>=gnome-base/libglade-2
	>=gnome-base/libgnomeui-2.5.2
	>=gnome-base/gnome-panel-2
	>=gnome-base/gconf-2"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.29
	>=dev-util/pkgconfig-0.9
	app-text/scrollkeeper
	app-text/gnome-doc-utils"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper"
}

src_unpack() {
	gnome2_src_unpack

	# Fix interface listing on all (known) arches; bug #183969
	epatch "${FILESDIR}"/${P}-fix-iflist.patch
}
