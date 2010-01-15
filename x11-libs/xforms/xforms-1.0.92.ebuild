# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xforms/xforms-1.0.92.ebuild,v 1.2 2010/01/15 21:58:27 fauli Exp $

EAPI="2"

inherit autotools

DESCRIPTION="A graphical user interface toolkit for X"
HOMEPAGE="http://www.nongnu.org/xforms/"
SRC_URI="http://savannah.nongnu.org/download/xforms/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="doc opengl"

RDEPEND="
	media-libs/jpeg
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libSM
	x11-proto/xproto
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}"

src_prepare() {
	rm "${S}"/config/libtool.m4 "${S}"/acinclude.m4
	AT_M4DIR=config eautoreconf
}

src_configure() {
	local myopts
	use opengl || myopts="--disable-gl"
	use doc && myopts="${myopts} --enable-docs"

	econf ${myopts} || die "econf failed"
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog NEWS README
}
