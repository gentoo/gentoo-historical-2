# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim/scim-0.5.1.ebuild,v 1.2 2003/08/05 15:39:31 vapier Exp $

inherit gnome2 eutils

DESCRIPTION="Smart Common Input Method (SCIM) is a Input Method (IM) development platform"
HOMEPAGE="http://www.turbolinux.com.cn/~suzhe/scim/"
SRC_URI="http://www.turbolinux.com.cn/~suzhe/scim/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="gnome"

RDEPEND="virtual/x11
	gnome? ( >=gnome-base/gconf-1.2
		>=dev-libs/libxml2-2.5
		>=gnome-base/ORBit2-2
		>=net-libs/linc-0.5 )
	>=x11-libs/gtk+-2
	>=dev-libs/atk-1
	>=x11-libs/pango-1
	>=dev-libs/glib-2"
DEPEND="${RDEPEND}
	dev-lang/perl"
PDEPEND=">=app-i18n/scim-tables-0.2.2"

ELTCONF="--reverse-deps"
G2CONF="${G2CONF} `use_enable gnome config-gconf`"
SCROLLKEEPER_UPDATE="0"

src_unpack() {
	unpack ${A}
	# use scim gtk2 IM module only for chinese/japanese/korean
	epatch ${FILESDIR}/${P}-gtk2immodule.patch
	# workaround for problematic makefile
	cd ${S}/src
	sed -i	-e "s:^\(scim_LDFLAGS.*\):\1 -ldl:" Makefile.in
	cd ${S}/modules/Server
	sed -i	-e "s:^\(scim_make_table_LDFLAGS.*\):\1 -ldl:" Makefile.in	
}

src_install() {
	gnome2_src_install || "install failed"
	dodoc README AUTHORS ChangeLog docs/developers docs/scim.cfg
	dohtml -r docs/html/*
}
