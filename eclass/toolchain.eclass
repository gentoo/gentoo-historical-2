# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/toolchain.eclass,v 1.61 2004/12/05 20:28:27 vapier Exp $


HOMEPAGE="http://www.gnu.org/software/gcc/gcc.html"
LICENSE="GPL-2 LGPL-2.1"


#---->> eclass stuff <<----
inherit eutils versionator libtool
ECLASS=toolchain
INHERITED="$INHERITED $ECLASS"
DESCRIPTION="Based on the ${ECLASS} eclass"
EXPORT_FUNCTIONS src_unpack pkg_setup src_compile src_install

toolchain_src_install() {
	${ETYPE}-src_install
}
toolchain_src_compile() {
	gcc_src_compile
}
toolchain_src_unpack() {
	gcc_src_unpack
}
toolchain_pkg_setup() {
	gcc_pkg_setup
}
#----<< eclass stuff >>----


#---->> globals <<----
export CTARGET="${CTARGET:-${CHOST}}"

MY_PV_FULL="$(get_version_component_range 1-3)"
MY_PV="$(get_version_component_range 1-2)"
GCCMAJOR="$(get_version_component_range 1)"
GCCMINOR="$(get_version_component_range 2)"
GCCMICRO="$(get_version_component_range 3)"

MAIN_BRANCH="${PV}"  # Tarball, etc used ...
# Pre-release support
if [ ${PV} != ${PV/_pre/-} ] ; then
	PRERELEASE=${PV/_pre/-}
fi
# make _alpha and _beta ebuilds automatically use a snapshot
if [ ${PV} != ${PV/_alpha/} ] ; then
	SNAPSHOT="${MY_PV}-${PV##*_alpha}"
elif [ ${PV} != ${PV/_beta/} ] ; then
	SNAPSHOT="${MY_PV}-${PV##*_beta}"
fi

if [ "${ETYPE}" == "gcc-library" ] ; then
	GCC_VAR_TYPE="${GCC_VAR_TYPE:=non-versioned}"
	GCC_LIB_COMPAT_ONLY="${GCC_LIB_COMPAT_ONLY:=true}"
	GCC_TARGET_NO_MULTILIB="${GCC_TARGET_NO_MULTILIB:=true}"
else
	GCC_VAR_TYPE="${GCC_VAR_TYPE:=versioned}"
	GCC_LIB_COMPAT_ONLY="false"
	GCC_TARGET_NO_MULTILIB="${GCC_TARGET_NO_MULTILIB:=false}"
fi

PREFIX="${PREFIX:="/usr"}"

if [ "${GCC_VAR_TYPE}" == "versioned" ] ; then
	if version_is_at_least 3.4.0 ; then
		# GCC 3.4 no longer uses gcc-lib.
		LIBPATH="${LIBPATH:="${PREFIX}/lib/gcc/${CTARGET}/${MY_PV_FULL}"}"
	else
		LIBPATH="${LIBPATH:="${PREFIX}/lib/gcc-lib/${CTARGET}/${MY_PV_FULL}"}"
	fi
	INCLUDEPATH="${INCLUDEPATH:="${LIBPATH}/include"}"
	BINPATH="${BINPATH:="${PREFIX}/${CTARGET}/gcc-bin/${MY_PV_FULL}"}"
	DATAPATH="${DATAPATH:="${PREFIX}/share/gcc-data/${CTARGET}/${MY_PV_FULL}"}"
	# Dont install in /usr/include/g++-v3/, but in gcc internal directory.
	# We will handle /usr/include/g++-v3/ with gcc-config ...
	STDCXX_INCDIR="${STDCXX_INCDIR:="${LIBPATH}/include/g++-v${MY_PV/\.*/}"}"
elif [ "${GCC_VAR_TYPE}" == "non-versioned" ] ; then
	# using non-versioned directories to install gcc, like what is currently
	# done for ppc64 and 3.3.3_pre, is a BAD IDEA. DO NOT do it!! However...
	# setting up variables for non-versioned directories might be useful for
	# specific gcc targets, like libffi. Note that we dont override the value
	# returned by get_libdir here.
	LIBPATH="${LIBPATH:="${PREFIX}/$(get_libdir)"}"
	INCLUDEPATH="${INCLUDEPATH:="${PREFIX}/include"}"
	BINPATH="${BINPATH:="${PREFIX}/bin/"}"
	DATAPATH="${DATAPATH:="${PREFIX}/share/"}"
	STDCXX_INCDIR="${STDCXX_INCDIR:="${PREFIX}/include/g++-v3/"}"
fi
#----<< globals >>----


#---->> SLOT+IUSE logic <<----
if [ "${ETYPE}" == "gcc-library" ] ; then
	IUSE="nls build uclibc"
	SLOT="${CTARGET}-${SO_VERSION_SLOT:-5}"
else
	IUSE="static nls bootstrap build multislot multilib gcj gtk fortran nocxx objc hardened uclibc n32 n64"
	if [ -n "${HTB_VER}" ] ; then
		IUSE="${IUSE} boundschecking"
	fi
	use multislot \
		&& SLOT="${CTARGET}-${MY_PV_FULL}" \
		|| SLOT="${CTARGET}-${MY_PV}"
fi
#----<< SLOT+IUSE logic >>----


#---->> S + SRC_URI essentials <<----

# This function sets the source directory depending on whether we're using
# a prerelease, snapshot, or release tarball. To use it, just set S with:
#
#	S="$(gcc_get_s_dir)"
#
# Travis Tilley <lv@gentoo.org> (03 Sep 2004)
#
gcc_get_s_dir() {
	if [ -n "${PRERELEASE}" ] ; then
		GCC_S="${WORKDIR}/gcc-${PRERELEASE}"
	elif [ -n "${SNAPSHOT}" ] ; then
		GCC_S="${WORKDIR}/gcc-${SNAPSHOT}"
	else
		GCC_S="${WORKDIR}/gcc-${MAIN_BRANCH}"
	fi

	echo "${GCC_S}"
}

# This function handles the basics of setting the SRC_URI for a gcc ebuild.
# To use, set SRC_URI with:
#
#	SRC_URI="$(get_gcc_src_uri)"
#
# Other than the variables normally set by portage, this function's behavior
# can be altered by setting the following:
#
#	GENTOO_TOOLCHAIN_BASE_URI
#			This sets the base URI for all gentoo-specific patch files. Note
#			that this variable is only important for a brief period of time,
#			before your source files get picked up by mirrors. However, it is
#			still highly suggested that you keep files in this location
#			available.
#
#	SNAPSHOT
#			If set, this variable signals that we should be using a snapshot
#			of gcc from ftp://sources.redhat.com/pub/gcc/snapshots/. It is
#			expected to be in the format "YYYY-MM-DD". Note that if the ebuild
#			has a _pre suffix, this variable is ignored and the prerelease
#			tarball is used instead.
#
#	BRANCH_UPDATE
#			If set, this variable signals that we should be using the main
#			release tarball (determined by ebuild version) and applying a
#			CVS branch update patch against it. The location of this branch
#			update patch is assumed to be in ${GENTOO_TOOLCHAIN_BASE_URI}.
#			Just like with SNAPSHOT, this variable is ignored if the ebuild
#			has a _pre suffix.
#
#	PATCH_VER
#	PATCH_GCC_VER
#			This should be set to the version of the gentoo patch tarball.
#			The resulting filename of this tarball will be:
#			${PN}-${PATCH_GCC_VER:=${PV}}-patches-${PATCH_VER}.tar.bz2
#
#	PIE_VER
#	PIE_CORE
#			These variables control patching in various updates for the logic
#			controlling Position Independant Executables. PIE_VER is expected
#			to be the version of this patch, and PIE_CORE the actual filename
#			of the patch. An example:
#					PIE_VER="8.7.6.5"
#					PIE_CORE="gcc-3.4.0-piepatches-v${PIE_VER}.tar.bz2"
#
#	PP_VER
#	PP_FVER
#			These variables control patching in stack smashing protection
#			support. They both control the version of ProPolice to download.
#			PP_VER sets the version of the directory in which to find the
#			patch, and PP_FVER sets the version of the patch itself. For
#			example:
#					PP_VER="3_4"
#					PP_FVER="${PP_VER//_/.}-2"
#			would download gcc3_4/protector-3.4-2.tar.gz
#
#	HTB_VER
#	HTB_GCC_VER
#			These variables control whether or not an ebuild supports Herman
#			ten Brugge's bounds-checking patches. If you want to use a patch
#			for an older gcc version with a new gcc, make sure you set
#			HTB_GCC_VER to that version of gcc.
#
#	GCC_MANPAGE_VERSION
#			The version of gcc for which we will download manpages. This will
#			default to ${PV}, but we may not want to pre-generate man pages
#			for prerelease test ebuilds for example. This allows you to
#			continue using pre-generated manpages from the last stable release.
#			If set to "none", this will prevent the downloading of manpages,
#			which is useful for individual library targets.
#
# Travis Tilley <lv@gentoo.org> (02 Sep 2004)
#
get_gcc_src_uri() {
	# This variable should be set to the devspace of whoever is currently
	# maintaining GCC. Please dont set this to mirror, that would just
	# make the files unavailable until they get mirrored.
	local devspace_uri="http://dev.gentoo.org/~lv/GCC/"
	GENTOO_TOOLCHAIN_BASE_URI=${GENTOO_TOOLCHAIN_BASE_URI:=${devspace_uri}}

	if [ -n "${PIE_VER}" ] ; then
		PIE_CORE="${PIE_CORE:=gcc-${MY_PV_FULL}-piepatches-v${PIE_VER}.tar.bz2}"
	fi

	GCC_MANPAGE_VERSION="${GCC_MANPAGE_VERSION:=${MY_PV_FULL}}"

	# Set where to download gcc itself depending on whether we're using a
	# prerelease, snapshot, or release tarball.
	if [ -n "${PRERELEASE}" ] ; then
		GCC_SRC_URI="ftp://gcc.gnu.org/pub/gcc/prerelease-${PRERELEASE}/gcc-${PRERELEASE}.tar.bz2"
	elif [ -n "${SNAPSHOT}" ] ; then
		GCC_SRC_URI="ftp://sources.redhat.com/pub/gcc/snapshots/${SNAPSHOT}/gcc-${SNAPSHOT}.tar.bz2"
	else
		GCC_SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/${P}/gcc-${MAIN_BRANCH}.tar.bz2"
		# we want all branch updates to be against the main release
		if [ -n "${BRANCH_UPDATE}" ] ; then
			GCC_SRC_URI="${GCC_SRC_URI}
				${GENTOO_TOOLCHAIN_BASE_URI}/${PN}-${MAIN_BRANCH}-branch-update-${BRANCH_UPDATE}.patch.bz2"
		fi
	fi

	# propolice aka stack smashing protection
	if [ -n "${PP_VER}" ] ; then
		GCC_SRC_URI="${GCC_SRC_URI}
			http://www.research.ibm.com/trl/projects/security/ssp/gcc${PP_VER}/protector-${PP_FVER}.tar.gz"
	fi

	# PERL cannot be present at bootstrap, and is used to build the man pages.
	# So... lets include some pre-generated ones, shall we?
	if [ "${GCC_MANPAGE_VERSION}" != "none" ] ; then
		GCC_SRC_URI="${GCC_SRC_URI}
			${GENTOO_TOOLCHAIN_BASE_URI}/gcc-${GCC_MANPAGE_VERSION}-manpages.tar.bz2"
	fi

	# various gentoo patches
	if [ -n "${PATCH_VER}" ] ; then
		GCC_SRC_URI="${GCC_SRC_URI}
			${GENTOO_TOOLCHAIN_BASE_URI}/${PN}-${PATCH_GCC_VER:=${PV}}-patches-${PATCH_VER}.tar.bz2"
	fi

	# strawberry pie, Cappuccino and a Gauloises
	if [ -n "${PIE_CORE}" ] ; then
		GCC_SRC_URI="${GCC_SRC_URI}
			${GENTOO_TOOLCHAIN_BASE_URI}${PIE_CORE}"
	fi

	# gcc bounds checking patch
	if [ -n "${HTB_VER}" ] ; then
		GCC_SRC_URI="${GCC_SRC_URI}
					boundschecking? ( http://web.inter.nl.net/hcc/Haj.Ten.Brugge/bounds-checking-${PN}-${HTB_GCC_VER:=${PV}}-${HTB_VER}.patch.bz2 )"
	fi

	echo "${GCC_SRC_URI}"
}
S="$(gcc_get_s_dir)"
SRC_URI="$(get_gcc_src_uri)"
#---->> S + SRC_URI essentials >>----


#---->> support checks <<----

# The gentoo piessp patches allow for 3 configurations:
# 1) PIE+SSP by default
# 2) PIE by default
# 3) SSP by default
hardened_gcc_works() {
	if [ "$1" == "pie" ] ; then
		hardened_gcc_is_stable pie && return 0
		if has ~${ARCH} ${ACCEPT_KEYWORDS} ; then
			hardened_gcc_check_unsupported pie && return 1
			ewarn "Allowing pie-by-default for an unstable arch (${ARCH})"
			return 0
		fi
		return 1
	elif [ "$1" == "ssp" ] ; then
		hardened_gcc_is_stable ssp && return 0
		if has ~${ARCH} ${ACCEPT_KEYWORDS} ; then
			hardened_gcc_check_unsupported ssp && return 1
			ewarn "Allowing ssp-by-default for an unstable arch (${ARCH})"
			return 0
		fi
		return 1
	else
		# laziness ;)
		hardened_gcc_works pie || return 1
		hardened_gcc_works ssp || return 1
		return 0
	fi
}

hardened_gcc_is_stable() {
	if [ "$1" == "pie" ] ; then
		# HARDENED_* variables are deprecated and here for compatibility
		local tocheck="${HARDENED_PIE_WORKS} ${HARDENED_GCC_WORKS}"
		if use uclibc ; then
			tocheck="${tocheck} ${PIE_UCLIBC_STABLE}"
		else
			tocheck="${tocheck} ${PIE_GLIBC_STABLE}"
		fi
	elif [ "$1" == "ssp" ] ; then
		# ditto
		local tocheck="${HARDENED_SSP_WORKS} ${HARDENED_GCC_WORKS}"
		if use uclibc ; then
			tocheck="${tocheck} ${SSP_UCLIBC_STABLE}"
		else
			tocheck="${tocheck} ${SSP_STABLE}"
		fi
	else
		die "hardened_gcc_stable needs to be called with pie or ssp"
	fi

	hasq ${ARCH} ${tocheck} && return 0
	return 1
}

hardened_gcc_check_unsupported() {
	local tocheck=""
	# if a variable is unset, we assume that all archs are unsupported. since
	# this function is never called if hardened_gcc_is_stable returns true,
	# this shouldn't cause problems... however, allowing this logic to work
	# even with the variables unset will break older ebuilds that dont use them.
	if [ "$1" == "pie" ] ; then
		if use uclibc ; then
			[ "${PIE_UCLIBC_UNSUPPORTED:-unset}" == "unset" ] && return 0
			tocheck="${tocheck} ${PIE_UCLIBC_UNSUPPORTED}"
		else
			[ "${PIE_GLIBC_UNSUPPORTED:-unset}" == "unset" ] && return 0
			tocheck="${tocheck} ${PIE_GLIBC_UNSUPPORTED}"
		fi
	elif [ "$1" == "ssp" ] ; then
		if use uclibc ; then
			[ "${SSP_UCLIBC_UNSUPPORTED:-unset}" == "unset" ] && return 0
			tocheck="${tocheck} ${SSP_UCLIBC_UNSUPPORTED}"
		else
			[ "${SSP_UNSUPPORTED:-unset}" == "unset" ] && return 0
			tocheck="${tocheck} ${SSP_UNSUPPORTED}"
		fi
	else
		die "hardened_gcc_check_unsupported needs to be called with pie or ssp"
	fi

	hasq ${ARCH} ${tocheck} && return 0
	return 1
}

has_libssp() {
	[ -e /$(get_libdir)/libssp.so ] && return 0
	return 1
}

want_libssp() {
	[ "${GCC_LIBSSP_SUPPORT}" == "true" ] || return 1
	has_libssp || return 1
	[ -n "${PP_FVER}" ] || return 1
	return 0
}

want_boundschecking() {
	[ -z "${HTB_VER}" ] && return 1
	use boundschecking && return 0
	return 1
}

want_split_specs() {
	[ "${SPLIT_SPECS}" == "true" ] && [ -n "${PIE_CORE}" ] && \
		! want_boundschecking && return 0
	return 1
}

# This function checks whether or not glibc has the support required to build
# Position Independant Executables with gcc.
glibc_have_pie() {
	if [ ! -f ${ROOT}/usr/$(get_libdir)/Scrt1.o ] ; then
		echo
		ewarn "Your glibc does not have support for pie, the file Scrt1.o is missing"
		ewarn "Please update your glibc to a proper version or disable hardened"
		echo
		return 1
	fi
}

# This function determines whether or not libc has been patched with stack
# smashing protection support.
libc_has_ssp() {
	local libc_prefix
	use ppc64 && libc_prefix="/lib64/"
	libc_prefix="${libc_prefix:="/$(get_libdir)/"}"

	echo 'int main(){}' > ${T}/libctest.c
	gcc ${T}/libctest.c -lc -o libctest
	local libc_file=$(readelf -d libctest | grep 'NEEDED.*\[libc\.so[0-9\.]*\]' | awk '{print $NF}')
	libc_file="${libc_file:1:${#libc_file}-2}"

	local my_libc=${ROOT}/${libc_prefix}/${libc_file}

	# Check for the libc to have the __guard symbols
	if  [ "$(readelf -s "${my_libc}" 2>/dev/null | \
	         grep 'OBJECT.*GLOBAL.*__guard')" ] && \
	    [ "$(readelf -s "${my_libc}" 2>/dev/null | \
	         grep 'FUNC.*GLOBAL.*__stack_smash_handler')" ]
	then
		return 0
	else
		return 1
	fi
}

# This is to make sure we don't accidentally try to enable support for a
# language that doesnt exist. GCC 3.4 supports f77, while 4.0 supports f95, etc.
#
# Travis Tilley <lv@gentoo.org> (26 Oct 2004)
#
gcc-lang-supported() {
	grep ^language=\"${1}\" ${S}/gcc/*/config-lang.in > /dev/null && return 0
	ewarn "The ${1} language is not supported by this release of gcc"
	return 1
}

#----<< support checks >>----



#---->> specs + env.d logic <<----

# configure to build with the hardened GCC specs as the default
make_gcc_hard() {
	if hardened_gcc_works ; then
		einfo "Updating gcc to use automatic PIE + SSP building ..."
		sed -e 's|^HARD_CFLAGS = |HARD_CFLAGS = -DEFAULT_PIE_SSP |' \
			-i ${S}/gcc/Makefile.in || die "Failed to update gcc!"
	elif hardened_gcc_works pie ; then
		einfo "Updating gcc to use automatic PIE building ..."
		ewarn "SSP has not been enabled by default"
		sed -e 's|^HARD_CFLAGS = |HARD_CFLAGS = -DEFAULT_PIE |' \
			-i ${S}/gcc/Makefile.in || die "Failed to update gcc!"
	elif hardened_gcc_works ssp ; then
		einfo "Updating gcc to use automatic SSP building ..."
		ewarn "PIE has not been enabled by default"
		sed -e 's|^HARD_CFLAGS = |HARD_CFLAGS = -DEFAULT_SSP |' \
			-i ${S}/gcc/Makefile.in || die "Failed to update gcc!"
	else
		# do nothing if hardened isnt supported, but dont die either
		ewarn "hardened is not supported for this arch in this gcc version"
		ebeep
		return 0
	fi

	# rebrand to make bug reports easier
	release_version="${release_version/Gentoo/Gentoo Hardened}"
}

create_vanilla_specs_file() {
	pushd ${WORKDIR}/build/gcc > /dev/null
	if use hardened ; then
		# if using hardened, then we need to move xgcc out of the way
		# and recompile it
		cp Makefile Makefile.orig
		sed -i -e 's/^HARD_CFLAGS.*/HARD_CFLAGS = /g' Makefile
		mv xgcc xgcc.hard
		mv gcc.o gcc.o.hard
		make xgcc
		einfo "Creating a vanilla gcc specs file"
		./xgcc -dumpspecs > ${WORKDIR}/build/vanilla.specs
		# restore everything to normal
		mv gcc.o.hard gcc.o
		mv xgcc.hard xgcc
		mv Makefile.orig Makefile
	else
		einfo "Creating a vanilla gcc specs file"
		./xgcc -dumpspecs > ${WORKDIR}/build/vanilla.specs
	fi
	popd > /dev/null
}

create_hardened_specs_file() {
	pushd ${WORKDIR}/build/gcc > /dev/null
	if use !hardened ; then
		# if not using hardened, then we need to move xgcc out of the way
		# and recompile it
		cp Makefile Makefile.orig
		sed -i -e 's/^HARD_CFLAGS.*/HARD_CFLAGS = -DEFAULT_PIE_SSP/g' Makefile
		mv xgcc xgcc.vanilla
		mv gcc.o gcc.o.vanilla
		make xgcc
		einfo "Creating a hardened gcc specs file"
		./xgcc -dumpspecs > ${WORKDIR}/build/hardened.specs
		# restore everything to normal
		mv gcc.o.vanilla gcc.o
		mv xgcc.vanilla xgcc
		mv Makefile.orig Makefile
	else
		einfo "Creating a hardened gcc specs file"
		./xgcc -dumpspecs > ${WORKDIR}/build/hardened.specs
	fi
	popd > /dev/null
}

create_hardenednossp_specs_file() {
	pushd ${WORKDIR}/build/gcc > /dev/null
	cp Makefile Makefile.orig
	sed -i -e 's/^HARD_CFLAGS.*/HARD_CFLAGS = -DEFAULT_PIE/g' Makefile
	mv xgcc xgcc.moo
	mv gcc.o gcc.o.moo
	make xgcc
	einfo "Creating a hardened no-ssp gcc specs file"
	./xgcc -dumpspecs > ${WORKDIR}/build/hardenednossp.specs
	# restore everything to normal
	mv gcc.o.moo gcc.o
	mv xgcc.moo xgcc
	mv Makefile.orig Makefile
	popd > /dev/null
}

create_hardenednopie_specs_file() {
	pushd ${WORKDIR}/build/gcc > /dev/null
	cp Makefile Makefile.orig
	sed -i -e 's/^HARD_CFLAGS.*/HARD_CFLAGS = -DEFAULT_SSP/g' Makefile
	mv xgcc xgcc.moo
	mv gcc.o gcc.o.moo
	make xgcc
	einfo "Creating a hardened no-pie gcc specs file"
	./xgcc -dumpspecs > ${WORKDIR}/build/hardenednopie.specs
	# restore everything to normal
	mv gcc.o.moo gcc.o
	mv xgcc.moo xgcc
	mv Makefile.orig Makefile
	popd > /dev/null
}

split_out_specs_files() {
	want_split_specs || return 1
	if hardened_gcc_works ; then
		create_hardened_specs_file
		create_vanilla_specs_file
		create_hardenednossp_specs_file
		create_hardenednopie_specs_file
	elif hardened_gcc_works pie ; then
		create_vanilla_specs_file
		create_hardenednossp_specs_file
	elif hardened_gcc_works ssp ; then
		create_vanilla_specs_file
		create_hardenednopie_specs_file
	fi
}

create_gcc_env_entry() {
	dodir /etc/env.d/gcc
	local gcc_envd_base="/etc/env.d/gcc/${CTARGET}-${MY_PV_FULL}"

	if [ "$1" == "" ] ; then
		gcc_envd_file="${D}${gcc_envd_base}"
		# I'm leaving the following commented out to remind me that it
		# was an insanely -bad- idea. Stuff broke. GCC_SPECS isnt unset
		# on chroot or in non-toolchain.eclass gcc ebuilds!
		#gcc_specs_file="${LIBPATH}/specs"
		gcc_specs_file=""
	else
		gcc_envd_file="${D}${gcc_envd_base}-$1"
		gcc_specs_file="${LIBPATH}/$1.specs"
	fi

	echo "CTARGET=${CTARGET}" > ${gcc_envd_file}
	echo "PATH=\"${BINPATH}\"" >> ${gcc_envd_file}
	echo "ROOTPATH=\"${BINPATH}\"" >> ${gcc_envd_file}

	# Thanks to multilib, setting ldpath just got a little bit nuttier.
	use amd64 && multilib_dirnames="32"
	# we dont support this kind of amd64 multilib
	#use x86 && multilib_dirnames="64"
	# I'm unsure which of these is the default, so lets add both
	use ppc64 && multilib_dirnames="64 32"
	# same here.
	use mips && multilib_dirnames="o32 32 64"

	LDPATH="${LIBPATH}"

	if [ -n "${multilib_dirnames}" ] ; then
		for path in ${multilib_dirnames} ; do
			LDPATH="${LDPATH}:${LIBPATH}/${path}"
		done
	fi

	local mbits=
	has_m32 && mbits="${mbits} 32"
	has_m64 && mbits="${mbits} 64"
	echo "GCCBITS=\"${mbits}\"" >> ${gcc_envd_file}

	echo "LDPATH=\"${LDPATH}\"" >> ${gcc_envd_file}
	echo "MANPATH=\"${DATAPATH}/man\"" >> ${gcc_envd_file}
	echo "INFOPATH=\"${DATAPATH}/info\"" >> ${gcc_envd_file}
	echo "STDCXX_INCDIR=\"${STDCXX_INCDIR##*/}\"" >> ${gcc_envd_file}
	# Set which specs file to use
	[ -n "${gcc_specs_file}" ] && echo "GCC_SPECS=\"${gcc_specs_file}\"" >> ${gcc_envd_file}
}

#----<< specs + env.d logic >>----



#---->> unorganised crap in need of refactoring follows

gcc_pkg_setup() {
	if [ "${ETYPE}" == "gcc-compiler" ] ; then
		# Must compile for mips64-linux target if we want n32/n64 support
		case "${CTARGET}" in
			mips64-*) ;;
			*)
				if use n32 || use n64; then
					eerror "n32/n64 can only be used when target host is mips64-*-linux-*";
					die "Invalid USE flags for CTARGET ($CTARGET)";
				fi
			;;
		esac

		#cannot have both n32 & n64 without multilib
		if use n32 && use n64 && use !multilib; then
			eerror "Please enable multilib if you want to use both n32 & n64";
			die "Invalid USE flag combination";
		fi

		# we dont want to use the installed compiler's specs to build gcc!
		unset GCC_SPECS || :
	fi

	want_libssp && libc_has_ssp && \
		die "libssp cannot be used with a glibc that has been patched to provide ssp symbols"
}


# gcc_quick_unpack will unpack the gcc tarball and patches in a way that is
# consistant with the behavior of get_gcc_src_uri. The only patch it applies
# itself is the branch update if present.
#
# Travis Tilley <lv@gentoo.org> (03 Sep 2004)
#
gcc_quick_unpack() {
	pushd ${WORKDIR} > /dev/null

	if [ -n "${PRERELEASE}" ] ; then
		unpack gcc-${PRERELEASE}.tar.bz2
	elif [ -n "${SNAPSHOT}" ] ; then
		unpack gcc-${SNAPSHOT}.tar.bz2
	else
		unpack gcc-${MAIN_BRANCH}.tar.bz2
		# We want branch updates to be against a release tarball
		if [ -n "${BRANCH_UPDATE}" ] ; then
			pushd ${S:="$(gcc_get_s_dir)"} > /dev/null
			epatch ${DISTDIR}/gcc-${MAIN_BRANCH}-branch-update-${BRANCH_UPDATE}.patch.bz2
			popd > /dev/null
		fi
	fi

	if [ -n "${PATCH_VER}" ]
	then
		unpack ${PN}-${PATCH_GCC_VER:=${PV}}-patches-${PATCH_VER}.tar.bz2
	fi

	if [ -n "${PP_VER}" ]
	then
		# The gcc 3.4 propolice versions are meant to be unpacked to ${S}
		pushd ${S:="$(gcc_get_s_dir)"} > /dev/null
		unpack protector-${PP_FVER}.tar.gz
		popd > /dev/null
	fi

	if [ -n "${PIE_VER}" ]
	then
		unpack ${PIE_CORE}
	fi

	# pappy@gentoo.org - Fri Oct  1 23:24:39 CEST 2004
	if want_boundschecking
	then
		unpack "bounds-checking-${PN}-${HTB_GCC_VER:=${PV}}-${HTB_VER}.patch.bz2"
	fi

	popd > /dev/null
}

# Exclude any unwanted patches, as specified by the following variables:
#
#	GENTOO_PATCH_EXCLUDE
#			List of filenames, relative to ${WORKDIR}/patch/
#
#	PIEPATCH_EXCLUDE
#			List of filenames, relative to ${WORKDIR}/piepatch/
#
# Travis Tilley <lv@gentoo.org> (03 Sep 2004)
#
exclude_gcc_patches() {
	local i
	for i in ${GENTOO_PATCH_EXCLUDE} ; do
		if [ -f ${WORKDIR}/patch/${i} ] ; then
			einfo "Excluding patch ${i}"
			rm -f ${WORKDIR}/patch/${i} || die "failed to delete ${i}"
		fi
	done
	for i in ${PIEPATCH_EXCLUDE} ; do
		if [ -f ${WORKDIR}/piepatch/${i} ] ; then
			einfo "Excluding piepatch ${i}"
			rm -f ${WORKDIR}/piepatch/${i} || die "failed to delete ${i}"
		fi
	done
}

do_gcc_HTB_boundschecking_patches() {
	# modify the bounds checking patch with a regression patch
	epatch "${WORKDIR}/bounds-checking-${PN}-${HTB_GCC_VER:=${PV}}-${HTB_VER}.patch"
	release_version="${release_version}, HTB-${HTB_VER}"
}

# patch in ProPolice Stack Smashing protection
do_gcc_SSP_patches() {
	local ssppatch
	local sspdocs

	# Etoh keeps changing where files are and what the patch is named
	if version_is_at_least 3.4.1 ; then
		# >3.4.1 uses version in patch name, and also includes docs
		ssppatch="${S}/gcc_${PP_VER}.dif"
		sspdocs="yes"
	elif version_is_at_least 3.4.0 ; then
		# >3.4 put files where they belong and 3_4 uses old patch name
		ssppatch="${S}/protector.dif"
		sspdocs="no"
	elif version_is_at_least 3.2.3 ; then
		# earlier versions have no directory structure or docs
		mv ${S}/protector.{c,h} ${S}/gcc
		ssppatch="${S}/protector.dif"
		sspdocs="no"
	else
		die "gcc version not supported by do_gcc_SSP_patches"
	fi

	epatch ${ssppatch}

	if [ "${PN}" == "gcc" -a "${sspdocs}" == "no" ] ; then
		epatch ${FILESDIR}/pro-police-docs.patch
	fi

	# we apply only the needed parts of protectonly.dif
	sed -e 's|^CRTSTUFF_CFLAGS = |CRTSTUFF_CFLAGS = -fno-stack-protector-all |'\
		-i gcc/Makefile.in || die "Failed to update crtstuff!"

	# if gcc in a stage3 defaults to ssp, is version 3.4.0 and a stage1 is built
	# the build fails building timevar.o w/:
	# cc1: stack smashing attack in function ix86_split_to_parts()
	if gcc -dumpspecs | grep -q "fno-stack-protector:" && version_is_at_least 3.4.0 && ! version_is_at_least 4.0.0 && [ -f ${FILESDIR}/3.4.0/gcc-3.4.0-cc1-no-stack-protector.patch ] ; then
		use build && epatch ${FILESDIR}/3.4.0/gcc-3.4.0-cc1-no-stack-protector.patch
	fi

	release_version="${release_version}, ssp-${PP_FVER}"
	if want_libssp ; then
		update_gcc_for_libssp
	else
		update_gcc_for_libc_ssp
	fi
}

# If glibc or uclibc has been patched to provide the necessary symbols itself,
# then lets use those for SSP instead of libgcc.
update_gcc_for_libc_ssp() {
	if libc_has_ssp ; then
		einfo "Updating gcc to use SSP from libc ..."
		sed -e 's|^\(LIBGCC2_CFLAGS.*\)$|\1 -D_LIBC_PROVIDES_SSP_|' \
			-i ${S}/gcc/Makefile.in || die "Failed to update gcc!"
	fi
}

# a split out non-libc non-libgcc ssp requires additional spec logic changes
update_gcc_for_libssp() {
	einfo "Updating gcc to use SSP from libssp..."
	sed -e 's|^\(INTERNAL_CFLAGS.*\)$|\1 -D_LIBSSP_PROVIDES_SSP_|' \
		-i ${S}/gcc/Makefile.in || die "Failed to update gcc!"
}

# do various updates to PIE logic
do_gcc_PIE_patches() {
	# corrects startfile/endfile selection and shared/static/pie flag usage
	epatch ${WORKDIR}/piepatch/upstream
	# adds non-default pie support (rs6000)
	epatch ${WORKDIR}/piepatch/nondef
	# adds default pie support (rs6000 too) if DEFAULT_PIE[_SSP] is defined
	epatch ${WORKDIR}/piepatch/def
	# disable relro/now
	#use uclibc && epatch ${FILESDIR}/3.3.3/gcc-3.3.3-norelro.patch

	# we want to be able to control the pie patch logic via something other
	# than ALL_CFLAGS...
	sed -e '/^ALL_CFLAGS/iHARD_CFLAGS = ' \
		-e 's|^ALL_CFLAGS = |ALL_CFLAGS = $(HARD_CFLAGS) |' \
		-i ${S}/gcc/Makefile.in

	release_version="${release_version}, pie-${PIE_VER}"
}

should_we_gcc_config() {
	# we only want to switch compilers if installing to / and we're not
	# building a cross-compiler.
	! [ "${ROOT}" == "/" -a "${CHOST}" == "${CTARGET}" ] && return 1

	# we always want to run gcc-config if we're bootstrapping, otherwise
	# we might get stuck with the c-only stage1 compiler
	use bootstrap && return 0
	use build && return 0

	# if the current config is invalid, we definately want a new one
	[ "$(gcc-config -L | grep -v ^\ )" == "no-config" ] && return 0

	# if the previously selected config has the same major.minor as the
	# version we are installing, then it will probably be uninstalled
	# for being in the same SLOT. we cannot rely on the previous check
	# to handle this, since postinst sometimes happens BEFORE the
	# previous version is removed. :|
	# ...skip this check if the current version is -exactly- the same
	local c_gcc_conf_ver=$(gcc-config -c | awk -F - '{ print $5 }')
	local c_majmin=$(get_version_component_range 1-2 ${c_gcc_conf_ver})
	if [ "${c_gcc_conf_ver}" != "${MY_PV_FULL}" ] ; then
		if [ "${c_majmin}" == "${MY_PV}" ] ;then
			return 0
		else
			# if we're installing a genuinely different compiler version,
			# we should probably tell the user -how- to switch to the new
			# gcc version, since we're not going to do it for him/her.
			einfo "The current gcc config appears valid, so it will not be"
			einfo "automatically switched for you. If you would like to"
			einfo "switch to the newly installed gcc version, do the"
			einfo "following:"
			echo
			einfo "gcc-config ${CTARGET}-${MY_PV_FULL}"
			einfo "source /etc/profile"
			echo
			ebeep
			return 1
		fi
	else
		# since we are re-merging the same gcc version, it's safe to re-run
		# gcc-config and update any new wrappers, etc.
		return 0
	fi

	# default to -not- switching gcc configs. this is to prevent an
	# annoying bug where doing an emerge world -e with multiple slotted
	# compilers will compile some apps with one and others with another.
	return 1
}

do_gcc_config() {
	# the grep -v is in there to filter out informational messages >_<
	local current_gcc_config="$(gcc-config -c | grep -v ^\ )"

	# figure out which specs-specific config is active. yes, this works
	# even if the current config is invalid.
	local current_specs="$(echo ${current_gcc_config} | awk -F - '{ print $6 }')"
	[ "${current_specs}" != "" ] && local use_specs="-${current_specs}"


	if [ -n "${use_specs}" -a ! -e ${ROOT}/etc/env.d/gcc/${CTARGET}-${MY_PV_FULL}${use_specs} ] ; then
		ewarn "The currently selected specs-specific gcc config,"
		ewarn "${current_specs}, doesn't exist anymore. This is usually"
		ewarn "due to enabling/disabling hardened or switching to a version"
		ewarn "of gcc that doesnt create multiple specs files. The default"
		ewarn "config will be used, and the previous preference forgotten."
		ebeep
		epause
	fi


	if [ -e ${ROOT}/etc/env.d/gcc/${CTARGET}-${MY_PV_FULL}${use_specs} ] ; then
		# we dont want to lose the current specs setting!
		gcc-config ${CTARGET}-${MY_PV_FULL}${use_specs}
	else
		# ...unless of course the specs-specific entry doesnt exist :)
		gcc-config --use-portage-chost ${CTARGET}-${MY_PV_FULL}
	fi
}

# This function allows us to gentoo-ize gcc's version number and bugzilla
# URL without needing to use patches.
#
# Travis Tilley <lv@gentoo.org> (02 Sep 2004)
#
gcc_version_patch() {
	[ -z "$1" ] && die "no arguments to gcc_version_patch"

	sed -i -e 's~\(const char version_string\[\] = ".....\).*\(".*\)~\1 @GENTOO@\2~' ${S}/gcc/version.c || die "failed to add @GENTOO@"
	sed -i -e "s:@GENTOO@:$1:g" ${S}/gcc/version.c || die "failed to patch version"
	sed -i -e 's~http:\/\/gcc\.gnu\.org\/bugs\.html~http:\/\/bugs\.gentoo\.org\/~' ${S}/gcc/version.c || die "failed to update bugzilla URL"
}

# The purpose of this DISGUSTING gcc multilib hack is to allow 64bit libs
# to live in lib instead of lib64 where they belong, with 32bit libraries
# in lib32. This hack has been around since the beginning of the amd64 port,
# and we're only now starting to fix everything that's broken. Eventually
# this should go away.
#
# Travis Tilley <lv@gentoo.org> (03 Sep 2004)
#
disgusting_gcc_multilib_HACK() {
	einfo "updating multilib directories to be: $(get_libdir) and $(get_multilibdir)"
	sed -i -e 's~^MULTILIB_OSDIRNAMES.*~MULTILIB_OSDIRNAMES = ../'$(get_libdir)' ../'$(get_multilibdir)'~' ${S}/gcc/config/i386/t-linux64
}

disable_multilib_libjava() {
	# We dont want a multilib libjava, so lets use this hack taken from fedora
	pushd ${S} > /dev/null
	sed -i -e 's/^all: all-redirect/ifeq (\$(MULTISUBDIR),)\nall: all-redirect\nelse\nall:\n\techo Multilib libjava build disabled\nendif/' libjava/Makefile.in
	sed -i -e 's/^install: install-redirect/ifeq (\$(MULTISUBDIR),)\ninstall: install-redirect\nelse\ninstall:\n\techo Multilib libjava install disabled\nendif/' libjava/Makefile.in
	sed -i -e 's/^check: check-redirect/ifeq (\$(MULTISUBDIR),)\ncheck: check-redirect\nelse\ncheck:\n\techo Multilib libjava check disabled\nendif/' libjava/Makefile.in
	sed -i -e 's/^all: all-recursive/ifeq (\$(MULTISUBDIR),)\nall: all-recursive\nelse\nall:\n\techo Multilib libjava build disabled\nendif/' libjava/Makefile.in
	sed -i -e 's/^install: install-recursive/ifeq (\$(MULTISUBDIR),)\ninstall: install-recursive\nelse\ninstall:\n\techo Multilib libjava install disabled\nendif/' libjava/Makefile.in
	sed -i -e 's/^check: check-recursive/ifeq (\$(MULTISUBDIR),)\ncheck: check-recursive\nelse\ncheck:\n\techo Multilib libjava check disabled\nendif/' libjava/Makefile.in
	popd > /dev/null
}

# generic GCC src_unpack, to be called from the ebuild's src_unpack.
# BIG NOTE regarding hardened support: ebuilds with support for hardened are
# expected to export the following variable:
#
#	HARDENED_GCC_WORKS
#			This variable should be set to the archs on which hardened should
#			be allowed. For example: HARDENED_GCC_WORKS="x86 sparc amd64"
#			This allows for additional archs to be supported by hardened when
#			ready.
#
# Travis Tilley <lv@gentoo.org> (03 Sep 2004)
#
gcc-compiler-src_unpack() {
	# fail if using pie patches, building hardened, and glibc doesnt have
	# the necessary support
	[ -n "${PIE_VER}" ] && use hardened && glibc_have_pie

	if ! want_boundschecking ; then
		if use hardened ; then
			einfo "updating configuration to build hardened GCC"
			make_gcc_hard || die "failed to make gcc hard"
		fi
	fi
}
gcc-library-src_unpack() {
	:
}
gcc_src_unpack() {
	local release_version="Gentoo Linux ${PVR}"

	gcc_quick_unpack
	exclude_gcc_patches

	cd ${S:="$(gcc_get_s_dir)"}

	if [ -n "${PATCH_VER}" ] ; then
		epatch ${WORKDIR}/patch
	fi

	if ! want_boundschecking ; then
		if [ "${ARCH}" != "hppa" -a "${ARCH}" != "hppa64" -a -n "${PP_VER}" ] ; then
			do_gcc_SSP_patches
		fi

		if [ -n "${PIE_VER}" ] ; then
			do_gcc_PIE_patches
		fi
	else
		if [ -n "${HTB_VER}" ] ; then
			do_gcc_HTB_boundschecking_patches
		fi
	fi

	${ETYPE}-src_unpack || die "failed to ${ETYPE}-src_unpack"

	if use amd64 && [ -z "${SKIP_MULTILIB_HACK}" ] ; then
		disgusting_gcc_multilib_HACK || die "multilib hack failed"
	fi

	einfo "patching gcc version: ${BRANCH_UPDATE} (${release_version})"
	gcc_version_patch "${BRANCH_UPDATE} (${release_version})"

	# Misdesign in libstdc++ (Redhat)
	cp -a ${S}/libstdc++-v3/config/cpu/i{4,3}86/atomicity.h

	# disable --as-needed from being compiled into gcc specs
	# natively when using >=sys-devel/binutils-2.15.90.0.1 this is
	# done to keep our gcc backwards compatible with binutils. 
	# gcc 3.4.1 cvs has patches that need back porting.. 
	# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=14992 (May 3 2004)
	sed -i -e s/HAVE_LD_AS_NEEDED/USE_LD_AS_NEEDED/g ${S}/gcc/config.in

	# Fixup libtool to correctly generate .la files with portage
	cd ${S}
	elibtoolize --portage --shallow

	gnuconfig_update

	cd ${S}; ./contrib/gcc_update --touch &> /dev/null

	disable_multilib_libjava || die "failed to disable multilib java"
}

gcc-library-configure() {
	# multilib support
	if [ "${GCC_TARGET_NO_MULTILIB}" == "true" ]
	then
		confgcc="${confgcc} --disable-multilib"
	else
		confgcc="${confgcc} --enable-multilib"
	fi
}

gcc-compiler-configure() {
	# multilib support
	if use multilib && (use amd64 || use mips)
	then
		confgcc="${confgcc} --enable-multilib"
	else
		confgcc="${confgcc} --disable-multilib"
	fi

	# GTK+ is preferred over xlib in 3.4.x (xlib is unmaintained
	# right now). Much thanks to <csm@gnu.org> for the heads up.
	# Travis Tilley <lv@gentoo.org>  (11 Jul 2004)
	if ! use build && use gcj && use gtk
	then
		confgcc="${confgcc} --enable-java-awt=gtk"
	fi

	use build || use !gcj && confgcc="${confgcc} --disable-libgcj"

	# Add --with-abi flags to enable respective MIPS ABIs
	case "${CTARGET}" in
		mips*)
		use multilib && confgcc="${confgcc} --with-abi=32"
		use n64 && confgcc="${confgcc} --with-abi=n64"
		use n32 && confgcc="${confgcc} --with-abi=n32"
		;;
	esac

	if ! use build ; then
		GCC_LANG="c"
		use !nocxx && GCC_LANG="${GCC_LANG},c++"

		# fortran support just got sillier! the lang value can be f77 for
		# fortran77, f95 for fortran95, or just plain old fortran for the
		# currently supported standard depending on gcc version.
		if use fortran ; then
			if gcc-lang-supported f95 ; then
				GCC_LANG="${GCC_LANG},f95"
			elif gcc-lang-supported f77 ; then
				GCC_LANG="${GCC_LANG},f77"
			elif gcc-lang-supported fortran ; then
				GCC_LANG="${GCC_LANG},fortran"
			else
				die "GCC doesnt support fortran"
			fi
		fi

		use objc && gcc-lang-supported objc && GCC_LANG="${GCC_LANG},objc"
		use gcj && gcc-lang-supported java && GCC_LANG="${GCC_LANG},java"
		# We do NOT want 'ADA support' in here!
		# use ada  && gcc_lang="${gcc_lang},ada"
	else
		GCC_LANG="c"
	fi

	einfo "configuring for GCC_LANG: ${GCC_LANG}"
}

# Other than the variables described for gcc_setup_variables, the following
# will alter tha behavior of gcc_do_configure:
#
#	CTARGET
#	CBUILD
#			Enable building for a target that differs from CHOST
#
#	GCC_TARGET_NO_MULTILIB
#			Disable multilib. Useful when building single library targets.
#
#	GCC_LANG
#			Enable support for ${GCC_LANG} languages. defaults to just "c"
#
# Travis Tilley <lv@gentoo.org> (04 Sep 2004)
#
gcc_do_configure() {
	local confgcc

	if [ "${GCC_VAR_TYPE}" == "versioned" ] ; then
		confgcc="--enable-version-specific-runtime-libs"
	elif [ "${GCC_VAR_TYPE}" == "non-versioned" ] ; then
		confgcc="--libdir=/${LIBPATH}"
	else
		die "bad GCC_VAR_TYPE"
	fi

	# Set configuration based on path variables
	confgcc="${confgcc} \
		--prefix=${PREFIX} \
		--bindir=${BINPATH} \
		--includedir=${INCLUDEPATH} \
		--datadir=${DATAPATH} \
		--mandir=${DATAPATH}/man \
		--infodir=${DATAPATH}/info \
		--with-gxx-include-dir=${STDCXX_INCDIR}"

	# Incredibly theoretical cross-compiler support
	confgcc="${confgcc} --host=${CHOST}"
	if [ "${CTARGET}" != "${CHOST}" ] ; then
		# Straight from the GCC install doc:
		# "GCC has code to correctly determine the correct value for target 
		# for nearly all native systems. Therefore, we highly recommend you
		# not provide a configure target when configuring a native compiler."
		confgcc="${confgcc} --target=${CTARGET}"
	fi
	if [ "${CBUILD}" != "" ] ; then
		confgcc="${confgcc} --build=${CBUILD}"
	fi

	# ppc altivec support
	confgcc="${confgcc} $(use_enable altivec)"

	# Fix linking problem with c++ apps which where linked
	# against a 3.2.2 libgcc
	[ "${ARCH}" = "hppa" ] && confgcc="${confgcc} --enable-sjlj-exceptions"

	# Native Language Support
	if use nls && use !build ; then
		confgcc="${confgcc} --enable-nls --without-included-gettext"
	else
		confgcc="${confgcc} --disable-nls"
	fi

	# __cxa_atexit is "essential for fully standards-compliant handling of
	# destructors", but apparently requires glibc.
	# --enable-sjlj-exceptions : currently the unwind stuff seems to work 
	# for statically linked apps but not dynamic
	# so use setjmp/longjmp exceptions by default
	# uclibc uses --enable-clocale=uclibc (autodetected)
	# --disable-libunwind-exceptions needed till unwind sections get fixed. see ps.m for details
	if use !uclibc ; then
		confgcc="${confgcc} --enable-__cxa_atexit --enable-clocale=gnu"
	else
		confgcc="${confgcc} --disable-__cxa_atexit --enable-target-optspace \
			--enable-sjlj-exceptions"
	fi

	# reasonably sane globals (hopefully)
	confgcc="${confgcc} \
		--with-system-zlib \
		--disable-checking \
		--disable-werror \
		--disable-libunwind-exceptions"
	if [ "${CHOST}" != "${CTARGET}" ] ; then
		confgcc="${confgcc} --disable-shared --disable-threads"
	else
		confgcc="${confgcc} --enable-shared --enable-threads=posix"
	fi

	# default arch support
	#use sparc && confgcc="${confgcc} --with-cpu=v7"
	#use ppc && confgcc="${confgcc} --with-cpu=common"

	# etype specific configuration
	einfo "running ${ETYPE}-configure"
	${ETYPE}-configure || die

	# if not specified, assume we are building for a target that only
	# requires C support
	GCC_LANG="${GCC_LANG:=c}"
	confgcc="${confgcc} --enable-languages=${GCC_LANG}"

	# Nothing wrong with a good dose of verbosity
	echo
	einfo "PREFIX:          ${PREFIX}"
	einfo "BINPATH:         ${BINPATH}"
	einfo "LIBPATH:         ${LIBPATH}"
	einfo "DATAPATH:        ${DATAPATH}"
	einfo "STDCXX_INCDIR:   ${STDCXX_INCDIR}"
	echo
	einfo "Configuring GCC with: ${confgcc} ${@} ${EXTRA_ECONF}"
	echo

	# Build in a separate build tree
	mkdir -p ${WORKDIR}/build
	pushd ${WORKDIR}/build > /dev/null

	# and now to do the actual configuration
	addwrite "/dev/zero"
	${S}/configure ${confgcc} "${@}" ${EXTRA_ECONF} \
		|| die "failed to run configure"

	# return to whatever directory we were in before
	popd > /dev/null
}

# This function accepts one optional argument, the make target to be used.
# If ommitted, gcc_do_make will try to guess whether it should use all,
# profiledbootstrap, or bootstrap-lean depending on CTARGET and arch. An
# example of how to use this function:
#
#	gcc_do_make all-target-libstdc++-v3
#
# In addition to the target to be used, the following variables alter the
# behavior of this function:
#
#	LDFLAGS
#			Flags to pass to ld
#
#	STAGE1_CFLAGS
#			CFLAGS to use during stage1 of a gcc bootstrap
#
#	BOOT_CFLAGS
#			CFLAGS to use during stages 2+3 of a gcc bootstrap.
#
# Travis Tilley <lv@gentoo.org> (04 Sep 2004)
#
gcc_do_make() {
	# Setup -j in MAKEOPTS
	get_number_of_jobs

	# Only build it static if we are just building the C frontend, else
	# a lot of things break because there are not libstdc++.so ....
	if use static && [ "${GCC_LANG}" = "c" ] ; then
		LDFLAGS="${LDFLAGS:="-static"}"
	fi
	
	STAGE1_CFLAGS="${STAGE1_CFLAGS:="-O"}"

	if [ -z "${CTARGET}" -o "${CTARGET}" == "${CHOST}" ] ; then
		# we only want to use the system's CFLAGS if not building a
		# cross-compiler.
		BOOT_CFLAGS="${BOOT_CFLAGS:="${CFLAGS}"}"
	else
		BOOT_CFLAGS="${BOOT_CFLAGS:="-O2"}"
	fi

	# Fix for libtool-portage.patch
	local OLDS="${S}"
	S="${WORKDIR}/build"

	# Set make target to $1 if passed
	[ "$1" != "" ] && GCC_MAKE_TARGET="$1"
	# default target
	if [ "${CTARGET}" != "${CHOST}" ] ; then
		# 3 stage bootstrapping doesnt quite work when you cant run the
		# resulting binaries natively ^^;
		GCC_MAKE_TARGET="${GCC_MAKE_TARGET:=all}"
	elif use x86 || use amd64 || use ppc64 ; then
		GCC_MAKE_TARGET="${GCC_MAKE_TARGET:=profiledbootstrap}"
	else
		GCC_MAKE_TARGET="${GCC_MAKE_TARGET:=bootstrap-lean}"
	fi

	# the gcc docs state that parallel make isnt supported for the
	# profiledbootstrap target, as collisions in profile collecting may occur.
	if [ "${GCC_MAKE_TARGET}" == "profiledbootstrap" ] ; then
		MAKE_COMMAND="make"
	else
		MAKE_COMMAND="emake"
	fi

	pushd ${WORKDIR}/build
	einfo "Running ${MAKE_COMMAND} LDFLAGS=\"${LDFLAGS}\" STAGE1_CFLAGS=\"${STAGE1_CFLAGS}\" LIBPATH=\"${LIBPATH}\" BOOT_CFLAGS=\"${BOOT_CFLAGS}\" ${GCC_MAKE_TARGET}"

	${MAKE_COMMAND} LDFLAGS="${LDFLAGS}" STAGE1_CFLAGS="${STAGE1_CFLAGS}" \
		LIBPATH="${LIBPATH}" BOOT_CFLAGS="${BOOT_CFLAGS} ${GCC_MAKE_TARGET}" \
		|| die
	popd
}

# This function will add ${PV} to the names of all shared libraries in the
# directory specified to avoid filename collisions between multiple slotted 
# non-versioned gcc targets. If no directory is specified, it is assumed that
# you want -all- shared objects to have ${PV} added. Example
#
#	add_version_to_shared ${D}/usr/$(get_libdir)
#
# Travis Tilley <lv@gentoo.org> (05 Sep 2004)
#
add_version_to_shared() {
	local sharedlib
	if [ "$1" == "" ] ; then
		local sharedlibdir="${D}"
	else
		local sharedlibdir="$1"
	fi

	for sharedlib in `find ${sharedlibdir} -name *.so.*` ; do
		if [ ! -L "${sharedlib}" ] ; then
			einfo "Renaming `basename "${sharedlib}"` to `basename "${sharedlib/.so*/}-${PV}.so.${sharedlib/*.so./}"`"
			mv "${sharedlib}" "${sharedlib/.so*/}-${PV}.so.${sharedlib/*.so./}" \
				|| die
			pushd `dirname "${sharedlib}"` > /dev/null || die
			ln -sf "`basename "${sharedlib/.so*/}-${PV}.so.${sharedlib/*.so./}"`" \
				"`basename "${sharedlib}"`" || die
			popd > /dev/null || die
		fi
	done
}

# This is mostly a stub function to be overwritten in an ebuild
gcc_do_filter_flags() {
	strip-flags

	# In general gcc does not like optimization, and add -O2 where
	# it is safe.  This is especially true for gcc 3.3 + 3.4
	replace-flags -O? -O2

	# ...sure, why not?
	strip-unsupported-flags
}

gcc_src_compile() {
	gcc_do_filter_flags
	einfo "CFLAGS=\"${CFLAGS}\""
	einfo "CXXFLAGS=\"${CXXFLAGS}\""

	# Build in a separate build tree
	mkdir -p ${WORKDIR}/build
	pushd ${WORKDIR}/build > /dev/null

	# Install our pre generated manpages if we do not have perl ...
	if [ ! -x /usr/bin/perl -a "${GCC_MANPAGE_VERSION}" != "none" ] ; then
		unpack gcc-${GCC_MANPAGE_VERSION}-manpages.tar.bz2 || \
			die "Failed to unpack man pages"
	fi

	einfo "Configuring ${PN} ..."
	gcc_do_configure

	touch ${S}/gcc/c-gperf.h

	# Do not make manpages if we do not have perl ...
	if [ ! -x /usr/bin/perl ] ; then
		find ${WORKDIR}/build -name '*.[17]' -exec touch {} \; || :
	fi

	einfo "Compiling ${PN} ..."
	gcc_do_make ${GCC_MAKE_TARGET}

	# Do not create multiple specs files for PIE+SSP if boundschecking is in
	# USE, as we disable PIE+SSP when it is.
	if [ "${ETYPE}" == "gcc-compiler" -a "${SPLIT_SPECS}" == "true" ]  && ! want_boundschecking ; then
		split_out_specs_files || die "failed to split out specs"
	fi

	popd > /dev/null
}

gcc-library-src_install() {
	einfo "Installing ${PN} ..."
	# Do the 'make install' from the build directory
	cd ${WORKDIR}/build
	S="${WORKDIR}/build" \
	make DESTDIR="${D}" \
		prefix=${PREFIX} \
		bindir=${BINPATH} \
		includedir=${LIBPATH}/include \
		datadir=${DATAPATH} \
		mandir=${DATAPATH}/man \
		infodir=${DATAPATH}/info \
		LIBPATH="${LIBPATH}" \
		${GCC_INSTALL_TARGET} || die

	if [ "${GCC_LIB_COMPAT_ONLY}" == "true" ] ; then
		rm -rf ${D}/${INCLUDEPATH}
		rm -rf ${D}/${DATAPATH}
		pushd ${D}/${LIBPATH}/
		rm *.a *.la *.so
		popd
	fi

	if [ -n "${GCC_LIB_USE_SUBDIR}" ] ; then
		mkdir -p ${WORKDIR}/${GCC_LIB_USE_SUBDIR}/
		mv ${D}/${LIBPATH}/* ${WORKDIR}/${GCC_LIB_USE_SUBDIR}/
		mv ${WORKDIR}/${GCC_LIB_USE_SUBDIR}/ ${D}/${LIBPATH}
		
		mkdir -p ${D}/etc/env.d/
		echo "LDPATH=\"${LIBPATH}/${GCC_LIB_USE_SUBDIR}/\"" >> ${D}/etc/env.d/99${PN}
	fi

	if [ "${GCC_VAR_TYPE}" == "non-versioned" ] ; then
		# if we're not using versioned directories, we need to use versioned
		# filenames.
		add_version_to_shared
	fi
}


