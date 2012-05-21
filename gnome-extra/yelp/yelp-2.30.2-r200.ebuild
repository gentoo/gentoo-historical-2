# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-2.30.2-r200.ebuild,v 1.1 2012/05/21 17:02:43 ssuominen Exp $

EAPI=4
GCONF_DEBUG=yes
inherit autotools eutils gnome2

MY_P=${P}+webkit

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://projects.gnome.org/yelp/"
SRC_URI="http://dev.gentoo.org/~ssuominen/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="lzma"

RDEPEND="app-arch/bzip2
	>=app-text/gnome-doc-utils-0.20.6
	>=app-text/rarian-0.8.1
	>=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.16
	dev-libs/libxml2
	dev-libs/libxslt
	>=gnome-base/gconf-2
	sys-libs/zlib
	>=x11-libs/gtk+-2.18:2
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/startup-notification
	net-libs/webkit-gtk:2
	lzma? ( app-arch/xz-utils )"
DEPEND="${RDEPEND}
	dev-util/intltool
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="--enable-maintainer-mode --with-search=basic"
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-uri-handler.patch \
		"${FILESDIR}"/${P}-print-crash.patch \
		"${FILESDIR}"/${P}-freeze-move.patch \
		"${FILESDIR}"/${P}-xz-support.patch

	sed -i -e '/CFLAGS/s:-pedantic -ansi::' configure.in || die #196621

	intltoolize --force --copy --automake || die
	eautoreconf

	gnome2_src_prepare
}

src_configure() {
	export ac_cv_lib_lzma_lzma_code__lzma_auto_decoder__lzma_end=$(usex lzma)

	gnome2_src_configure
}
