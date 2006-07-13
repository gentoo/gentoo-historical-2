# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-3.3.5-r1.ebuild,v 1.30 2006/07/13 11:34:13 kevquinn Exp $

MAN_VER="3.3.5"
#BRANCH_UPDATE="20041025"
PATCH_VER="1.0"
PIE_VER="8.7.7.1"
PIE_CORE="gcc-3.3.5-piepatches-v${PIE_VER}.tar.bz2"
PP_VER="3_3_2"
PP_FVER="${PP_VER//_/.}-3"
HTB_VER="1.00"
#HTB_GCC_VER=""
HTB_EXCLUSIVE="true"

ETYPE="gcc-compiler"

# arch/libc configurations known to be stable with {PIE,SSP}-by-default
SSP_STABLE="x86 sparc amd64"
SSP_UCLIBC_STABLE=""
PIE_GLIBC_STABLE="x86 sparc amd64"
PIE_UCLIBC_STABLE="x86 mips ppc"

# arch/libc configurations known to be broken with {PIE,SSP}-by-default
SSP_UNSUPPORTED="hppa"
SSP_UCLIBC_UNSUPPORTED="${SSP_UNSUPPORTED}"
PIE_UCLIBC_UNSUPPORTED="alpha amd64 arm hppa ia64 m68k ppc64 s390 sh sparc"
PIE_GLIBC_UNSUPPORTED="hppa"

# whether we should split out specs files for multiple {PIE,SSP}-by-default
# and vanilla configurations.
SPLIT_SPECS="${SPLIT_SPECS:="true"}"

#GENTOO_PATCH_EXCLUDE=""
#PIEPATCH_EXCLUDE=""

inherit toolchain eutils

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie+ssp extensions, Haj Ten Brugge runtime bounds checking"

KEYWORDS="~alpha ~amd64 arm hppa -ia64 ~mips s390 sh sparc x86"

# we need a proper glibc version for the Scrt1.o provided to the pie-ssp specs
# we also need at least glibc 2.3.3 20040420-r1 in order for gcc 3.4 not to nuke
# SSP in glibc.

# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND="virtual/libc
	|| ( app-admin/eselect-compiler >=sys-devel/gcc-config-1.3.6 )
	>=sys-libs/zlib-1.1.4
	elibc_glibc? ( >=sys-libs/glibc-2.3.2-r9 )
	>=sys-devel/binutils-2.14.90.0.6-r1
	>=sys-devel/bison-1.875
	sparc? ( hardened? ( >=sys-libs/glibc-2.3.3.20040420 ) )
	!build? (
		gcj? (
			gtk? ( >=x11-libs/gtk+-2.2 )
			>=media-libs/libart_lgpl-2.1
		)
		>=sys-libs/ncurses-5.2-r2
		nls? ( sys-devel/gettext )
	)"

if [[ ${CATEGORY/cross-} != ${CATEGORY} ]]; then
	RDEPEND="${RDEPEND} ${CATEGORY}/binutils"
fi

DEPEND="${RDEPEND}
	>=sys-apps/texinfo-4.2-r4
	amd64? ( >=sys-devel/binutils-2.15.90.0.1.1-r1 )"
PDEPEND="|| ( app-admin/eselect-compiler sys-devel/gcc-config )"

src_unpack() {
	gcc_src_unpack

	if [ -n "${PATCH_VER}" ] && use elibc_uclibc ; then
		mv ${S}/gcc-3.3.2/libstdc++-v3/config/os/uclibc ${S}/libstdc++-v3/config/os/ || die
		mv ${S}/gcc-3.3.2/libstdc++-v3/config/locale/uclibc ${S}/libstdc++-v3/config/locale/ || die
		epatch ${FILESDIR}/3.3.3/gcc-uclibc-3.3-loop.patch
	fi

	# misc patches that havent made it into a patch tarball yet
	[[ ${CHOST} == ${CTARGET} ]] && epatch "${FILESDIR}"/gcc-spec-env.patch

	# fix an incorrect prototype of ffecom_gfrt_basictype() which causes
	# 3.3.5 to not compile on some configurations.
	epatch ${FILESDIR}/3.3.5/gcc-3.3.5-ffecom_gfrt_basictype-prototype.patch

	case $(tc-arch ${CTARGET}) in
		ppc)
			epatch ${FILESDIR}/3.3.3/gcc333_pre20040408-stack-size.patch
			;;
		arm)
			epatch ${FILESDIR}/3.3.3/gcc333-debian-arm-getoff.patch
			epatch ${FILESDIR}/3.3.3/gcc333-debian-arm-ldm.patch
			;;
	esac

	# Anything useful and objc will require libffi. Seriously. Lets just force
	# libffi to install with USE="objc", even though it normally only installs
	# if you attempt to build gcj.
	if use !build && use objc && ! use gcj ; then
		epatch ${FILESDIR}/3.3.4/libffi-without-libgcj.patch
		#epatch ${FILESDIR}/3.4.3/libffi-nogcj-lib-path-fix.patch
	fi

	# Don't screw with directories when cross-compiling
	epatch ${FILESDIR}/3.3.5/gcc-3.3.5-no-COPYING-cross-compile.patch

	# bug #139918 - conflict between gcc and java-config-2 for ownership of
	# /usr/bin/rmi{c,registry}.  Done with mv & sed rather than a patch
	# because patches would be large (thanks to the rename of man files),
	# and it's clear from the sed invocations that all that changes is the
	# rmi{c,registry} names to grmi{c,registry} names.
	# Kevin F. Quinn 2006-07-12
	einfo "Renaming jdk executables rmic and rmiregistry to grmic and grmiregistry."
	# 1) Move the man files if present (missing prior to gcc-3.4)
	for manfile in rmic rmiregistry; do
		[[ -f ${S}/gcc/doc/${manfile}.1 ]] || continue
		mv ${S}/gcc/doc/${manfile}.1 ${S}/gcc/doc/g${manfile}.1
	done
	# 2) Fixup references in the docs if present (mission prior to gcc-3.4)
	for jfile in gcc/doc/gcj.info gcc/doc/grmic.1 gcc/doc/grmiregistry.1 gcc/java/gcj.texi; do
		[[ -f ${S}/${jfile} ]] || continue
		sed -i -e 's:rmiregistry:grmiregistry:g' ${S}/${jfile} ||
			die "Failed to fixup file ${jfile} for rename to grmiregistry"
		sed -i -e 's:rmic:grmic:g' ${S}/${jfile} ||
			die "Failed to fixup file ${jfile} for rename to grmic"
	done
	# 3) Fixup Makefiles to build the changed executable names
	#    These are present in all 3.x versions, and are the important bit
	#    to get gcc to build with the new names.
	for jfile in libjava/Makefile.am libjava/Makefile.in gcc/java/Make-lang.in; do
		sed -i -e 's:rmiregistry:grmiregistry:g' ${S}/${jfile} ||
			die "Failed to fixup file ${jfile} for rename to grmiregistry"
		# Careful with rmic on these files; it's also the name of a directory
		# which should be left unchanged.  When it appears as a directory,
		# it has a '/' after it.
		sed -i -e 's:rmic\([$_ ]\):grmic\1:g' ${S}/${jfile} ||
			die "Failed to fixup file ${jfile} for rename to grmic"
	done
}
