# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmikmod/libmikmod-3.1.12.ebuild,v 1.2 2010/03/12 12:23:24 ssuominen Exp $

# this ebuild is only for the libmikmod.so.2 SONAME for ABI compat

EAPI=2
inherit autotools eutils flag-o-matic multilib

DESCRIPTION="A library to play a wide range of module formats"
HOMEPAGE="http://mikmod.raphnet.net/"
SRC_URI="mirror://sourceforge/mikmod/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 LGPL-2 )"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="+oss raw"

src_prepare() {
	epatch "${FILESDIR}"/${P}-64bit.patch \
		"${FILESDIR}"/${P}-autotools.patch \
		"${FILESDIR}"/${PN}-3.2.0_beta2-info.patch \
		"${FILESDIR}"/${PN}-3.2.0_beta2-doubleRegister.patch \
		"${FILESDIR}"/${PN}-CVE-2007-6720.patch \
		"${FILESDIR}"/${PN}-CVE-2009-0179.patch \
		"${FILESDIR}"/${PN}-3.2.0_beta2-no-drv_raw.patch

	AT_M4DIR=${S} eautoreconf
}

src_configure() {
	use raw && append-flags -DDRV_RAW

	econf \
		--disable-af \
		--disable-alsa \
		--disable-esd \
		$(use_enable oss) \
		--disable-static
}

src_install() {
	exeinto /usr/$(get_libdir)
	newexe ${PN}/.libs/${PN}.so.2.0.4 ${PN}.so.2 || die
}

pkg_postinst() {
	use oss || ewarn "No audio output will be available because of USE=\"-oss\"."
}
