# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/openexr/openexr-1.2.2.ebuild,v 1.7 2005/06/30 20:49:31 danarmak Exp $

MY_P=OpenEXR-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="ILM's HDR image file format libraries"
HOMEPAGE="http://www.openexr.com/"
SRC_URI="http://savannah.nongnu.org/download/openexr/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="doc"

DEPEND="x11-libs/fltk"

src_unpack() {
	unpack ${A}
	sed -i \
		-e "/^examplesdir/s:OpenEXR-@OPENEXR_VERSION@:${P}:" \
		"${S}"/IlmImfExamples/Makefile.in || die
}

src_compile() {
	local myconf="--disable-fltktest"
	use doc && myconf="${myconf} --enable-imfexamples"
	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make install DESTDIR="${D}" || die "install failed"

	dodoc AUTHORS README INSTALL ChangeLog NEWS
	use doc && dohtml -r "${S}"/doc/*
}
