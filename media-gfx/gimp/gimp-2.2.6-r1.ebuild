# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimp/gimp-2.2.6-r1.ebuild,v 1.13 2006/02/01 08:53:30 lu_zero Exp $

inherit flag-o-matic libtool eutils fdo-mime

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="http://www.gimp.org/"

P_HELP="gimp-help-2-0.7" #gimp-help-2-{version}
S_HELP="$WORKDIR/${P_HELP}"
SRC_URI="mirror://gimp/v2.2/${P}.tar.bz2
	doc? ( mirror://gimp/help/testing/${P_HELP}.tar.gz )"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 hppa ia64 mips ppc ppc64 sparc x86"
#IUSE="X aalib altivec debug doc gimpprint jpeg mmx mng png python sse svg tiff wmf"
IUSE="aalib altivec debug doc gtkhtml gimpprint hardened jpeg mmx mng png python sse svg tiff wmf"

# FIXME : some more things can be (local) USE flagged
# a few options are detection only, fix them to switch

#	X? ( virtual/x11 )"
RDEPEND="
	>=dev-libs/glib-2.4.5
	>=x11-libs/gtk+-2.4.4
	>=x11-libs/pango-1.4
	>=media-libs/freetype-2.1.7
	>=media-libs/fontconfig-2.2
	>=media-libs/libart_lgpl-2.3.8-r1
	sys-libs/zlib
	dev-libs/libxml2
	dev-libs/libxslt

	gimpprint? ( =media-gfx/gimp-print-4.2* )
	gtkhtml? ( =gnome-extra/gtkhtml-2* )

	png? ( >=media-libs/libpng-1.2.1 )
	jpeg? ( >=media-libs/jpeg-6b-r2
		media-libs/libexif )
	tiff? ( >=media-libs/tiff-3.5.7 )
	mng? ( media-libs/libmng )

	wmf? ( >=media-libs/libwmf-0.2.8.2 )
	svg? ( >=gnome-base/librsvg-2.2 )

	aalib?	( media-libs/aalib )
	python?	( >=dev-lang/python-2.2
		>=dev-python/pygtk-2 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	dev-util/intltool
	doc? ( >=dev-util/gtk-doc-1 )"

src_unpack() {

	unpack ${A}

	cd ${S}
	# Fix linking to older version of gimp if installed - this should
	# void liquidx's hack, so it is removed.
	epatch ${FILESDIR}/ltmain_sh-1.5.0-fix-relink.patch

}

src_compile() {

	# Since 1.3.16, fixes linker problems when upgrading
	elibtoolize

	# Workaround portage variable leakage
	local AA=

	# only use mmx if hardened is not set
	local USE_MMX=

	replace-flags "-march=k6*" "-march=i586"

	# gimp uses inline functions (plug-ins/common/grid.c) (#23078)
	# gimp uses floating point math, needs accuracy (#98685)
	filter-flags "-fno-inline" "-ffast-math"

	if use hardened; then
		ewarn "hardened use flag suppressing mmx use flag"
		HARDENED_SUPPRESS_MMX="--disable-mmx"
	elif use x86; then
		HARDENED_SUPPRESS_MMX="`use_enable mmx`"
	elif use amd64; then
		HARDENED_SUPPRESS_MMX="--enable-mmx"
	fi

	local myconf
	use doc || myconf="${myconf} --disable-devel-docs"

	# Hard enable SIMD assembler code for AMD64.
	if use x86; then
		myconf="${myconf} `use_enable sse`"
	elif use amd64; then
		myconf="${myconf} --enable-sse"
	fi

	econf \
		--disable-default-binary \
		--with-x \
		"${HARDENED_SUPPRESS_MMX}" \
		${myconf} \
		`use_enable altivec` \
		`use_enable doc gtk-doc` \
		`use_enable python` \
		`use_enable gimpprint print` \
		`use_with png libpng` \
		`use_with jpeg libjpeg` \
		`use_with jpeg libexif` \
		`use_with tiff libtiff` \
		`use_with mng libmng` \
		`use_with aalib aa` \
		`use_enable debug` || die

	# X isn't optional (#58003) atm
	#	`use_with X x` \

	emake || die

	if use doc; then
		cd ${S_HELP}
		econf --without-gimp || die
		emake || die
	fi

}

src_install() {

	# Workaround portage variable leakage
	local AA=

	# create these dirs to make the makefile installs these items correctly
	dodir /usr/share/{applications,application-registry,mime-info}

	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog* HACKING NEWS README*

	if use doc; then
		cd ${S_HELP}
		make DESTDIR=${D} install || die
	fi

	# Create the gimp-remote link, see bug #36648
	dosym gimp-remote-2.2 /usr/bin/gimp-remote

}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	touch --no-create /usr/share/icons/hicolor
	if [ -x ${ROOT}/usr/bin/gtk-update-icon-cache ]
	then
		einfo "Updating shared icon cache ..."
		gtk-update-icon-cache -q /usr/share/icons/hicolor
	fi
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	touch --no-create /usr/share/icons/hicolor
	if [ -x ${ROOT}/usr/bin/gtk-update-icon-cache ]
	then
		einfo "Updating shared icon cache ..."
		gtk-update-icon-cache -q /usr/share/icons/hicolor
	fi
}
