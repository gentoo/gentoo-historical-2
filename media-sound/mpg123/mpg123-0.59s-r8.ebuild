# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpg123/mpg123-0.59s-r8.ebuild,v 1.6 2004/12/30 08:42:51 hardave Exp $

inherit eutils

PATCH_VER=1.3
S="${WORKDIR}/${PN}"

DESCRIPTION="Real Time mp3 player"
HOMEPAGE="http://www.mpg123.de/"
SRC_URI="http://www.mpg123.de/mpg123/${PN}-pre${PV}.tar.gz
	 http://dev.gentoo.org/~eradicator/${PN}/${P}-gentoo-${PATCH_VER}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 sparc x86"
IUSE="mmx 3dnow esd nas oss"

RDEPEND="virtual/libc
	 esd? ( media-sound/esound )
	 nas? ( media-libs/nas )"

# alsa-1 b0rks and it's not a simple fix
#	 alsa? ( media-libs/alsa-lib )"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

PROVIDE="virtual/mpg123"

PATCHDIR="${WORKDIR}/patches"

src_unpack() {
	unpack ${A}

	cd ${S}
	EPATCH_SUFFIX="patch"
	epatch ${PATCHDIR}

	sed -i "s:${PV}-mh4:${PVR}:" version.h
}

src_compile() {
	mkdir gentoo-bin

	# The last one in $styles is the default
	local styles

	use nas && styles="${styles} -nas"
	use oss && styles="${styles} -generic"

	case $ARCH in
		ppc64)
			use esd && styles="${styles} -ppc64-esd"
			use oss && styles="${styles} -ppc64"

			[ -z "${styles}" ] && styles="-ppc64"
			;;
		ppc)
			use esd && styles="${styles} -ppc-esd"
			use oss && styles="${styles} -ppc"

			[ -z "${styles}" ] && styles="-ppc"
			;;
		x86)
			use esd && styles="${styles} -esd"
			use esd && use 3dnow && styles="${styles} -3dnow-esd"
			use oss && styles="${styles} -i486"
			use oss && use mmx && styles="${styles} -mmx"
			use oss && use 3dnow && styles="${styles} -3dnow"
			# use alsa && styles="${styles} -alsa"
			# use alsa && use 3dnow && styles="${styles} -3dnow-alsa"

			[ -z "${styles}" ] && styles="-generic"
			;;
		sparc*)
			use esd && styles="${styles} -sparc-esd"
			styles="${styles} -sparc -generic"
			;;
		amd64)
			use esd && styles="${styles} -x86_64-esd"
			use oss && styles="${styles} -x86_64"
			# use alsa && styles="${styles} -x86_64-alsa"

			[ -z "${styles}" ] && styles="-x86_64"
			;;
		alpha)
			use esd && styles="${styles} -alpha-esd"
			use oss && styles="${styles} -alpha"
			# use alsa && styles="${styles} -alpha-alsa"

			[ -z "${styles}" ] && styles="-generic"
			;;
		mips|hppa|ia64)
			# use alsa && styles="${styles} -mips-alsa"

			[ -z "${styles}" ] && styles="-generic"
			;;
		*)
			eerror "No support has been added for your architecture."
			exit 1
			;;
	esac

	for style in ${styles};
	do
		make clean linux${style} CFLAGS="${CFLAGS}" || die
		mv mpg123 gentoo-bin/mpg123${style}
		[ -L "gentoo-bin/mpg123" ] && rm gentoo-bin/mpg123
		ln -s mpg123${style} gentoo-bin/mpg123
	done
}

src_install() {
	dodir /usr
	cp -dR gentoo-bin ${D}/usr/bin
	doman mpg123.1
	dodoc BENCHMARKING BUGS CHANGES COPYING JUKEBOX README* TODO
}
