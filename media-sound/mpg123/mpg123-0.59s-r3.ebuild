# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpg123/mpg123-0.59s-r3.ebuild,v 1.2 2004/04/13 04:56:25 eradicator Exp $

inherit eutils

IUSE="mmx 3dnow esd nas oss"

DESCRIPTION="Real Time mp3 player"
HOMEPAGE="http://www.mpg123.de/"
SRC_URI="http://www.mpg123.de/mpg123/${PN}-pre${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ia64 ~amd64 ~ppc ~sparc ~alpha ~hppa -mips"

RDEPEND="virtual/glibc
	 esd? ( media-sound/esound )
	 nas? ( media-libs/nas )"

# alsa-1 b0rks and it's not a simple fix
#	 alsa? ( media-libs/alsa-lib )"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

PROVIDE="virtual/mpg123"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A} && cd ${S} || die "unpack failed"

	# Apply security fixes
	epatch ${FILESDIR}/${P}-security.diff
	epatch ${FILESDIR}/${P}-heapfix.diff

	# Add linux-generic target
	epatch ${FILESDIR}/${PV}-generic.patch

	# Always apply this patch, even though it's particularly for
	# amd64.  It's good to understand the distinction between int and
	# long: ANSI says that int should be 32-bits, long should be the
	# native size of the CPU (usually the same as a pointer).
	epatch ${FILESDIR}/mpg123-0.59s-amd64.patch

	# Don't force gcc since icc/ccc might be possible
	sed -i -e "s|CC=gcc||" Makefile

	# Fix a glitch in the x86 related section of the Makefile
	sed -i -e "s:-m486::g" Makefile
	# Fix a glitch in the ppc-related section of the Makefile
	sed -i -e "s:-mcpu=ppc::" Makefile
	# Make sure we use our CFLAGS
	sed -i -e "s:-O2::g" Makefile
}

src_compile() {
	mkdir gentoo-bin

	# The last one in $styles is the default
	local styles

	use nas && styles="${styles} -nas"
	use oss && styles="${styles} -generic"

	case $ARCH in
		ppc*)
			use esd && styles="${styles} -ppc-esd"
			use oss && styles="${styles} -ppc"

			[ -z "${styles}" ] && die "You need atleast one of these USE flags set: esd nas oss."
			;;
		x86)
			use esd && styles="${styles} -esd"
			use esd && use 3dnow && styles="${styles} -3dnow-esd"
			use oss && styles="${styles} -i486"
			use oss && use mmx && styles="${styles} -mmx"
			use oss && use 3dnow && styles="${styles} -3dnow"
			# use alsa && styles="${styles} -alsa"
			# use alsa && use 3dnow && styles="${styles} -3dnow-alsa"

			[ -z "${styles}" ] && die "You need atleast one of these USE flags set: esd nas oss."
			;;
		sparc*)
			use esd && styles="${styles} -sparc-esd"
			styles="${styles} -sparc"
			;;
		amd64)
			use esd && styles="${styles} -x86_64-esd"
			use oss && styles="${styles} -x86_64"
			# use alsa && styles="${styles} -x86_64-alsa"

			[ -z "${styles}" ] && die "You need atleast one of these USE flags set: esd nas oss."
			;;
		alpha)
			use esd && styles="${styles} -alpha-esd"
			use oss && styles="${styles} -alpha"
			# use alsa && styles="${styles} -alpha-alsa"

			[ -z "${styles}" ] && die "You need atleast one of these USE flags set: esd nas oss alsa."
			;;
#		mips)
#			use alsa && styles="${styles} -mips-alsa"
#
#			[ -z "${styles}" ] && die "You need atleast one of these USE flags set: esd nas oss alsa."
#			;;		
	esac

	[ -z "${styles}" ] && die "You need atleast one of these USE flags set: nas oss."


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
