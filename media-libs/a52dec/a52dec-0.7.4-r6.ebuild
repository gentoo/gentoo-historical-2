# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/a52dec/a52dec-0.7.4-r6.ebuild,v 1.10 2009/08/21 20:10:29 ssuominen Exp $

EAPI=2
inherit autotools eutils flag-o-matic

DESCRIPTION="library for decoding ATSC A/52 streams used in DVD"
HOMEPAGE="http://liba52.sourceforge.net/"
SRC_URI="http://liba52.sourceforge.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="oss djbfft"

RDEPEND="djbfft? ( sci-libs/djbfft )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-freebsd.patch \
		"${FILESDIR}"/${P}-tests-optional.patch
	eautoreconf
	epunt_cxx
}

src_compile() {
	filter-flags -fprefetch-loop-arrays

	local myconf="--enable-shared"
	use oss || myconf="${myconf} --disable-oss"
	econf \
		$(use_enable djbfft) \
		${myconf}
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_test() {
	filter-flags -fPIE
	emake check || die "emake check failed"
}

src_install() {
	emake DESTDIR="${D}" docdir=/usr/share/doc/${PF}/html \
		install || die "emake install failed"

	insinto /usr/include/a52dec
	doins "${S}"/liba52/a52_internal.h

	dodoc AUTHORS ChangeLog HISTORY NEWS README TODO doc/liba52.txt
}
