# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimp/gimp-1.3.16.ebuild,v 1.2 2003/07/25 20:20:59 foser Exp $

IUSE="doc python perl aalib png jpeg tiff gtkhtml"

inherit debug flag-o-matic libtool

S=${WORKDIR}/${P}
DESCRIPTION="Development series of Gimp"
SRC_URI="ftp://ftp.gimp.org/pub/gimp/v1.3/v${PV}/${P}.tar.bz2"
HOMEPAGE="http://www.gimp.org/"
SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

# protect against over optimisation (related to #21787)
replace-flags -Os -O2
MAKEOPTS="${MAKEOPTS} -j1"

RDEPEND=">=x11-libs/gtk+-2.2
	>=x11-libs/pango-1.2
	>=dev-libs/glib-2.2
	gtkhtml? ( =gnome-extra/libgtkhtml-2* )

	png? ( >=media-libs/libpng-1.2.1 )
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	tiff? ( >=media-libs/tiff-3.5.7 )
	>=media-libs/libart_lgpl-2.3.8-r1

	aalib?	( media-libs/aalib )
	python?	( >=dev-lang/python-2.2
		>=dev-python/pygtk-1.99.13 )

	perl?	( dev-lang/perl )"


DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	sys-devel/gettext
	>=sys-devel/libtool-1.4.3-r1
	doc? ( >=dev-util/gtk-doc-1 )"
# be safe and require the latest libtool

src_compile() {
	# since 1.3.16, fixes linker problems when upgrading
	elibtoolize --reverse-deps

	# workaround portage variable leakage
	local AA
	local myconf

	# Strip out -fomit-frame-pointer for k6's
	is-flag "-march=k6*" && filter-flags "-fomit-frame-pointer"
	# gimp uses inline functions (plug-ins/common/grid.c) (#23078)
	filter-flags "-fno-inline"

	econf ${myconf} \
		`use_enable doc gtk-doc` \
		`use_enable python` \
		`use_enable perl` \
		`use_with png libpng` \
		`use_with jpeg libjpeg` \
		`use_with tiff libtiff` \
		--disable-print || die

	emake || die
}

src_install() {
	# workaround portage variable leakage
	local AA
	
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeL* HACKING INSTALL MAINTAINERS NEWS PLUGIN_MAINTAINERS README* TODO*
	
	# fix desktop link in the right place
	dodir /usr/share/applications
	rm ${D}/usr/share/gimp/1.3/misc/gimp-1.3.desktop
	mv ${D}/usr/share/gimp/1.3/misc/gimp.desktop ${D}/usr/share/applications/gimp-1.3.desktop
}

pkg_postinst() {
	ewarn "There have been changes to the gtkrc file."
	ewarn
	ewarn "You are strongly advised to remove the ~/.gimp-1.3 directory"
	ewarn "and perform a fresh user installation if you have been"
	ewarn "running a gimp-1.3 below minor version 11"
}
