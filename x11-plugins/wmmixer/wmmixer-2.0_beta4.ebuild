# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmixer/wmmixer-2.0_beta4.ebuild,v 1.9 2006/01/31 19:56:31 nelchael Exp $

inherit eutils

IUSE="alsa oss"

DESCRIPTION="The next generation of WMMixer with native ALSA and OSS support."
SRC_URI="http://freakzone.net/gordon/src/${PN}-2.0b4.tar.gz"
HOMEPAGE="http://freakzone.net/gordon/#wmmixer"

RDEPEND="|| ( (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXpm )
	virtual/x11 )"
DEPEND="${RDEPEND}
	|| ( (
		x11-proto/xproto
		x11-proto/xextproto )
	virtual/x11 )
	alsa? ( media-libs/alsa-lib )
	>=sys-apps/sed-4"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc ~mips"

S="${WORKDIR}/${PN}-2.0b4"

src_unpack() {

	unpack ${A}
	cd ${S}
	sed -i 's#/usr/local/share#/usr/share#g' src/wmmixer.h example/*

	# Allow use of Gentoo CXXFLAGS
	epatch ${FILESDIR}/wmmixer-cflags.patch
}

src_compile() {

	local myconf=""

	if use alsa ; then
		myconf="${myconf} --enable-alsa"
	elif use oss ; then
		myconf="${myconf} --disable-alsatest --enable-oss"
	fi

	econf "${myconf}" || die
	emake || die
}

src_install() {

	einstall || die
	dodoc README AUTHORS example/home.wmmixerrc example/home.wmmixer

	einfo
	einfo "Two sample configuration files have been installed in /usr/share/doc/${PF}/."
	einfo "You can copy one of them to ~/.wmmixerrc and adjust any settings you may need."
	einfo
}
