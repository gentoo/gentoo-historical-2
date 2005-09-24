# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/graphviz/graphviz-1.12.ebuild,v 1.7 2005/09/24 05:53:14 halcy0n Exp $

inherit gnuconfig

DESCRIPTION="open source graph drawing software"
HOMEPAGE="http://www.research.att.com/sw/tools/graphviz/"
SRC_URI="http://www.graphviz.org/pub/graphviz/ARCHIVE/${P}.tar.gz"

LICENSE="as-is ATT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86"
IUSE="tcltk"

#Can use freetype-1.3 or 2.0, but not both
DEPEND=">=sys-libs/zlib-1.1.3
	>=media-libs/libpng-1.2
	>=media-libs/jpeg-6b
	media-libs/freetype
	sys-devel/gettext
	tcltk? ( >=dev-lang/tk-8.3 )"

src_unpack() {
	unpack ${A}
	cd ${S}

	# It would be really nice if devs would comment this sort of hack
	# when putting it in.
	sed -i -e "s:+0 -1:-k 1,2:" "${S}/dotneato/common/Makefile.in"

	# Run gnuconfig_update on all arches, needed at least for mips
	gnuconfig_update
}

src_compile() {
	local myconf

	# if no tcltk, this will generate configure warnings, but will
	# compile without tcltk support
	use tcltk || myconf="${myconf} --without-tcl --without-tk"

	econf ${myconf} || die "econf failed"

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog FAQ.txt INSTALL  MINTERMS.txt \
		NEWS README

	dohtml -r .
	dodoc doc/*.pdf
}
