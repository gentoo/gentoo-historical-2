# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmp4v2/libmp4v2-1.5.0.1-r2.ebuild,v 1.6 2009/07/21 20:56:59 beandog Exp $

inherit libtool autotools

DESCRIPTION="libmp4v2 extracted from mpeg4ip"
HOMEPAGE="http://www.mpeg4ip.net/"
SRC_URI="mirror://sourceforge/mpeg4ip/mpeg4ip-${PV}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="!<media-video/mpeg4ip-1.4.1
	!<media-libs/faad2-2.0-r9"

S=${WORKDIR}/mpeg4ip-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:nasm -r:nasm -v:g' configure.in || die "sed nasm"

	epatch "${FILESDIR}"/${P}+glibc-2.10.patch
	epatch "${FILESDIR}"/${P}-configurebashisms.patch

	# We don't give a damn about these two, just remove the two calls
	# so we don't have to have the macros to eautoreconf properly.
	sed -i -e '/AM_PATH_\(GLIB\|GTK\|ALSA\)/d' configure.in || die

	AT_NO_RECURSIVE="yes" eautoreconf
	elibtoolize
}

src_compile() {
	touch bootstrapped
	econf \
		--disable-warns-as-err \
		--disable-server \
		--disable-player \
		--disable-mp4live \
		--disable-id3tags \
		--disable-xvid \
		--disable-a52dec \
		--disable-mad \
		--disable-mpeg2dec \
		--disable-srtp \
		--disable-mp3lame \
		--disable-faac \
		--disable-ffmpeg \
		--disable-x264 \
		|| die "econf failed"

	cd "${S}/lib/mp4v2"

	sed -i -e 's:SUBDIRS = . test util:SUBDIRS = .:' Makefile \
		 || die "sed failed"

	emake || die "emake failed"
}

src_install() {
	cd "${S}/lib/mp4v2"

	make DESTDIR="${D}" install || die

	dodoc README INTERNALS API_CHANGES TODO

	sed -i -e 's:"mpeg4ip.h":<libmp4v2/mpeg4ip.h>:' \
		"${D}/usr/include/mp4.h" || die "sed failed"

	dodir /usr/include/libmp4v2

	cp "${S}/include/mpeg4ip.h"  "${D}/usr/include/libmp4v2/"
	sed -i -e 's:mpeg4ip_config.h:libmp4v2/mpeg4ip_config.h:' \
		-e 's:"mpeg4ip_version.h":<libmp4v2/mpeg4ip_version.h>:' \
		 "${D}/usr/include/libmp4v2/mpeg4ip.h"  || die "sed failed"

	cp "${S}/include/mpeg4ip_version.h" "${D}/usr/include/libmp4v2/"
	cp "${S}/mpeg4ip_config.h" "${D}/usr/include/libmp4v2/"
}
