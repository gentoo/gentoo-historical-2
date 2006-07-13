# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-3.4.6.ebuild,v 1.10 2006/07/13 11:34:13 kevquinn Exp $

MAN_VER=""
PATCH_VER="1.0"
UCLIBC_VER="1.1"
UCLIBC_GCC_VER="3.4.5"
PIE_VER="8.7.9"
PIE_GCC_VER="3.4.5"
PP_VER="1.0"
PP_GCC_VER="3.4.5"
HTB_VER="1.00"
HTB_GCC_VER="3.4.4"

GCC_LIBSSP_SUPPORT="true"

ETYPE="gcc-compiler"

# arch/libc configurations known to be stable with {PIE,SSP}-by-default
SSP_STABLE="x86 sparc amd64 ppc ppc64"
SSP_UCLIBC_STABLE="arm mips ppc x86"
PIE_GLIBC_STABLE="x86 sparc amd64 ppc ppc64"
PIE_UCLIBC_STABLE="x86 mips ppc"

# arch/libc configurations known to be broken with {PIE,SSP}-by-default
SSP_UNSUPPORTED="hppa"
SSP_UCLIBC_UNSUPPORTED="${SSP_UNSUPPORTED}"
PIE_UCLIBC_UNSUPPORTED="alpha amd64 arm hppa ia64 m68k ppc64 s390 sh sparc"
PIE_GLIBC_UNSUPPORTED="hppa"

# whether we should split out specs files for multiple {PIE,SSP}-by-default
# and vanilla configurations.
SPLIT_SPECS=${SPLIT_SPECS-true}

#GENTOO_PATCH_EXCLUDE=""
#PIEPATCH_EXCLUDE=""

inherit toolchain eutils

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie+ssp extensions, Haj Ten Brugge runtime bounds checking"

KEYWORDS="-* ~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"

# we need a proper glibc version for the Scrt1.o provided to the pie-ssp specs
# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND="|| ( app-admin/eselect-compiler >=sys-devel/gcc-config-1.3.12-r4 )
	>=sys-libs/zlib-1.1.4
	elibc_glibc? (
		>=sys-libs/glibc-2.3.3_pre20040420-r1
		hardened? ( >=sys-libs/glibc-2.3.3_pre20040529 )
	)
	!build? (
		gcj? (
			gtk? (
				|| ( ( x11-libs/libXt x11-libs/libX11 x11-libs/libXtst x11-proto/xproto x11-proto/xextproto ) virtual/x11 )
				>=x11-libs/gtk+-2.2
			)
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
	>=sys-devel/bison-1.875
	>=sys-devel/binutils-2.14.90.0.8-r1
	amd64? ( >=sys-devel/binutils-2.15.90.0.1.1-r1 )"
PDEPEND="|| ( app-admin/eselect-compiler sys-devel/gcc-config )
	x86? ( !nocxx? ( !elibc_uclibc? ( !build? ( || ( sys-libs/libstdc++-v3 =sys-devel/gcc-3.3* ) ) ) ) )"

src_unpack() {
	gcc_src_unpack

	# misc patches that havent made it into a patch tarball yet
	[[ ${CHOST} == ${CTARGET} ]] && epatch "${FILESDIR}"/gcc-spec-env.patch

	# nothing in the tree provides libssp.so, so nothing will ever trigger this
	# logic, but having the patch in the tree makes life so much easier for me
	# since I dont have to also have an overlay for this.
	want_libssp && epatch "${FILESDIR}"/3.4.3/libssp.patch

	# Anything useful and objc will require libffi. Seriously. Lets just force
	# libffi to install with USE="objc", even though it normally only installs
	# if you attempt to build gcj.
	if ! use build && use objc && ! use gcj ; then
		epatch "${FILESDIR}"/3.4.3/libffi-without-libgcj.patch
		#epatch ${FILESDIR}/3.4.3/libffi-nogcj-lib-path-fix.patch
	fi

	# Fix cross-compiling
	epatch "${FILESDIR}"/3.4.4/gcc-3.4.4-cross-compile.patch

	[[ ${CTARGET} == *-softfloat-* ]] && epatch "${FILESDIR}"/3.4.4/gcc-3.4.4-softfloat.patch

	# Arch stuff
	case $(tc-arch) in
		mips)
			# If mips, and we DON'T want multilib, then rig gcc to only use n32 OR n64
			if ! is_multilib; then
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
			if use ip28 or use ip32r10k; then
				epatch ${FILESDIR}/3.4.2/gcc-3.4.2-mips-ip28_cache_barriers-v4.patch
			fi
			;;
		amd64)
			if is_multilib ; then
				sed -i -e '/GLIBCXX_IS_NATIVE=/s:false:true:' libstdc++-v3/configure || die
			fi
			;;
	esac

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
