# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tkimg/tkimg-1.4-r2.ebuild,v 1.1 2011/10/08 13:12:04 jlec Exp $

EAPI=3

VIRTUALX_USE=test

inherit autotools eutils prefix virtualx

MYP="${PN}${PV}"

DESCRIPTION="Adds a lot of image formats to Tcl/Tk"
HOMEPAGE="http://tkimg.sourceforge.net/"
SRC_URI="
	${P}-gentoo.patch.xz
	mirror://sourceforge/${PN}/${PV}/${MYP}.tar.bz2"

IUSE="doc test"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-lang/tk
	>=dev-tcltk/tcllib-1.11"
DEPEND="${RDEPEND}
	test? (
		x11-apps/xhost
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )"

# Fails with jpeg-turbo silently, #386253
RESTRICT="test"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${WORKDIR}"/${P}-gentoo.patch
	find compat/{libjpeg,libpng,libtiff,zlib} -delete
	sed \
		-e 's:-O2 -fomit-frame-pointer::g' \
		-e 's: -pipe::g' \
		-i */configure  || die
	eprefixify */*.h
}

src_test() {
	Xemake test || die "Xmake failed"
}

src_install() {
	local l bl

	emake \
		DESTDIR="${D}" \
		INSTALL_ROOT="${D}" \
		install || die "emake install failed"

	# Make library links
	for l in "${ED}"/usr/lib*/Img*/*tcl*.so; do
		bl=$(basename $l)
		dosym Img1.4/${bl} /usr/$(get_libdir)/${bl}
	done

	dodoc ChangeLog README Reorganization.Notes.txt changes ANNOUNCE || die

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins demo.tcl || die
		insinto /usr/share/doc/${PF}/html
		doins -r doc/* || die
	fi
}
