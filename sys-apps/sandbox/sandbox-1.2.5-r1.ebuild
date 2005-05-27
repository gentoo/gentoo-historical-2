# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sandbox/sandbox-1.2.5-r1.ebuild,v 1.2 2005/05/27 22:14:33 vapier Exp $

#
# don't monkey with this ebuild unless contacting portage devs.
# period.
#

inherit eutils flag-o-matic eutils toolchain-funcs multilib

DESCRIPTION="sandbox'd LD_PRELOAD hack"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://dev.gentoo.org/~azarah/sandbox/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS=" alpha  amd64  arm  hppa  ia64  m68k  mips  ppc  ppc-macos  ppc64  s390  sh  sparc  x86"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""
RESTRICT="multilib-pkg-force"

DEPEND=""

pkg_setup() {
	if ! has_multilib_profile && has_m32 && [[ ${CONF_MULTILIBDIR} == "lib32" ]] && use amd64; then
		export DEFAULT_ABI="amd64"
		export MULTILIB_ABIS="x86 amd64"
		export CFLAGS_amd64="-m64"
		export CFLAGS_x86="-m32 -L/emul/linux/x86/lib -L/emul/linux/x86/usr/lib"
		export LIBDIR_amd64="${CONF_LIBDIR}"
		export LIBDIR_x86="${CONF_MULTILIBDIR}"
	fi
}

src_unpack() {
	for ABI in $(get_install_abis) ; do
		unpack ${A}
		cd ${WORKDIR}
		einfo "Unpacking sandbox for ABI=${ABI}..."
		mv ${S} ${S%/}-${ABI} || die "failed moving \$S to ${ABI}"
	done
}

abi_fail_check() {
	local ABI=$1
	if [[ ${ABI} == "x86" ]] ; then
		echo
		eerror "Building failed for ABI=x86!.  This usually means a broken"
		eerror "multilib setup.  Please fix that before filling a bugreport"
		eerror "against sandbox."
		echo
	fi
}

src_compile() {
	filter-lfs-flags #90228

	has_multilib_profile && append-flags -DSB_HAVE_64BIT_ARCH

	OABI="${ABI}"
	for ABI in $(get_install_abis); do
		export ABI
		cd ${S}-${ABI}
		einfo "Configuring sandbox for ABI=${ABI}..."
		econf --libdir="/usr/$(get_libdir)" || {
			abi_fail_check "${ABI}"
			die "econf failed for ${ABI}"
		}
		einfo "Building sandbox for ABI=${ABI}..."
		emake || {
			abi_fail_check "${ABI}"
			die "emake failed for ${ABI}"
		}
	done
	ABI="${OABI}"
}

src_install() {
	OABI="${ABI}"
	for ABI in $(get_install_abis); do
		export ABI
		cd ${S}-${ABI}
		einfo "Installing sandbox for ABI=${ABI}..."
		make DESTDIR="${D}" install || die "make install failed for ${ABI}"
	done
	ABI="${OABI}"
}
