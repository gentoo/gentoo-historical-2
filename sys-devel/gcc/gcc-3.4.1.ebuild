# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-3.4.1.ebuild,v 1.12 2004/07/25 14:22:02 morfic Exp $

IUSE="static nls bootstrap build multilib gcj gtk f77 objc hardened uclibc n32 n64"

inherit eutils flag-o-matic libtool gnuconfig

# Compile problems with these (bug #6641 among others)...
#filter-flags "-fno-exceptions -fomit-frame-pointer -fforce-addr"

# Recently there has been a lot of stability problem in Gentoo-land.  Many
# things can be the cause to this, but I believe that it is due to gcc3
# still having issues with optimizations, or with it not filtering bad
# combinations (protecting the user maybe from himeself) yet.
#
# This can clearly be seen in large builds like glibc, where too aggressive
# CFLAGS cause the tests to fail miserbly.
#
# Quote from Nick Jones <carpaski@gentoo.org>, who in my opinion
# knows what he is talking about:
#
#   People really shouldn't force code-specific options on... It's a
#   bad idea. The -march options aren't just to look pretty. They enable
#   options that are sensible (and include sse,mmx,3dnow when apropriate).
#
# The next command strips CFLAGS and CXXFLAGS from nearly all flags.  If
# you do not like it, comment it, but do not bugreport if you run into
# problems.
#
# <azarah@gentoo.org> (13 Oct 2002)
do_filter_flags() {
	strip-flags

	# In general gcc does not like optimization, and add -O2 where
	# it is safe.  This is especially true for gcc 3.3 + 3.4
	replace-flags -O? -O2

	# -mcpu is deprecated, and will actually break the gcc build on
	# a few archs... so we change it to mtune, and then strip unsupported
	# flags so we dont break versions of gcc that dont understand mtune.
	setting="`get-flag mcpu`"
	[ ! -z "${setting}" ] && \
		replace-flags -mcpu="${setting}" -mtune="${setting}" && \
		ewarn "-mcpu is deprecated" && \
		sleep 5
	strip-unsupported-flags

	# If we use multilib on mips, we shouldn't pass -mabi flag - it breaks
	# build of non-default-abi libraries.
	use mips && use multilib && filter-flags "-mabi*"

	export GCJFLAGS="${CFLAGS}"
}

# Theoretical cross compiler support
[ ! -n "${CCHOST}" ] && export CCHOST="${CHOST}"

LOC="/usr"
MY_PV="`echo ${PV} | awk -F. '{ gsub(/_pre.*|_alpha.*/, ""); print $1 "." $2 }'`"
MY_PV_FULL="`echo ${PV} | awk '{ gsub(/_pre.*|_alpha.*/, ""); print $0 }'`"

# GCC 3.4 no longer uses gcc-lib. we'll rename this later for compatibility
# reasons, as a few things would break without gcc-lib.
LIBPATH="${LOC}/lib/gcc/${CCHOST}/${MY_PV_FULL}"
BINPATH="${LOC}/${CCHOST}/gcc-bin/${MY_PV}"
DATAPATH="${LOC}/share/gcc-data/${CCHOST}/${MY_PV}"
# Dont install in /usr/include/g++-v3/, but in gcc internal directory.
# We will handle /usr/include/g++-v3/ with gcc-config ...
STDCXX_INCDIR="${LIBPATH}/include/g++-v${MY_PV/\.*/}"

# PIE support
PIE_VER="8.7.6.3"

# ProPolice version
PP_VER="3_4"
PP_FVER="${PP_VER//_/.}-2"

# Patch tarball support ...
PATCH_VER="1.0"

# Snapshot support ...
#SNAPSHOT="2002-08-12"
SNAPSHOT=

# Pre-release support
if [ ${PV} != ${PV/_pre/-} ] ; then
	PRERELEASE=${PV/_pre/-}
fi

# Branch update support ...
MAIN_BRANCH="${PV}"  # Tarball, etc used ...
BRANCH_UPDATE=

if [ -n "${PRERELEASE}" ] ; then
	S="${WORKDIR}/gcc-${PRERELEASE}"
	SRC_URI="ftp://gcc.gnu.org/pub/gcc/prerelease-${PRERELEASE}/gcc-${PRERELEASE}.tar.bz2"
elif [ -n "${SNAPSHOT}" ] ; then
	S="${WORKDIR}/gcc-${SNAPSHOT//-}"
	SRC_URI="ftp://sources.redhat.com/pub/gcc/snapshots/${SNAPSHOT}/gcc-${SNAPSHOT//-}.tar.bz2"
else
	S="${WORKDIR}/${PN}-${MAIN_BRANCH}"
	SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/${P}/${PN}-${MAIN_BRANCH}.tar.bz2"
	if [ -n "${BRANCH_UPDATE}" ]
	then
		SRC_URI="${SRC_URI}
		         http://dev.gentoo.org/~lv/${PN}-${MAIN_BRANCH}-branch-update-${BRANCH_UPDATE}.patch.bz2"
	fi
fi

if [ -n "${PATCH_VER}" ]
then
	SRC_URI="${SRC_URI}
	         http://dev.gentoo.org/~lv/${P}-patches-${PATCH_VER}.tar.bz2"
fi

if [ -n "${PP_VER}" ]
then
	SRC_URI="${SRC_URI}
		http://www.research.ibm.com/trl/projects/security/ssp/gcc${PP_VER}/protector-${PP_FVER}.tar.gz"
fi

# PERL cannot be present at bootstrap, and is used to build the man pages. So..
# lets include some pre-generated ones, shall we?
SRC_URI="${SRC_URI}
	http://dev.gentoo.org/~lv/gcc-3.4.1-manpages.tar.bz2"

# bug #6148 - the bounds checking patch interferes with gcc.c

#PIE_BASE_URI="mirror://gentoo/"
PIE_BASE_URI="http://dev.gentoo.org/~lv/"
PIE_CORE="gcc-3.4.0-piepatches-v${PIE_VER}.tar.bz2"
SRC_URI="${SRC_URI} ${PIE_BASE_URI}${PIE_CORE}"

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie and ssp extentions"
HOMEPAGE="http://www.gnu.org/software/gcc/gcc.html"

LICENSE="GPL-2 LGPL-2.1"


KEYWORDS="-* ~mips -hppa amd64 ~ppc64 ~x86"
#KEYWORDS="amd64 ~x86 ~ppc ~sparc ~mips ~ia64 ~ppc64 ~hppa ~alpha ~s390"

# Ok, this is a hairy one again, but lets assume that we
# are not cross compiling, than we want SLOT to only contain
# $PV, as people upgrading to new gcc layout will not have
# their old gcc unmerged ...
# GCC 3.4 introduces a new version of libstdc++
if [ "${CHOST}" == "${CCHOST}" ]
then
	SLOT="${MY_PV}"
else
	SLOT="${CCHOST}-${MY_PV}"
fi

# We need the later binutils for support of the new cleanup attribute.
# 'make check' fails for about 10 tests (if I remember correctly) less
# if we use later bison.
# This one depends on glibc-2.3.2-r3 containing the __guard in glibc
# we scan for Guard@@libgcc and then apply the function moving patch.
# If using NPTL, we currently cannot however depend on glibc-2.3.2-r3,
# else bootstap will break.

# we need a proper glibc version for the Scrt1.o provided to the pie-ssp specs

# we need at least glibc 2.3.3 20040420-r1 in order for gcc 3.4 not to nuke
# SSP in glibc.
DEPEND="virtual/libc
	!uclibc? ( >=sys-libs/glibc-2.3.3_pre20040420-r1 )
	!uclibc? ( hardened? ( >=sys-libs/glibc-2.3.3_pre20040529 ) )
	( !sys-devel/hardened-gcc )
	>=sys-devel/binutils-2.14.90.0.8-r1
	>=sys-devel/bison-1.875
	>=sys-devel/gcc-config-1.3.1
	amd64? ( multilib? ( >=app-emulation/emul-linux-x86-baselibs-1.0 ) )
	!build? ( gcj? ( gtk? ( >=x11-libs/gtk+-2.2 ) ) )
	!build? ( >=sys-libs/ncurses-5.2-r2
	          nls? ( sys-devel/gettext ) )"

RDEPEND="virtual/libc
	!uclibc? ( >=sys-libs/glibc-2.3.3_pre20040420-r1 )
	!uclibc? ( hardened? ( >=sys-libs/glibc-2.3.3_pre20040529 ) )
	>=sys-devel/gcc-config-1.3.1
	>=sys-libs/zlib-1.1.4
	>=sys-apps/texinfo-4.2-r4
	!build? ( >=sys-libs/ncurses-5.2-r2 )"

PDEPEND="sys-devel/gcc-config"

has_lib64() {
	use amd64 && return 0
	use ppc64 && return 0
	return 1
}

chk_gcc_version() {
	# This next bit is for updating libtool linker scripts ...
	local OLD_GCC_VERSION="`gcc -dumpversion`"
	local OLD_GCC_CHOST="$(gcc -v 2>&1 | egrep '^Reading specs' |\
	                       sed -e 's:^.*/gcc[^/]*/\([^/]*\)/[0-9]\+.*$:\1:')"

	if [ "${OLD_GCC_VERSION}" != "${MY_PV_FULL}" ]
	then
		echo "${OLD_GCC_VERSION}" > "${WORKDIR}/.oldgccversion"
	fi

	if [ -n "${OLD_GCC_CHOST}" ]
	then
		if [ "${CHOST}" = "${CCHOST}" -a "${OLD_GCC_CHOST}" != "${CHOST}" ]
		then
			echo "${OLD_GCC_CHOST}" > "${WORKDIR}/.oldgccchost"
		fi
	fi

	# Did we check the version ?
	touch "${WORKDIR}/.chkgccversion"
}

version_patch() {
	[ ! -f "$1" ] && return 1
	[ -z "$2" ] && return 1

	sed -e "s:@GENTOO@:$2:g" ${1} > ${T}/${1##*/}
	epatch ${T}/${1##*/}
}

check_option_validity() {
	# Must compile for mips64-linux target if we want n32/n64 support
	case "${CCHOST}" in
		mips64-*)
		;;
		*)
		    if use n32 || use n64; then
		     eerror "n32/n64 can only be used when target host is mips64-*-linux-*";
		     die "Invalid USE flags for CCHOST ($CCHOST)";
		    fi
		;;
	esac

	#cannot have both n32 & n64 without multilib
	if use n32 && use n64 && ! use multilib; then
		eerror "Please enable multilib if you want to use both n32 & n64";
		die "Invalid USE flag combination";
	fi
}

glibc_have_ssp() {
	use uclibc \
		&& local my_libc="${ROOT}/lib/libc.so.0" \
		|| local my_libc="${ROOT}/lib/libc.so.6"

# Not necessary. lib64 is a symlink to /lib. -- avenj@gentoo.org  3 Apr 04
#	case "${ARCH}" in
#		"amd64")
#			my_libc="${ROOT}/lib64/libc.so.?"
#			;;
#	esac

	# Check for the glibc to have the __guard symbols
	if  [ "$(readelf -s "${my_libc}" 2>/dev/null | \
	         grep GLOBAL | grep OBJECT | grep '__guard')" ] && \
	    [ "$(readelf -s "${my_libc}" 2>/dev/null | \
	         grep GLOBAL | grep FUNC | grep '__stack_smash_handler')" ]
	then
		return 0
	else
		return 1
	fi
}

glibc_have_pie() {
	if [ ! -f ${ROOT}/usr/lib/Scrt1.o ] ; then
		echo
		ewarn "Your glibc does not have support for pie, the file Scrt1.o is missing"
		ewarn "Please update your glibc to a proper version or disable hardened"
		echo
		return 1
	fi
}

check_glibc_ssp() {
	if glibc_have_ssp
	then
		if [ -n "${GLIBC_SSP_CHECKED}" ] && \
		   [ -z "$(readelf -s  "${ROOT}/$(gcc-config -L)/libgcc_s.so" 2>/dev/null | \
		           grep 'GLOBAL' | grep 'OBJECT' | grep '__guard')" ]
		then
			# No need to check again ...
			return 0
		fi

		echo
		ewarn "This sys-libs/glibc has __guard object and __stack_smash_handler functions"
		ewarn "scanning the system for binaries with __guard - this may take 5-10 minutes"
		ewarn "Please do not press ctrl-C or ctrl-Z during this period - it will continue"
		echo
		if ! bash ${FILESDIR}/scan_libgcc_linked_ssp.sh
		then
			echo
			eerror "Found binaries that are dynamically linked to the libgcc with __guard@@GCC"
			eerror "You need to compile these binaries without CFLAGS -fstack-protector/hcc -r"
			echo
			eerror "Also, you have to make sure that using ccache needs the cache to be flushed"
			eerror "wipe out /var/tmp/ccache or /root/.ccache.  This will remove possible saved"
			eerror "-fstack-protector arguments that still may reside in such a compiler cache"
			echo
			eerror "When such binaries are found, gcc cannot remove libgcc propolice functions"
			eerror "leading to gcc -static -fstack-protector breaking, see gentoo bug #25299"
			echo
			einfo  "To do a full scan on your system, enter this following command in a shell"
			einfo  "(Please keep running and remerging broken packages until it do not report"
			einfo  " any breakage anymore!):"
			echo
			einfo  " # ${FILESDIR}/scan_libgcc_linked_ssp.sh"
			echo
			die "Binaries with libgcc __guard@GCC dependencies detected!"
		else
			echo
			einfo "No binaries with suspicious libgcc __guard@GCC dependencies detected"
			echo
		fi
	fi

	return 0
}

update_gcc_for_libc_ssp() {
	if glibc_have_ssp
	then
		einfo "Updating gcc to use SSP from glibc..."
		sed -e 's|^\(LIBGCC2_CFLAGS.*\)$|\1 -D_LIBC_PROVIDES_SSP_|' \
			-i ${S}/gcc/Makefile.in || die "Failed to update gcc!"
	fi
}

src_unpack() {
	local release_version="Gentoo Linux ${PVR}"

	if [ -n "${PP_VER}" ] && [ "${ARCH}" != "hppa" ]
	then
		# the guard check should be very early in the unpack process
		check_glibc_ssp
	fi

	[ -n "${PIE_VER}" ] && use hardened && glibc_have_pie

	if [ -n "${PRERELEASE}" ] ; then
		unpack gcc-${PRERELEASE}.tar.bz2
	elif [ -n "${SNAPSHOT}" ] ; then
		unpack gcc-${SNAPSHOT//-}.tar.bz2
	else
		unpack ${PN}-${MAIN_BRANCH}.tar.bz2
	fi

	if [ -n "${PATCH_VER}" ]
	then
		unpack ${P}-patches-${PATCH_VER}.tar.bz2
	fi

	if [ -n "${PP_VER}" ]
	then
		unpack protector-${PP_FVER}.tar.gz
	fi

	if [ -n "${PIE_VER}" ]
	then
		unpack ${PIE_CORE}
	fi

	cd ${S}
	# Fixup libtool to correctly generate .la files with portage
	elibtoolize --portage --shallow

	# Branch update ...
	if [ -n "${BRANCH_UPDATE}" ]
	then
		epatch ${DISTDIR}/${PN}-${MAIN_BRANCH}-branch-update-${BRANCH_UPDATE}.patch.bz2
	fi

	# Do bulk patches included in ${P}-patches-${PATCH_VER}.tar.bz2
	if [ -n "${PATCH_VER}" ]
	then
		mkdir -p ${WORKDIR}/patch/exclude
		#mv -f ${WORKDIR}/patch/84* ${WORKDIR}/patch/exclude/

		# for uclibc we rather copy the needed files and patch them
		mkdir ${S}/libstdc++-v3/config/{locale/uclibc,os/uclibc} || \
			die "can't create uclibc directories"
		cp ${S}/libstdc++-v3/config/locale/gnu/* \
			${S}/libstdc++-v3/config/locale/uclibc/ || die "can't copy uclibc locale"
		cp ${S}/libstdc++-v3/config/locale/ieee_1003.1-2001/codecvt_specializations.h \
			${S}/libstdc++-v3/config/locale/uclibc/ || die "can't copy uclibc codecvt"
		cp ${S}/libstdc++-v3/config/os/gnu-linux/* \
			${S}/libstdc++-v3/config/os/uclibc/ || die "can't copy uclibc os"
		cp ${S}/gcc/config/t-linux ${S}/gcc/config/t-linux-uclibc || \
			die "can't copy t-linux"
		cp ${S}/gcc/config/cris/t-linux ${S}/gcc/config/cris/t-linux-uclibc || \
			die "can't copy cris/t-linux"
		cp ${S}/gcc/config/sh/t-linux ${S}/gcc/config/sh/t-linux-uclibc || \
			die "can't copy sh/t-linux"
		cp ${S}/gcc/config/sh/t-sh64 ${S}/gcc/config/sh/t-sh64-uclibc || \
			die "can't copy sh/t-sh64"

		if use multilib && [ "${ARCH}" = "amd64" ]
		then
			mv -f ${WORKDIR}/patch/06* ${WORKDIR}/patch/exclude/
			bzip2 -c ${FILESDIR}/gcc331_use_multilib.amd64.patch > \
				${WORKDIR}/patch/06_amd64_gcc331-use-multilib.patch.bz2
		fi

		epatch ${WORKDIR}/patch

		# the uclibc patches need autoconf to be run
		# for build stage we need the updated files though
		use build || ( cd ${S}/libstdc++-v3; autoconf; cd ${S} )
		#use build && use uclibc && ewarn "uclibc in build stage is not supported yet" && exit 1

	elif use multilib && [ "${ARCH}" = "amd64" ]
	then
		# We need this even if there isnt a patchset
		epatch ${FILESDIR}/gcc331_use_multilib.amd64.patch
	fi

	if [ -n "${PIE_VER}" ]
	then
		[ -z "${PATCH_VER}" ] && mv piepatch/upstream/04_* piepatch/

		# corrects startfile/endfile selection and shared/static/pie flag usage
		epatch ${WORKDIR}/piepatch/upstream
		# adds non-default pie support (rs6000)
		epatch ${WORKDIR}/piepatch/nondef
		# adds default pie support (rs6000 too) if DEFAULT_PIE[_SSP] is defined
		epatch ${WORKDIR}/piepatch/def
		# disable relro/now
		use uclibc && epatch ${FILESDIR}/3.3.3/gcc-3.3.3-norelro.patch
	fi

	# non-default SSP support.
	if [ "${ARCH}" != "hppa" -a "${ARCH}" != "hppa64" -a -n "${PP_VER}" ]
	then
		# ProPolice Stack Smashing protection
		epatch ${WORKDIR}/protector.dif

		cp ${WORKDIR}/gcc/protector.c ${S}/gcc/ || die "protector.c not found"
		cp ${WORKDIR}/gcc/protector.h ${S}/gcc/ || die "protector.h not found"
		cp -R ${WORKDIR}/gcc/testsuite/* ${S}/gcc/testsuite/ || die "testsuite not found"

		[ -n "${PATCH_VER}" ] && epatch ${FILESDIR}/3.3.3/gcc-3.3.3-uclibc-add-ssp.patch

		# we apply only the needed parts of protectonly.dif
		sed -e 's|^CRTSTUFF_CFLAGS = |CRTSTUFF_CFLAGS = -fno-stack-protector-all |' \
			-i gcc/Makefile.in || die "Failed to update crtstuff!"
		#sed -e 's|^\(LIBGCC2_CFLAGS.*\)$|\1 -fno-stack-protector-all|' \
		#	-i ${S}/gcc/Makefile.in || die "Failed to update libgcc!"

		# if gcc in a stage3 defaults to ssp, is version 3.4.0 and a stage1 is built
		# the build fails building timevar.o w/:
		# cc1: stack smashing attack in function ix86_split_to_parts()
		if gcc -dumpspecs | grep -q "fno-stack-protector:"
		then
			use build && epatch ${FILESDIR}/3.4.0/gcc-3.4.0-cc1-no-stack-protector.patch
		fi

		release_version="${release_version}, ssp-${PP_FVER}"

		update_gcc_for_libc_ssp
	fi

	release_version="${release_version}, pie-${PIE_VER}"
	if use hardened && ( use x86 || use sparc || use amd64 || use hppa )
	then
		einfo "Updating gcc to use automatic PIE + SSP building ..."
		sed -e 's|^ALL_CFLAGS = |ALL_CFLAGS = -DEFAULT_PIE_SSP |' \
			-i ${S}/gcc/Makefile.in || die "Failed to update gcc!"

		# rebrand to make bug reports easier
		release_version="${release_version/Gentoo/Gentoo Hardened}"
	fi

	version_patch ${FILESDIR}/3.4.1/gcc-${PV}-gentoo-branding.patch \
		"${BRANCH_UPDATE} (${release_version})" || die "Failed Branding"

	# TODO: the binutils on hppa have no PIE linker script to PROVIDE
	# the necessary symbols for initializer and finalizer arrays
	# so, to make the Scrt1.o fly with ld -pie, the glibc in question
	# needs to be equipped with a patch that removes these symbols
	# __init_array_start and __init_array_end from the csu/elf-init.c

	epatch ${FILESDIR}/3.4.0/gcc34-ia64-lib64.patch
	epatch ${FILESDIR}/3.4.0/gcc34-multi32-hack.patch
	epatch ${FILESDIR}/3.4.0/gcc34-reiser4-fix.patch

	# Misdesign in libstdc++ (Redhat)
	cp -a ${S}/libstdc++-v3/config/cpu/i{4,3}86/atomicity.h

	# disable --as-needed from being compiled into gcc specs
	# natively when using >=sys-devel/binutils-2.15.90.0.1 this is
	# done to keep our gcc backwards compatible with binutils. 
	# gcc 3.4.1 cvs has patches that need back porting.. 
	# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=14992 (May 3 2004)
	sed -i -e s/HAVE_LD_AS_NEEDED/USE_LD_AS_NEEDED/g ${S}/gcc/config.in

	use uclibc && gnuconfig_update

	cd ${S}; ./contrib/gcc_update --touch &> /dev/null
}

src_compile() {

	local myconf=
	local gcc_lang=

	check_option_validity

	if ! use build
	then
		myconf="${myconf} --enable-shared"
		gcc_lang="c,c++"
		use f77 && gcc_lang="${gcc_lang},f77"
		use objc && gcc_lang="${gcc_lang},objc"
		use gcj && gcc_lang="${gcc_lang},java"
		# We do NOT want 'ADA support' in here!
		# use ada  && gcc_lang="${gcc_lang},ada"
	else
		gcc_lang="c"
	fi
	if ! use nls || use build
	then
		myconf="${myconf} --disable-nls"
	else
		myconf="${myconf} --enable-nls --without-included-gettext"
	fi

	# GTK+ is preferred over xlib in 3.4.x (xlib is unmaintained
	# right now). Much thanks to <csm@gnu.org> for the heads up.
	# Travis Tilley <lv@gentoo.org>  (11 Jul 2004)
	if ! use build && use gcj && use gtk
	then
		myconf="${myconf} --enable-java-awt=gtk"
	fi

	# Multilib not yet supported
	if use multilib
	then
		einfo "WARNING: Multilib support enabled. This is still experimental."
		myconf="${myconf} --enable-multilib"
	else
		if [ "${ARCH}" = "amd64" ]
		then
			einfo "WARNING: Multilib not enabled. You will not be able to build 32bit binaries."
		fi
		myconf="${myconf} --disable-multilib"
	fi

	# Fix linking problem with c++ apps which where linked
	# against a 3.2.2 libgcc
	[ "${ARCH}" = "hppa" ] && myconf="${myconf} --enable-sjlj-exceptions"

	# --with-gnu-ld needed for cross-compiling
	# --enable-sjlj-exceptions : currently the unwind stuff seems to work 
	# for statically linked apps but not dynamic
	# so use setjmp/longjmp exceptions by default
	# uclibc uses --enable-clocale=uclibc (autodetected)
	# --disable-libunwind-exceptions needed till unwind sections get fixed. see ps.m for details

	if ! use uclibc
	then
		# it's getting close to a time where we are going to need USE=glibc, uclibc, bsdlibc -solar
		myconf="${myconf} --enable-__cxa_atexit --enable-clocale=gnu"
	else
		myconf="${myconf} --disable-__cxa_atexit --enable-target-optspace --with-gnu-ld --enable-sjlj-exceptions"
	fi

	# Default arch support disabled for now...
	#use amd64 && myconf="${myconf} --with-arch=k8"
	#use s390 && myconf="${myconf} --with-arch=nofreakingclue"
	#use x86 && myconf="${myconf} --with-arch=i586"
	#use mips && myconf="${myconf} --with-arch=mips3"

	# Add --with-abi flags to enable respective MIPS ABIs
	case "${CCHOST}" in
	    mips*)
		use multilib && myconf="${myconf} --with-abi=32"
		use n32 && myconf="${myconf} --with-abi=n32"
		use n64 && myconf="${myconf} --with-abi=n64"
	    ;;
	esac

	do_filter_flags
	einfo "CFLAGS=\"${CFLAGS}\""
	einfo "CXXFLAGS=\"${CXXFLAGS}\""
	einfo "GCJFLAGS=\"${GCJFLAGS}\""

	# Build in a separate build tree
	mkdir -p ${WORKDIR}/build
	cd ${WORKDIR}/build

	# Install our pre generated manpages if we do not have perl ...
	if [ ! -x /usr/bin/perl ]
	then
		unpack ${P}-manpages.tar.bz2 || die "Failed to unpack man pages"
	fi

	einfo "Configuring GCC..."
	addwrite "/dev/zero"
	${S}/configure --prefix=${LOC} \
		--bindir=${BINPATH} \
		--includedir=${LIBPATH}/include \
		--datadir=${DATAPATH} \
		--mandir=${DATAPATH}/man \
		--infodir=${DATAPATH}/info \
		--enable-shared \
		--host=${CHOST} \
		--target=${CCHOST} \
		--with-system-zlib \
		--enable-languages=${gcc_lang} \
		--enable-threads=posix \
		--enable-long-long \
		--disable-checking \
		--disable-libunwind-exceptions \
		--enable-cstdio=stdio \
		--enable-version-specific-runtime-libs \
		--with-gxx-include-dir=${STDCXX_INCDIR} \
		--with-local-prefix=${LOC}/local \
		--disable-werror \
		${myconf} || die

	touch ${S}/gcc/c-gperf.h

	# Do not make manpages if we do not have perl ...
	if [ ! -x /usr/bin/perl ]
	then
		find ${WORKDIR}/build -name '*.[17]' -exec touch {} \; || :
	fi

	# Setup -j in MAKEOPTS
	get_number_of_jobs

	einfo "Building GCC..."
	# Only build it static if we are just building the C frontend, else
	# a lot of things break because there are not libstdc++.so ....
	if use static && [ "${gcc_lang}" = "c" ]
	then
		# Fix for our libtool-portage.patch
		S="${WORKDIR}/build" \
		emake LDFLAGS="-static" bootstrap \
			LIBPATH="${LIBPATH}" \
			BOOT_CFLAGS="${CFLAGS}" STAGE1_CFLAGS="-O" || die
		# Above FLAGS optimize and speedup build, thanks
		# to Jeff Garzik <jgarzik@mandrakesoft.com>
	else
		# Fix for our libtool-portage.patch
		S="${WORKDIR}/build" \
		emake profiledbootstrap \
			LIBPATH="${LIBPATH}" \
			BOOT_CFLAGS="${CFLAGS}" STAGE1_CFLAGS="-O" || die

	fi
}

src_install() {
	local x=

	# Do allow symlinks in ${LOC}/lib/gcc-lib/${CHOST}/${PV}/include as
	# this can break the build.
	for x in ${WORKDIR}/build/gcc/include/*
	do
		if [ -L ${x} ]
		then
			rm -f ${x}
			continue
		fi
	done
	# Remove generated headers, as they can cause things to break
	# (ncurses, openssl, etc).
	for x in `find ${WORKDIR}/build/gcc/include/ -name '*.h'`
	do
		if grep -q 'It has been auto-edited by fixincludes from' ${x}
		then
			rm -f ${x}
		fi
	done

	einfo "Installing GCC..."
	# Do the 'make install' from the build directory
	cd ${WORKDIR}/build
	S="${WORKDIR}/build" \
	make prefix=${LOC} \
		bindir=${BINPATH} \
		includedir=${LIBPATH}/include \
		datadir=${DATAPATH} \
		mandir=${DATAPATH}/man \
		infodir=${DATAPATH}/info \
		DESTDIR="${D}" \
		LIBPATH="${LIBPATH}" \
		install || die

	[ -r ${D}${BINPATH}/gcc ] || die "gcc not found in ${D}"

	# Because GCC 3.4 installs into the gcc directory and not the gcc-lib
	# directory, we will have to rename it in order to keep compatibility
	# with our current libtool check and gcc-config (which would be a pain
	# to fix compared to this simple mv and symlink).
	mv ${D}/${LOC}/lib/gcc ${D}/${LOC}/lib/gcc-lib
	ln -s gcc-lib ${D}/${LOC}/lib/gcc
	LIBPATH=${LIBPATH/lib\/gcc/lib\/gcc-lib}

	dodir /lib /usr/bin
	dodir /etc/env.d/gcc
	echo "PATH=\"${BINPATH}\"" > ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	echo "ROOTPATH=\"${BINPATH}\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}

	# The LDPATH stuff is kinda iffy now that we need to provide compatibility
	# with older versions of GCC for binary apps.
	if use multilib && [ "${ARCH}" = "amd64" ]
	then
		# amd64 is a bit unique because of multilib.  Add some other paths
		LDPATH="${LIBPATH}:${LIBPATH}/32:${LIBPATH}/../lib64:${LIBPATH}/../lib32"
	else
		LDPATH="${LIBPATH}"
	fi
	if [ "${BULIB}" != "" ]
	then
		LDPATH="${LDPATH}:${LOC}/lib/gcc-lib/${CCHOST}/${BULIB}"
	fi
	echo "LDPATH=\"${LDPATH}\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}

	echo "MANPATH=\"${DATAPATH}/man\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	echo "INFOPATH=\"${DATAPATH}/info\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	echo "STDCXX_INCDIR=\"${STDCXX_INCDIR##*/}\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	# Also set CC and CXX
	echo "CC=\"gcc\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	echo "CXX=\"g++\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}

	# Make sure we do not check glibc for SSP again, as we did already
	if glibc_have_ssp || \
	   [ -f "${ROOT}/etc/env.d/99glibc_ssp" ]
	then
		echo "GLIBC_SSP_CHECKED=1" > ${D}/etc/env.d/99glibc_ssp
	fi

	# Make sure we dont have stuff lying around that
	# can nuke multiple versions of gcc
	if ! use build
	then
		cd ${D}${LIBPATH}

		# Tell libtool files where real libraries are
		for x in ${D}${LOC}/lib/*.la ${D}${LIBPATH}/../*.la
		do
			if [ -f "${x}" ]
			then
				sed -i -e "s:/usr/lib:${LIBPATH}:" ${x}
				mv ${x} ${D}${LIBPATH}
			fi
		done

		# Move all the libraries to version specific libdir.
		for x in ${D}${LOC}/lib/*.{so,a}* ${D}${LIBPATH}/../*.{so,a}*
		do
			[ -f "${x}" -o -L "${x}" ] && mv -f ${x} ${D}${LIBPATH}
		done

		# Move Java headers to compiler-specific dir
		for x in ${D}${LOC}/include/gc*.h ${D}${LOC}/include/j*.h
		do
			[ -f "${x}" ] && mv -f ${x} ${D}${LIBPATH}/include/
		done
		for x in gcj gnu java javax org
		do
			if [ -d "${D}${LOC}/include/${x}" ]
			then
				dodir /${LIBPATH}/include/${x}
				mv -f ${D}${LOC}/include/${x}/* ${D}${LIBPATH}/include/${x}/
				rm -rf ${D}${LOC}/include/${x}
			fi
		done

		if [ -d "${D}${LOC}/lib/security" ]
		then
			dodir /${LIBPATH}/security
			mv -f ${D}${LOC}/lib/security/* ${D}${LIBPATH}/security
			rm -rf ${D}${LOC}/lib/security
		fi

		# Move libgcj.spec to compiler-specific directories
		[ -f "${D}${LOC}/lib/libgcj.spec" ] && \
			mv -f ${D}${LOC}/lib/libgcj.spec ${D}${LIBPATH}/libgcj.spec

		# Rename jar because it could clash with Kaffe's jar if this gcc is
		# primary compiler (aka don't have the -<version> extension)
		cd ${D}${LOC}/${CCHOST}/gcc-bin/${MY_PV}
		[ -f jar ] && mv -f jar gcj-jar

		# Move <cxxabi.h> to compiler-specific directories
		[ -f "${D}${STDCXX_INCDIR}/cxxabi.h" ] && \
			mv -f ${D}${STDCXX_INCDIR}/cxxabi.h ${D}${LIBPATH}/include/

		# These should be symlinks
		cd ${D}${BINPATH}
		for x in gcc g++ c++ g77 gcj
		do
			rm -f ${CCHOST}-${x}
			[ -f "${x}" ] && ln -sf ${x} ${CCHOST}-${x}

			if [ -f "${CCHOST}-${x}-${PV}" ]
			then
				rm -f ${CCHOST}-${x}-${PV}
				ln -sf ${x} ${CCHOST}-${x}-${PV}
			fi
		done
	fi

	# This one comes with binutils
	if [ -f "${D}${LOC}/lib/libiberty.a" ]
	then
		rm -f ${D}${LOC}/lib/libiberty.a
	fi
	if [ -f "${D}${LIBPATH}/libiberty.a" ]
	then
		rm -f ${D}${LIBPATH}/libiberty.a
	fi

	cd ${S}
	if ! use build
	then
		cd ${S}
		docinto /${CCHOST}
		dodoc COPYING COPYING.LIB ChangeLog* FAQ MAINTAINERS README
		docinto ${CCHOST}/html
		dohtml *.html
		cd ${S}/boehm-gc
		docinto ${CCHOST}/boehm-gc
		dodoc ChangeLog doc/{README*,barrett_diagram}
		docinto ${CCHOST}/boehm-gc/html
		dohtml doc/*.html
		cd ${S}/gcc
		docinto ${CCHOST}/gcc
		dodoc ChangeLog* FSFChangeLog* LANGUAGES NEWS ONEWS README* SERVICE
		if use f77
		then
			cd ${S}/libf2c
			docinto ${CCHOST}/libf2c
			dodoc ChangeLog* README TODO *.netlib
		fi
		cd ${S}/libffi
		docinto ${CCHOST}/libffi
		dodoc ChangeLog* LICENSE README
		cd ${S}/libiberty
		docinto ${CCHOST}/libiberty
		dodoc ChangeLog* COPYING.LIB README
		if use objc
		then
			cd ${S}/libobjc
			docinto ${CCHOST}/libobjc
			dodoc ChangeLog* README* THREADS*
		fi
		cd ${S}/libstdc++-v3
		docinto ${CCHOST}/libstdc++-v3
		dodoc ChangeLog* README
		docinto ${CCHOST}/libstdc++-v3/html
		dohtml -r -a css,diff,html,txt,xml docs/html/*
		cp -f docs/html/17_intro/[A-Z]* \
			${D}/usr/share/doc/${PF}/${DOCDESTTREE}/17_intro/

		if use gcj
		then
			cd ${S}/fastjar
			docinto ${CCHOST}/fastjar
			dodoc AUTHORS CHANGES COPYING ChangeLog* NEWS README
			cd ${S}/libjava
			docinto ${CCHOST}/libjava
			dodoc ChangeLog* COPYING HACKING LIBGCJ_LICENSE NEWS README THANKS
		fi

		prepman ${DATAPATH}
		prepinfo ${DATAPATH}
	else
		rm -rf ${D}/usr/share/{man,info}
		rm -rf ${D}${DATAPATH}/{man,info}
	fi

	# Rather install the script, else portage with changing $FILESDIR
	# between binary and source package borks things ....
	insinto /lib/rcscripts/awk
	doins ${FILESDIR}/awk/fixlafiles.awk
	exeinto /sbin
	doexe ${FILESDIR}/fix_libtool_files.sh

	if has_lib64
	then
		# GCC 3.4 tries to place libgcc_s in lib64, where it will never be
		# found. When multilib is enabled, it also places the 32bit version in
		# lib32. This problem could be handled by a symlink if you only plan on
		# having one compiler installed at a time, but since these directories
		# exist outside the versioned directories, versions from gcc 3.3 and
		# 3.4 will overwrite each other. not good.
		use multilib && \
		cp -pfd ${D}/${LIBPATH}/../lib32/libgcc_s* ${D}/${LIBPATH}
		cp -pfd ${D}/${LIBPATH}/../lib64/libgcc_s* ${D}/${LIBPATH}
	fi
}

pkg_preinst() {

	if [ ! -f "${WORKDIR}/.chkgccversion" ]
	then
		chk_gcc_version
	fi

	# Make again sure that the linker "should" be able to locate
	# libstdc++.so ...
	if use multilib && [ "${ARCH}" = "amd64" ]
	then
		# Can't always find libgcc_s.so.1, make it find it
		export LD_LIBRARY_PATH="${LIBPATH}:${LIBPATH}/../lib64:${LIBPATH}/../lib32:${LD_LIBRARY_PATH}"
	else
		export LD_LIBRARY_PATH="${LIBPATH}:${LD_LIBRARY_PATH}"
	fi
	${ROOT}/sbin/ldconfig
}

pkg_postinst() {

	if use multilib && [ "${ARCH}" = "amd64" ]
	then
		# Can't always find libgcc_s.so.1, make it find it
		export LD_LIBRARY_PATH="${LIBPATH}:${LIBPATH}/../lib64:${LIBPATH}/../lib32:${LD_LIBRARY_PATH}"
	else
		export LD_LIBRARY_PATH="${LIBPATH}:${LD_LIBRARY_PATH}"
	fi
	if [ "${ROOT}" = "/" -a "${COMPILER}" = "gcc3" -a "${CHOST}" = "${CCHOST}" ]
	then
		gcc-config --use-portage-chost ${CCHOST}-${MY_PV_FULL}
	fi

	# Update libtool linker scripts to reference new gcc version ...
	if [ "${ROOT}" = "/" ] && \
	   [ -f "${WORKDIR}/.oldgccversion" -o -f "${WORKDIR}/.oldgccchost" ]
	then
		local OLD_GCC_VERSION=
		local OLD_GCC_CHOST=

		if [ -f "${WORKDIR}/.oldgccversion" ] && \
		   [ -n "$(cat "${WORKDIR}/.oldgccversion")" ]
		then
			OLD_GCC_VERSION="$(cat "${WORKDIR}/.oldgccversion")"
		else
			OLD_GCC_VERSION="${MY_PV_FULL}"
		fi

		if [ -f "${WORKDIR}/.oldgccchost" ] && \
		   [ -n "$(cat "${WORKDIR}/.oldgccchost")" ]
		then
			OLD_GCC_CHOST="--oldarch $(cat "${WORKDIR}/.oldgccchost")"
		fi

		/sbin/fix_libtool_files.sh ${OLD_GCC_VERSION} ${OLD_GCC_CHOST}
	fi

	ewarn "If you are migrating to gcc 3.4 from a previous compiler, it is"
	ewarn "HIGHLY suggested you install libstdc++-v3 before uninstalling"
	ewarn "your old compiler, even if you dont plan on using any binary only"
	ewarn "applications that would otherwise need it. If you dont, then all"
	ewarn "c++ applications will break."
}

