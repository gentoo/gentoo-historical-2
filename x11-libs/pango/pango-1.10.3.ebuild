# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/pango/pango-1.10.3.ebuild,v 1.5 2006/03/17 22:28:18 wolf31o2 Exp $

inherit eutils gnome2

DESCRIPTION="Text rendering and layout library"
HOMEPAGE="http://www.pango.org/"

LICENSE="LGPL-2 FTL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ppc ~ppc64 sparc x86"
IUSE="doc"

RDEPEND="|| ( (
		x11-libs/libXrender
		x11-libs/libX11
		x11-libs/libXt
		)
	virtual/x11 )
	virtual/xft
	>=dev-libs/glib-2.5.7
	>=media-libs/fontconfig-1.0.1
	>=media-libs/freetype-2
	>x11-libs/cairo-0.5.2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	|| ( x11-proto/xproto virtual/x11 )
	doc? (
		>=dev-util/gtk-doc-1
		~app-text/docbook-xml-dtd-4.1.2 )"

DOCS="AUTHORS ChangeLog* NEWS README TODO*"
USE_DESTDIR="1"


pkg_setup() {
	if ! built_with_use -a x11-libs/cairo png X; then
		einfo "Please re-emerge x11-libs/cairo with the png and X USE flags set"
		die "cairo needs png and X flags set"
	fi
}

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# Some enhancements from Redhat
	epatch ${FILESDIR}/pango-1.0.99.020606-xfonts.patch
	epatch ${FILESDIR}/${PN}-1.10.2-slighthint.patch

	# make config file location host specific so that a 32bit and 64bit pango
	# wont fight with each other on a multilib system
	use amd64 && epatch ${FILESDIR}/pango-1.2.5-lib64.patch
	# and this line is just here to make building emul-linux-x86-gtklibs a bit
	# easier, so even this should be amd64 specific.
	use x86 && [ "${CONF_LIBDIR}" == "lib32" ] && epatch ${FILESDIR}/pango-1.2.5-lib64.patch

	epunt_cxx
}

src_install() {

	gnome2_src_install

	rm ${D}/etc/pango/pango.modules
	use amd64 && mkdir ${D}/etc/pango/${CHOST}
	use x86 && [ "${CONF_LIBDIR}" == "lib32" ] && mkdir ${D}/etc/pango/${CHOST}

}

pkg_postinst() {

	if [ "${ROOT}" == "/" ] ; then
		einfo "Generating modules listing..."
		use amd64 && PANGO_CONFDIR="/etc/pango/${CHOST}"
		use x86 && [ "${CONF_LIBDIR}" == "lib32" ] && PANGO_CONFDIR="/etc/pango/${CHOST}"
		PANGO_CONFDIR=${PANGO_CONFDIR:=/etc/pango}
		pango-querymodules > ${PANGO_CONFDIR}/pango.modules
	fi

}
