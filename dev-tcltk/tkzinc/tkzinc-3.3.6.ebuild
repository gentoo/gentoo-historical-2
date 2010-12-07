# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tkzinc/tkzinc-3.3.6.ebuild,v 1.1 2010/12/07 18:36:10 jlec Exp $

EAPI="3"

inherit autotools eutils

DESCRIPTION="A Tk widget library."
HOMEPAGE="http://www.tkzinc.org"
SRC_URI="http://www.tkzinc.org/Packages/Tkzinc-${PV}plus.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="debug doc threads"

DEPEND="
	dev-lang/tk
	media-libs/glew
	virtual/opengl
	doc? ( virtual/latex-base )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Tkzinc-${PV//.}+"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-ldflags.patch
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--enable-gl=damage \
		$(use_enable debug symbols) \
		$(use_enable threads)
}

src_compile() {
	emake || die "make failed"
	if use doc ; then
		emake pdf || die "make pdf files failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc BUGS README || die
	dohtml -r doc/* || die
	use doc && dodoc doc/refman.pdf
}
