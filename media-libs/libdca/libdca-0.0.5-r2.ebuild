# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdca/libdca-0.0.5-r2.ebuild,v 1.9 2010/01/15 09:31:51 fauli Exp $

inherit autotools base

DESCRIPTION="library for decoding DTS Coherent Acoustics streams used in DVD"
HOMEPAGE="http://www.videolan.org/developers/libdca.html"
SRC_URI="http://www.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2
	mirror://gentoo/${P}-constant.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="oss debug"

RDEPEND="!media-libs/libdts"

DOCS="AUTHORS ChangeLog NEWS README TODO doc/${PN}.txt"

PATCHES=( "${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-tests-optional.patch
	"${DISTDIR}"/${P}-constant.patch.bz2 )

src_unpack() {
	base_src_unpack
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf $(use_enable oss) $(use_enable debug)

	emake OPT_CFLAGS="" || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README TODO doc/${PN}.txt
}
