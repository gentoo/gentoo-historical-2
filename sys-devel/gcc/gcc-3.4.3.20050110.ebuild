# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-3.4.3.20050110.ebuild,v 1.3 2005/01/15 01:23:07 vapier Exp $

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie+ssp extensions, Haj Ten Brugge runtime bounds checking"

#KEYWORDS="-* ~amd64 ~mips ~ppc64 ~x86 -hppa ~ppc ~sparc ~ia64"
KEYWORDS="-*"

# we need a proper glibc version for the Scrt1.o provided to the pie-ssp specs
# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND="virtual/libc
	>=sys-devel/gcc-config-1.3.6-r4
	>=sys-libs/zlib-1.1.4
	!sys-devel/hardened-gcc
	!uclibc? (
		>=sys-libs/glibc-2.3.3_pre20040420-r1
		hardened? ( >=sys-libs/glibc-2.3.3_pre20040529 )
	)
	emul-linux-x86? ( multilib? ( >=app-emulation/emul-linux-x86-glibc-1.1 ) )
	!build? (
		gcj? (
			gtk? ( >=x11-libs/gtk+-2.2 )
			>=media-libs/libart_lgpl-2.1
		)
		>=sys-libs/ncurses-5.2-r2
		nls? ( sys-devel/gettext )
	)"
DEPEND="${RDEPEND}
	>=sys-apps/texinfo-4.2-r4
	>=sys-devel/bison-1.875
	>=sys-devel/binutils-2.14.90.0.8-r1
	amd64? ( >=sys-devel/binutils-2.15.90.0.1.1-r1 )"
PDEPEND="sys-devel/gcc-config
	!nocxx? ( !mips? ( !ia64? ( !uclibc? ( !build? ( sys-libs/libstdc++-v3 ) ) ) ) )"


GENTOO_TOOLCHAIN_BASE_URI="http://dev.gentoo.org/~eradicator/gcc/"
#GCC_MANPAGE_VERSION="none"
PATCH_VER="1.1"
PIE_VER="8.7.7"
PIE_CORE="gcc-3.4.3-piepatches-v${PIE_VER}.tar.bz2"
PP_VER="3.4.3.20050110"
PP_FVER="${PP_VER//_/.}-0"
HTB_VER="1.00"
HTB_GCC_VER="3.4.2"

GCC_LIBSSP_SUPPORT="true"

ETYPE="gcc-compiler"

# arch/libc configurations known to be stable with {PIE,SSP}-by-default
SSP_STABLE="x86 sparc amd64"
SSP_UCLIBC_STABLE="arm mips ppc x86"
PIE_GLIBC_STABLE="x86 sparc amd64"
PIE_UCLIBC_STABLE="x86 mips ppc"

# arch/libc configurations known to be broken with {PIE,SSP}-by-default
SSP_UNSUPPORTED="hppa"
SSP_UCLIBC_UNSUPPORTED="${SSP_UNSUPPORTED}"
PIE_UCLIBC_UNSUPPORTED="alpha amd64 arm hppa ia64 m68k ppc64 s390 sh sparc"
PIE_GLIBC_UNSUPPORTED="hppa"

# whether we should split out specs files for multiple {PIE,SSP}-by-default
# and vanilla configurations.
SPLIT_SPECS=${SPLIT_SPECS:=true}

#GENTOO_PATCH_EXCLUDE=""
#PIEPATCH_EXCLUDE=""

inherit toolchain

src_unpack() {
	gcc_src_unpack

	# bah
	sed -e 's/3\.4\.4/3.4.3/' -i ${S}/gcc/version.c

	# misc patches that havent made it into a patch tarball yet
	epatch ${FILESDIR}/3.4.0/gcc34-reiser4-fix.patch
	epatch ${FILESDIR}/gcc-spec-env.patch
	epatch ${FILESDIR}/3.4.2/810-arm-bigendian-uclibc.patch

	# nothing in the tree provides libssp.so, so nothing will ever trigger this
	# logic, but having the patch in the tree makes life so much easier for me
	# since I dont have to also have an overlay for this.
	want_libssp && epatch ${FILESDIR}/3.4.3/libssp.patch

	# Anything useful and objc will require libffi. Seriously. Lets just force
	# libffi to install with USE="objc", even though it normally only installs
	# if you attempt to build gcj.
	if use objc && ! use gcj ; then
		epatch ${FILESDIR}/3.4.3/libffi-without-libgcj.patch
		#epatch ${FILESDIR}/3.4.3/libffi-nogcj-lib-path-fix.patch
	fi

	# hack around some ugly 32bit sse2 wrong-code bugs
	epatch ${FILESDIR}/3.4.2/gcc34-m32-no-sse2.patch
	epatch ${FILESDIR}/3.4.2/gcc34-fix-sse2_pinsrw.patch

	# Fix cross-compiling
	epatch ${FILESDIR}/3.4.3/gcc-3.4.3-cross-compile.patch

	# If mips, and we DON'T want multilib, then rig gcc to only use n32 OR n64
	case $(tc-arch ${CTARGET}) in
		mips)
			# If mips, and we DON'T want multilib, then rig gcc to only use n32 OR n64
			if use !multilib; then
				use n32 && epatch ${FILESDIR}/3.4.1/gcc-3.4.1-mips-n32only.patch
				use n64 && epatch ${FILESDIR}/3.4.1/gcc-3.4.1-mips-n64only.patch
			fi

			# Patch forward-ported from a gcc-3.0.x patch that adds -march=r10000 and
			# -mtune=r10000 support to gcc (Allows the compiler to generate code to
			# take advantage of R10k's second ALU, perform shifts, etc..
			#
			# Needs re-porting to DFA in gcc-4.0 - Any Volunteers? :)
			epatch ${FILESDIR}/3.4.2/gcc-3.4.x-mips-add-march-r10k.patch

			# This is a very special patch -- it allows us to build semi-usable kernels
			# on SGI IP28 (Indigo2 Impact R10000) systems.  The patch is henceforth
			# regarded as a kludge by upstream, and thus, it will never get accepted upstream,
			# but for our purposes of building a kernel, it works.
			# Unless you're building an IP28 kernel, you really don't need care about what
			# this patch does, because if you are, you are probably already aware of what
			# it does.
			# All that said, the abilities of this patch are disabled by default and need
			# to be enabled by passing -mip28-cache-barrier.  Only used to build kernels, 
			# There is the possibility it may be used for very specific userland apps too.
			if use ip28; then
				epatch ${FILESDIR}/3.4.2/gcc-3.4.2-mips-ip28_cache_barriers.patch
			fi
			;;
		amd64)
			if use multilib; then
				epatch ${FILESDIR}/3.4.1/gcc-3.4.1-glibc-is-native.patch
				cd ${S}/libstdc++-v3
				einfo "running autoreconf..."
				autoreconf 2> /dev/null
				cd ${S}
			fi
			;;
	esac
}
