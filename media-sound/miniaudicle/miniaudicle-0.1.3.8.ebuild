# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/miniaudicle/miniaudicle-0.1.3.8.ebuild,v 1.2 2009/06/29 01:32:26 halcy0n Exp $

inherit eutils toolchain-funcs flag-o-matic

MY_P=${P/a/A}

DESCRIPTION="integrated development + performance environment for chuck"
HOMEPAGE="http://audicle.cs.princeton.edu/mini/"
SRC_URI="http://audicle.cs.princeton.edu/mini/release/files/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="oss jack alsa"

RDEPEND="jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( >=media-libs/alsa-lib-0.9 )
	media-libs/libsndfile
	>=x11-libs/wxGTK-2.6"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	local cnt=0
	use jack && cnt="$((${cnt} + 1))"
	use alsa && cnt="$((${cnt} + 1))"
	use oss && cnt="$((${cnt} + 1))"
	if [[ "${cnt}" -eq 0 ]] ; then
		eerror "One of the following USE flags is needed: jack, alsa or oss"
		die "Please set one audio engine type"
	elif [[ "${cnt}" -ne 1 ]] ; then
		ewarn "You have set ${P} to use multiple audio engine."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-hid-smc.patch"
	epatch "${FILESDIR}/${P}-gcc44.patch"
}

src_compile() {
	local backend
	if use jack; then
		backend="jack"
	elif use oss; then
		backend="oss"
	else
		backend="alsa"
	fi
	einfo "Compiling against ${backend}"

	# when compiled with -march=athlon or -march=athlon-xp
	# miniaudicle crashes on removing a shred with a double free or corruption
	# it happens in Chuck_VM_Stack::shutdown() on the line
	#   SAFE_DELETE_ARRAY( stack );
	replace-cpu-flags athlon athlon-xp i686

	cd "${S}"/chuck/src
	emake -f "makefile.${backend}" CC=$(tc-getCC) CXX=$(tc-getCXX) || die "emake failed"

	cd "${S}"
	emake -f "makefile.${backend}" CC=$(tc-getCC) CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dobin wxw/miniAudicle
	dodoc BUGS README.linux VERSIONS
}
