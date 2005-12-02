# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/viewmol/viewmol-2.4.1.ebuild,v 1.1 2005/12/02 19:44:14 spyderous Exp $

inherit toolchain-funcs eutils

DESCRIPTION="Open-source graphical front end for computational chemistry programs"
HOMEPAGE="http://viewmol.sourceforge.net/"
SRC_URI="mirror://sourceforge/viewmol/${P}.src.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND="media-libs/tiff
	virtual/opengl
	virtual/motif
	media-libs/libpng
	>=dev-lang/python-2.2
	|| ( (
			x11-libs/libXmu
			x11-libs/libX11
			x11-libs/libXt
			x11-libs/libXaw
		)
		virtual/x11
	)"
DEPEND="${RDEPEND}
	|| ( (
			x11-proto/inputproto
			x11-proto/xproto
		)
		virtual/x11
	)"

S="${WORKDIR}/${P}/source"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-remove-icc-check.patch
	epatch ${FILESDIR}/${PV}-look-for-python-in-right-place.patch
	epatch ${FILESDIR}/${PV}-use-root-for-app-defaults.patch
	epatch ${FILESDIR}/${PV}-change-default-path-to-usr.patch
}

src_compile() {
	./getmachine
	emake -j1 \
		COMPILER=$(tc-getCC) \
		OPT="${CFLAGS}" || die "emake failed"
}

src_install() {
	./install ${D}/usr || die
}
