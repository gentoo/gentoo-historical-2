# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/pango/pango-1.4.1-r1.ebuild,v 1.1 2004/08/19 20:56:01 lv Exp $

inherit gnome2 eutils

DESCRIPTION="Text rendering and layout library"
HOMEPAGE="http://www.pango.org/"
SRC_URI="ftp://ftp.gtk.org/pub/gtk/v2.4/${P}.tar.bz2"

LICENSE="LGPL-2 FTL"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa amd64 ~ia64 ~ppc64"
IUSE="doc"

RDEPEND="virtual/x11
	virtual/xft
	>=dev-libs/glib-2.4
	>=media-libs/fontconfig-1.0.1
	>=media-libs/freetype-2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-1 )"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Some enhancements from Redhat
	epatch ${FILESDIR}/pango-1.0.99.020606-xfonts.patch
	epatch ${FILESDIR}/${PN}-1.2.2-slighthint.patch
	# make config file location host specific so that a 32bit and 64bit pango
	# wont fight with each other on a multilib system
	use amd64 && epatch ${FILESDIR}/pango-1.2.5-lib64.patch
}

DOCS="AUTHORS ChangeLog README INSTALL NEWS TODO*"

src_install() {
	gnome2_src_install
	rm ${D}/etc/pango/pango.modules
	use amd64 && mkdir ${D}/etc/pango/${CHOST}
}

pkg_postinst() {
	if [ "${ROOT}" == "/" ] ; then
		einfo "Generating modules listing..."
		if use amd64 ; then
			pango-querymodules > /etc/pango/${CHOST}/pango.modules
		else
			pango-querymodules > /etc/pango/pango.modules
		fi
	fi
}

USE_DESTDIR="1"
