# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/DirectFB/DirectFB-0.9.20.ebuild,v 1.16 2004/06/24 23:05:08 agriffis Exp $

inherit eutils 64-bit

IUSE_VIDEO_CARDS="ati128 cle266 cyber5k i810 matrox neomagic nsc nvidia radeon savage tdfx"

DESCRIPTION="Thin library on top of the Linux framebuffer devices"
HOMEPAGE="http://www.directfb.org/"
SRC_URI="http://www.directfb.org/download/DirectFB/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc -sparc alpha hppa ia64 -mips amd64"
IUSE="jpeg gif png truetype mpeg mmx sse fusion"

DEPEND="dev-lang/perl
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	mpeg? ( media-libs/libmpeg3 )
	truetype? ( >=media-libs/freetype-2.0.1 )"

pkg_setup() {
	if [ -z "${VIDEO_CARDS}" ] ; then
		ewarn "All video drivers will be built since you did not specify"
		ewarn "via the VIDEO_CARDS variable what video card you use."
		einfo "DirectFB supports: ${IUSE_VIDEO_CARDS} all none"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-linux-2.6.patch

	# This patch changes ints to longs where appropriate
	64-bit && epatch ${FILESDIR}/DirectFB-0.9.20-64bit.diff

	# This patch enables simd optimisations for amd64. Since mmx and sse are
	# masked USE flags on amd64 due to their enabling x86 specific asm more
	# often than not, we'll just enable them by default. All x86_64 cpus
	# should support mmx and see. Travis Tilley <lv@gentoo.org>
	use amd64 && epatch ${FILESDIR}/DirectFB-0.9.20-simd-amd64.diff

	sed -i 's:wm97xx_ts=yes:wm97xx_ts=no:' configure #36924
}

src_compile() {
	local vidcards
	local card
	for card in ${VIDEO_CARDS} ; do
		has ${card} ${IUSE_VIDEO_CARDS} && vidcards="${vidcards},${card}"
	done
	[ -z "${vidcards}" ] \
		&& vidcards="all" \
		|| vidcards="${vidcards:1}"

	local mycppflags
	use mpeg && mycppflags="-I/usr/include/libmpeg3"
	econf CPPFLAGS="${mycppflags}" \
		`use_enable mmx` \
		`use_enable sse` \
		`use_enable amd64 mmx` \
		`use_enable amd64 sse` \
		`use_enable mpeg libmpeg3` \
		`use_enable jpeg` \
		`use_enable png` \
		`use_enable gif` \
		`use_enable truetype freetype` \
		`use_enable fusion multi` \
		--with-gfxdrivers="${vidcards}" \
		|| die

	use mpeg && \
		sed -i \
			s':#include <libmpeg3.h>:#include <libmpeg3/libmpeg3.h>:' \
			${S}/interfaces/IDirectFBVideoProvider/idirectfbvideoprovider_libmpeg3.c

	# add extra -lstdc++ so libpng/libflash link correctly
	make CPPFLAGS="${mycppflags}" LDFLAGS="${LDFLAGS} -lstdc++" || die
}

src_install() {
	insinto /etc
	doins fb.modes

	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README* TODO
	dohtml -r docs/html/*
}

pkg_postinst() {
	ewarn "Each DirectFB update in the 0.9.xx series"
	ewarn "breaks DirectFB related applications."
	ewarn "Please run \`revdep-rebuild\` which can be"
	ewarn "found by emerging the package 'gentoolkit'."
}
