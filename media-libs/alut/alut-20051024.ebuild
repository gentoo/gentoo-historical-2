# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/alut/alut-20051024.ebuild,v 1.1 2005/10/25 18:19:58 wolf31o2 Exp $

inherit eutils gnuconfig

IUSE=""
DESCRIPTION="The OpenAL Utility Toolkit"
SRC_URI="http://dev.gentoo.org/~wolf31o2/sources/openal/openal-${PV}.tar.bz2"
HOMEPAGE="http://www.openal.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="~media-libs/openal-${PV}"

DEPEND="sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool"

S="${WORKDIR}/openal-${PV}/${PN}"

#src_unpack() {
#	unpack "${A}"
#	cd "${S}"

#	use alsa && epatch ${FILESDIR}/${P}-alsa_dmix.patch

#	gnuconfig_update

#	export WANT_AUTOCONF=2.5
#	autoheader || die
#	autoconf || die
#}

src_compile() {
	local myconf

#	use esd && myconf="${myconf} --enable-esd"
#	use sdl && myconf="${myconf} --enable-sdl"
#	use alsa && myconf="${myconf} --enable-alsa"
#	use arts && myconf="${myconf} --enable-arts"
#	use mpeg && myconf="${myconf} --enable-smpeg"
#	use vorbis && myconf="${myconf} --enable-vorbis"
#	use debug && myconf="${myconf} --enable-debug-maximus"
	use debug && myconf="${myconf} --enable-debug"
	./autogen.sh

	econf ${myconf} --libdir=/usr/$(get_libdir) || die
	emake all || die
}

src_install() {
	make install DESTDIR="${D}" || die

	dodoc AUTHORS ChangeLog NEWS README
	dohtml doc/*
}
