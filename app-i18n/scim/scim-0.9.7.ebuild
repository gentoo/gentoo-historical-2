# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim/scim-0.9.7.ebuild,v 1.3 2004/06/27 05:59:48 usata Exp $

inherit gnome2 eutils

DESCRIPTION="Smart Common Input Method (SCIM) is a Input Method (IM) development platform"
HOMEPAGE="http://freedesktop.org/~suzhe/"
SRC_URI="http://freedesktop.org/~suzhe/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="gnome"

RDEPEND="virtual/x11
	gnome? ( >=gnome-base/gconf-1.2
		>=dev-libs/libxml2-2.5
		>=gnome-base/ORBit2-2.8 )
	>=x11-libs/gtk+-2
	>=dev-libs/atk-1
	>=x11-libs/pango-1
	>=dev-libs/glib-2
	!app-i18n/scim-cvs"
DEPEND="${RDEPEND}
	dev-lang/perl"
PDEPEND=">=app-i18n/scim-tables-0.3.5"

ELTCONF="--reverse-deps"
SCROLLKEEPER_UPDATE="0"
USE_DESTDIR="1"

src_unpack() {
	unpack ${A}
	# use scim gtk2 IM module only for chinese/japanese/korean
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/${PN}-0.6.1-gtk2immodule.patch
	# workaround for problematic makefile
	sed -i -e "s:^\(scim_LDFLAGS.*\):\1 -ldl:" ${S}/src/Makefile.in
	sed -i -e "s:^\(scim_config_agent_LDFLAGS = .*\):\1 -ldl:" ${S}/src/Makefile.in
	sed -i -e "s:^\(scim_make_table_LDFLAGS.*\):\1 -ldl:" ${S}/modules/Server/Makefile.in
	sed -i -e "s:^LDFLAGS = :LDFLAGS = -ldl :" ${S}/tests/Makefile.in
	sed -i -e "s:GTK_VERSION=2.3.5:GTK_VERSION=2.4.0:" ${S}/configure
}

src_compile() {
	use gnome || G2CONF="${G2CONF} --disable-config-gconf"
	gnome2_src_compile
}

src_install() {
	gnome2_src_install || die "install failed"
	dodoc README AUTHORS ChangeLog docs/developers docs/scim.cfg
	dohtml -r docs/html/*
}

pkg_postinst() {
	einfo "To use SCIM with both GTK2 and XIM, you should use the following"
	einfo "in your user startup scripts such as .gnomerc or .xinitrc:"
	einfo " "
	einfo "LANG='your_language' scim -f socket -ns socket -d"
	einfo "LANG='your_language' scim -f x11 -s socket -c socket -d"
	einfo " "
	einfo "where 'your_language' can either be zh_CN or zh_TW"
	gtk-query-immodules-2.0 > ${ROOT}etc/gtk-2.0/gtk.immodules
}

pkg_postrm() {
	gtk-query-immodules-2.0 > ${ROOT}etc/gtk-2.0/gtk.immodules
}
