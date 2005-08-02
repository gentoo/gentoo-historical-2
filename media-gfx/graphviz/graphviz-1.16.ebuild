# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/graphviz/graphviz-1.16.ebuild,v 1.15 2005/08/02 19:31:15 sekretarz Exp $

inherit gnuconfig eutils flag-o-matic

DESCRIPTION="open source graph drawing software"
HOMEPAGE="http://www.research.att.com/sw/tools/graphviz/"
SRC_URI="http://www.graphviz.org/pub/graphviz/ARCHIVE/${P}.tar.gz
	ppc-macos? ( mirror://gentoo/${P}-panic.patch.tar.bz2 )"

LICENSE="as-is ATT"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm hppa ~ia64 mips ppc ppc-macos ppc64 s390 sparc x86"
IUSE="tcltk"

#Can use freetype-1.3 or 2.0, but not both
DEPEND=">=sys-libs/zlib-1.1.3
	>=media-libs/libpng-1.2
	>=media-libs/jpeg-6b
	media-libs/freetype
	dev-util/pkgconfig
	>=media-libs/gd-2.0.29
	media-libs/fontconfig
	tcltk? ( >=dev-lang/tk-8.3 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-build.patch

	if use ppc-macos; then
		# fixes weird make issue
		epatch ${WORKDIR}/${P}-panic.patch
		epatch ${FILESDIR}/${P}-common_h.patch
	fi

	# Run gnuconfig_update on all arches, needed at least for mips
	gnuconfig_update

	if ! use ppc-macos; then
		#EPATCH_OPTS="-p1 -d${S}" epatch ${FILESDIR}/${P}-fontconfig-externalgd.diff || die "Failed to patch"
		einfo "Running aclocal/automake/autoconf"
		aclocal && libtoolize --copy --force && automake -a && autoconf || die "Failed	to aclocal/libtoolize/automake/autoconf"
	fi
}

src_compile() {
	local myconf

	# if no tcltk, this will generate configure warnings, but will
	# compile without tcltk support
	use tcltk || myconf="${myconf} --without-tcl --without-tk"

	myconf="${myconf} --enable-dynagraph --with-mylibgd"
	use ppc-macos && myconf="${myconf} --with-expatincludedir=/usr/X11R6/include --with-expatlibdir=/usr/X11R6/lib --with-fontconfigincludedir=/usr/X11R6/include --with-fontconfiglibdir=/usr/X11R6/lib"
	econf ${myconf} || die "econf failed"

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog FAQ.txt INSTALL*  MINTERMS.txt \
		NEWS README*

	insinto /usr/share/doc/${PF}/
	doins doc/*.pdf

	dohtml -r .
	dodoc doc/*.pdf doc/Dot.ref
}
