# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/toolchain.eclass,v 1.91 2005/01/20 06:50:36 vapier Exp $

HOMEPAGE="http://www.gnu.org/software/gcc/gcc.html"
LICENSE="GPL-2 LGPL-2.1"

#---->> eclass stuff <<----
inherit eutils versionator libtool toolchain-funcs flag-o-matic gnuconfig

ECLASS=toolchain
INHERITED="$INHERITED $ECLASS"
EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_test pkg_preinst src_install pkg_postinst pkg_prerm pkg_postrm
DESCRIPTION="Based on the ${ECLASS} eclass"

FEATURES=${FEATURES/multilib-strict/}

toolchain_pkg_setup() {
	gcc_pkg_setup
}
toolchain_src_unpack() {
	gcc_src_unpack
}
toolchain_src_compile() {
	gcc_src_compile
}
toolchain_src_test() {
	gcc_src_test
}
toolchain_pkg_preinst() {
	${ETYPE}_pkg_preinst
}
toolchain_src_install() {
	${ETYPE}_src_install
}
toolchain_pkg_postinst() {
	${ETYPE}_pkg_postinst
}
toolchain_pkg_prerm() {
	${ETYPE}_pkg_prerm
}
toolchain_pkg_postrm() {
	${ETYPE}_pkg_prerm
}
#----<< eclass stuff >>----


#---->> globals <<----
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} = ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

GCC_RELEASE_VER=$(get_version_component_range 1-3)
GCC_BRANCH_VER=$(get_version_component_range 1-2)
GCC_CONFIG_VER=${GCC_RELEASE_VER}
GCCMAJOR=$(get_version_component_range 1)
GCCMINOR=$(get_version_component_range 2)
GCCMICRO=$(get_version_component_range 3)
[[ -z ${BRANCH_UPDATE} ]] && BRANCH_UPDATE=$(get_version_component_range 4)

# Pre-release support
if [ ${PV} != ${PV/_pre/-} ] ; then
	PRERELEASE=${PV/_pre/-}
fi
# make _alpha and _beta ebuilds automatically use a snapshot
if [ ${PV} != ${PV/_alpha/} ] ; then
	SNAPSHOT=${GCC_BRANCH_VER}-${PV##*_alpha}
elif [ ${PV} != ${PV/_beta/} ] ; then
	SNAPSHOT=${GCC_BRANCH_VER}-${PV##*_beta}
fi

if [[ ${ETYPE} == "gcc-library" ]] ; then
	GCC_VAR_TYPE=${GCC_VAR_TYPE:-non-versioned}
	GCC_LIB_COMPAT_ONLY=${GCC_LIB_COMPAT_ONLY:-true}
	GCC_TARGET_NO_MULTILIB=${GCC_TARGET_NO_MULTILIB:-true}
else
	GCC_VAR_TYPE=${GCC_VAR_TYPE:-versioned}
	GCC_LIB_COMPAT_ONLY="false"
	GCC_TARGET_NO_MULTILIB=${GCC_TARGET_NO_MULTILIB:-false}
fi

PREFIX=${PREFIX:-/usr}

if [[ ${GCC_VAR_TYPE} == "versioned" ]] ; then
	if version_is_at_least 3.4.0 ; then
		# GCC 3.4 no longer uses gcc-lib.
		LIBPATH=${LIBPATH:-${PREFIX}/lib/gcc/${CTARGET}/${GCC_CONFIG_VER}}
	else
		LIBPATH=${LIBPATH:-${PREFIX}/lib/gcc-lib/${CTARGET}/${GCC_CONFIG_VER}}
	fi
	INCLUDEPATH=${INCLUDEPATH:-${LIBPATH}/include}
	BINPATH=${BINPATH:-${PREFIX}/${CTARGET}/gcc-bin/${GCC_CONFIG_VER}}
	DATAPATH=${DATAPATH:-${PREFIX}/share/gcc-data/${CTARGET}/${GCC_CONFIG_VER}}
	# Dont install in /usr/include/g++-v3/, but in gcc internal directory.
	# We will handle /usr/include/g++-v3/ with gcc-config ...
	STDCXX_INCDIR=${STDCXX_INCDIR:-${LIBPATH}/include/g++-v${GCC_BRANCH_VER/\.*/}}
elif [[ ${GCC_VAR_TYPE} == "non-versioned" ]] ; then
	# using non-versioned directories to install gcc, like what is currently
	# done for ppc64 and 3.3.3_pre, is a BAD IDEA. DO NOT do it!! However...
	# setting up variables for non-versioned directories might be useful for
	# specific gcc targets, like libffi. Note that we dont override the value
	# returned by get_libdir here.
	LIBPATH=${LIBPATH:-${PREFIX}/$(get_libdir)}
	INCLUDEPATH=${INCLUDEPATH:-${PREFIX}/include}
	BINPATH=${BINPATH:-${PREFIX}/bin/}
	DATAPATH=${DATAPATH:-${PREFIX}/share/}
	STDCXX_INCDIR=${STDCXX_INCDIR:-${PREFIX}/include/g++-v3/}
fi

XGCC=${WORKDIR}/build/gcc/xgcc
#----<< globals >>----


#---->> SLOT+IUSE logic <<----
if [[ ${ETYPE} == "gcc-library" ]] ; then
	IUSE="nls build uclibc"
	SLOT="${CTARGET}-${SO_VERSION_SLOT:-5}"
else
	IUSE="static nls bootstrap build multislot multilib gcj gtk fortran nocxx objc hardened uclibc n32 n64 ip28"
	[[ -n ${HTB_VER} ]] && IUSE="${IUSE} boundschecking"
	# Support upgrade paths here or people get pissed
	if use multislot ; then
		SLOT="${CTARGET}-${GCC_CONFIG_VER}"
	elif [[ ${CTARGET} != ${CHOST} ]] ; then
		SLOT="${CTARGET}-${GCC_BRANCH_VER}"
	else
		SLOT="${GCC_BRANCH_VER}"
	fi
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
	if [[ -n ${PRERELEASE} ]] ; then
		GCC_S=${WORKDIR}/gcc-${PRERELEASE}
	elif [[ -n ${SNAPSHOT} ]] ; then
		GCC_S=${WORKDIR}/gcc-${SNAPSHOT}
	else
		GCC_S=${WORKDIR}/gcc-${GCC_RELEASE_VER}
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
#			${PN}-${PATCH_GCC_VER:-${GCC_RELEASE_VER}}-patches-${PATCH_VER}.tar.bz2
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
#			default to ${GCC_RELEASE_VER}, but we may not want to pre-generate man pages
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
	GENTOO_TOOLCHAIN_BASE_URI=${GENTOO_TOOLCHAIN_BASE_URI:-${devspace_uri}}

	if [[ -n ${PIE_VER} ]] ; then
		PIE_CORE=${PIE_CORE:-gcc-${GCC_RELEASE_VER}-piepatches-v${PIE_VER}.tar.bz2}
	fi

	GCC_MANPAGE_VERSION=${GCC_MANPAGE_VERSION:-${GCC_RELEASE_VER}}

	# Set where to download gcc itself depending on whether we're using a
	# prerelease, snapshot, or release tarball.
	if [[ -n ${PRERELEASE} ]] ; then
		GCC_SRC_URI="ftp://gcc.gnu.org/pub/gcc/prerelease-${PRERELEASE}/gcc-${PRERELEASE}.tar.bz2"
	elif [[ -n ${SNAPSHOT} ]] ; then
		GCC_SRC_URI="ftp://sources.redhat.com/pub/gcc/snapshots/${SNAPSHOT}/gcc-${SNAPSHOT}.tar.bz2"
	else
		GCC_SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/${P}/gcc-${GCC_RELEASE_VER}.tar.bz2"
		# we want all branch updates to be against the main release
		if [[ -n ${BRANCH_UPDATE} ]] ; then
			GCC_SRC_URI="${GCC_SRC_URI}
				mirror://gentoo/${PN}-${GCC_RELEASE_VER}-branch-update-${BRANCH_UPDATE}.patch.bz2
				${GENTOO_TOOLCHAIN_BASE_URI}/${PN}-${GCC_RELEASE_VER}-branch-update-${BRANCH_UPDATE}.patch.bz2"
		fi
	fi

	# propolice aka stack smashing protection
	if [[ -n ${PP_VER} ]] ; then
		GCC_SRC_URI="${GCC_SRC_URI}
			http://www.research.ibm.com/trl/projects/security/ssp/gcc${PP_VER}/protector-${PP_FVER}.tar.gz
			mirror://gentoo/protector-${PP_FVER}.tar.gz"
	fi

	# PERL cannot be present at bootstrap, and is used to build the man pages.
	# So... lets include some pre-generated ones, shall we?
	if [[ ${GCC_MANPAGE_VERSION} != "none" ]] ; then
		GCC_SRC_URI="${GCC_SRC_URI}
			mirror://gentoo/gcc-${GCC_MANPAGE_VERSION}-manpages.tar.bz2
			${GENTOO_TOOLCHAIN_BASE_URI}/gcc-${GCC_MANPAGE_VERSION}-manpages.tar.bz2"
	fi

	# various gentoo patches
	if [[ -n ${PATCH_VER} ]] ; then
		GCC_SRC_URI="${GCC_SRC_URI}
			mirror://gentoo/${PN}-${PATCH_GCC_VER:-${GCC_RELEASE_VER}}-patches-${PATCH_VER}.tar.bz2
			${GENTOO_TOOLCHAIN_BASE_URI}/${PN}-${PATCH_GCC_VER:-${GCC_RELEASE_VER}}-patches-${PATCH_VER}.tar.bz2"
	fi

	# strawberry pie, Cappuccino and a Gauloises (it's a good thing)
	if [[ -n ${PIE_CORE} ]] ; then
		GCC_SRC_URI="${GCC_SRC_URI}
			mirror://gentoo/${PIE_CORE}
			${GENTOO_TOOLCHAIN_BASE_URI}${PIE_CORE}"
	fi

	# gcc bounds checking patch
	if [[ -n ${HTB_VER} ]] ; then
		GCC_SRC_URI="${GCC_SRC_URI}
			boundschecking? ( http://web.inter.nl.net/hcc/Haj.Ten.Brugge/bounds-checking-${PN}-${HTB_GCC_VER:-${GCC_RELEASE_VER}}-${HTB_VER}.patch.bz2 )"
	fi

	echo "${GCC_SRC_URI}"
}
S=$(gcc_get_s_dir)
SRC_URI=$(get_gcc_src_uri)
#---->> S + SRC_URI essentials >>----


#---->> support checks <<----

# The gentoo piessp patches allow for 3 configurations:
# 1) PIE+SSP by default
# 2) PIE by default
# 3) SSP by default
hardened_gcc_works() {
	if [[ $1 == "pie" ]] ; then
		hardened_gcc_is_stable pie && return 0
		if has ~${ARCH} ${ACCEPT_KEYWORDS} ; then
			hardened_gcc_check_unsupported pie && return 1
			ewarn "Allowing pie-by-default for an unstable arch (${ARCH})"
			return 0
		fi
		return 1
	elif [[ $1 == "ssp" ]] ; then
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
	[[ -e /$(get_libdir)/libssp.so ]] && return 0
	return 1
}

want_libssp() {
	[[ ${GCC_LIBSSP_SUPPORT} == "true" ]] || return 1
	has_libssp || return 1
	[[ -n ${PP_FVER} ]] || return 1
	return 0
}

want_boundschecking() {
	[[ -z ${HTB_VER} ]] && return 1
	use boundschecking && return 0
	return 1
}

want_split_specs() {
	[[ ${SPLIT_SPECS} == "true" ]] && [[ -n ${PIE_CORE} ]] && \
		! want_boundschecking && return 0
	return 1
}

# This function checks whether or not glibc has the support required to build
# Position Independant Executables with gcc.
glibc_have_pie() {
	if [[ ! -f ${ROOT}/usr/$(get_libdir)/Scrt1.o ]] ; then
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
	[[ $(tc-arch) == "ppc64" ]] && [[ -z ${ABI} ]] && libc_prefix="/lib64/"
	libc_prefix=${libc_prefix:-/$(get_libdir)/}

	echo 'int main(){}' > "${T}"/libctest.c
	gcc "${T}"/libctest.c -lc -o libctest
	local libc_file=$(readelf -d libctest | grep 'NEEDED.*\[libc\.so[0-9\.]*\]' | awk '{print $NF}')
	libc_file=${libc_file:1:${#libc_file}-2}

	local my_libc=${ROOT}/${libc_prefix}/${libc_file}

	# Check for the libc to have the __guard symbols
	if  [[ -n $(readelf -s "${my_libc}" 2>/dev/null | \
	            grep 'OBJECT.*GLOBAL.*__guard') ]] && \
	    [[ -n $(readelf -s "${my_libc}" 2>/dev/null | \
	            grep 'FUNC.*GLOBAL.*__stack_smash_handler') ]]
	then
		return 0
	elif [[ ${CTARGET} != ${CHOST} ]] ; then
		die "'${my_libc}' was detected w/out ssp, that sucks (a lot)"
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
	local gcc_envd_base="/etc/env.d/gcc/${CTARGET}-${GCC_CONFIG_VER}"

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

	echo "PATH=\"${BINPATH}\"" > ${gcc_envd_file}
	echo "ROOTPATH=\"${BINPATH}\"" >> ${gcc_envd_file}

	LDPATH="${LIBPATH}"

	if has_multilib_profile; then
		local abi=
		for abi in ${MULTILIB_ABIS}; do
			local MULTIDIR=$(${XGCC} $(get_abi_CFLAGS ${abi}) --print-multi-directory)
			[ "${MULTIDIR}" != "." -a -d "${LIBPATH}/${MULTIDIR}" ] && LDPATH="${LDPATH}:${LIBPATH}/${MULTIDIR}"
		done
	else
		for path in 32 64 o32; do
			[ -d "${LIBPATH}/${path}" ] && LDPATH="${LDPATH}:${LIBPATH}/${path}"
		done
	fi

	local mbits=
	CC=${XGCC} has_m32 && mbits="${mbits} 32"
	CC=${XGCC} has_m64 && mbits="${mbits} 64"
	echo "GCCBITS=\"${mbits:1}\"" >> ${gcc_envd_file}

	echo "LDPATH=\"${LDPATH}\"" >> ${gcc_envd_file}
	echo "MANPATH=\"${DATAPATH}/man\"" >> ${gcc_envd_file}
	echo "INFOPATH=\"${DATAPATH}/info\"" >> ${gcc_envd_file}
	echo "STDCXX_INCDIR=\"${STDCXX_INCDIR##*/}\"" >> ${gcc_envd_file}

	# Only export CTARGET if cross-compiling (for now ...)
	[[ ${CTARGET} != ${CHOST} ]] \
		&& echo "CTARGET=${CTARGET}" >> ${gcc_envd_file}

	# Set which specs file to use
	[ -n "${gcc_specs_file}" ] && echo "GCC_SPECS=\"${gcc_specs_file}\"" >> ${gcc_envd_file}
}

#----<< specs + env.d logic >>----

#---->> pkg_* <<----
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

gcc-compiler_pkg_preinst() {
	:
	# wtf is this for !?
	#export LD_LIBRARY_PATH=${LIBPATH}:${LD_LIBRARY_PATH}
	#"${ROOT}"/sbin/ldconfig
}

gcc-compiler_pkg_postinst() {
	export LD_LIBRARY_PATH=${LIBPATH}:${LD_LIBRARY_PATH}
	do_gcc_config

	echo
	einfo "If you have issues with packages unable to locate libstdc++.la,"
	einfo "then try running 'fix_libtool_files.sh' on the old gcc versions."
	echo

	# Now we have to figure out if all the little libtool linker scripts
	# need updating to our new gcc version.  Basically we only want to 
	# do this if the old gcc version is being cleaned out due to this 
	# new version.

	# USE=multislot ... no compilers get cleaned out during an upgrade
	use multislot && return 0

	# libtool files aren't affected by cross compilers
	[[ ${CTARGET} != ${CHOST} ]] && return 0

	# Now check to see if we already have a version installed in this 
	# SLOT ... if we do, then bail if it's a minor upgrade (like we 
	# go from 3.3.4 to 3.3.4-r1 vs 3.3.4 to 3.3.5)
	local old_gcc_release=$(portageq match =sys-devel/gcc-${GCC_RELEASE_VER}*)
	[[ -n ${old_gcc_release} ]] && return 0
	local old_gcc_branch=$(portageq match =sys-devel/gcc-${GCC_BRANCH_VER}*)
	[[ -z ${old_gcc_branch} ]] && return 0
	local old_gcc_ver=${old_gcc_branch%%-*}

	/sbin/fix_libtool_files.sh ${old_gcc_ver}
}

gcc-compiler_pkg_prerm() {
	# TODO: flesh this out when I care
	return 0

	# When unmerging a compiler, we need to make sure that 
	# we don't leave any of configuration stuff stranded.  
	# After all, we can't assume the user won't shoot themselves 
	# in the foot.

	# First handle gcc-config matters
	#if [[ $(gcc-config -c 2>&1) == "${CTARGET}-${PV}" ]] ; then
	#	gcc-config 
	#fi

	# libtool files aren't affected by cross compilers
	#[[ ${CTARGET} != ${CHOST} ]] && return 0

	#/sbin/fix_libtool_files.sh ${PV}
}

gcc-compiler_pkg_postrm() {
	:
}

#---->> pkg_* <<----

#---->> src_* <<----

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
gcc-compiler_src_unpack() {
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
gcc-library_src_unpack() {
	:
}
gcc_src_unpack() {
	local release_version="Gentoo Linux ${PVR}"

	gcc_quick_unpack
	exclude_gcc_patches

	cd ${S:=$(gcc_get_s_dir)}

	[[ -n ${PATCH_VER} ]] && epatch ${WORKDIR}/patch

	if ! want_boundschecking ; then
		[[ -n ${PP_VER} ]] && do_gcc_SSP_patches
		[[ -n ${PIE_VER} ]] && do_gcc_PIE_patches
	else
		[[ -n ${HTB_VER} ]] && do_gcc_HTB_boundschecking_patches
	fi

	${ETYPE}_src_unpack || die "failed to ${ETYPE}_src_unpack"

	if [[ $(tc-arch) == "amd64" ]] \
	   && [[ -z ${SKIP_MULTILIB_HACK} ]] && use_multilib
	then
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
	elibtoolize --portage --shallow --no-uclibc

	gnuconfig_update

	cd ${S}; ./contrib/gcc_update --touch &> /dev/null

	disable_multilib_libjava || die "failed to disable multilib java"
}

gcc-library-configure() {
	# multilib support
	[[ ${GCC_TARGET_NO_MULTILIB} == "true" ]] \
		&& confgcc="${confgcc} --disable-multilib" \
		|| confgcc="${confgcc} --enable-multilib"
}

gcc-compiler-configure() {
	# multilib support
	if use_multilib; then
		confgcc="${confgcc} --enable-multilib"
	else
		confgcc="${confgcc} --disable-multilib"
	fi

	# GTK+ is preferred over xlib in 3.4.x (xlib is unmaintained
	# right now). Much thanks to <csm@gnu.org> for the heads up.
	# Travis Tilley <lv@gentoo.org>  (11 Jul 2004)
	if ! use build && use gcj && use gtk ; then
		confgcc="${confgcc} --enable-java-awt=gtk"
	fi
	use build || ! use gcj && confgcc="${confgcc} --disable-libgcj"

	# Add --with-abi flags to enable respective MIPS ABIs
	case $(tc-arch) in
		mips)
		use_multilib && confgcc="${confgcc} --with-abi=32"
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

	if [[ ${GCC_VAR_TYPE} == "versioned" ]] ; then
		confgcc="--enable-version-specific-runtime-libs"
	elif [[ ${GCC_VAR_TYPE} == "non-versioned" ]] ; then
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

	# All our cross-compile logic goes here !  woo !
	confgcc="${confgcc} --host=${CHOST}"
	if [[ ${CTARGET} != ${CHOST} ]] ; then
		# Straight from the GCC install doc:
		# "GCC has code to correctly determine the correct value for target 
		# for nearly all native systems. Therefore, we highly recommend you
		# not provide a configure target when configuring a native compiler."
		confgcc="${confgcc} --target=${CTARGET}"
	fi
	[[ -n ${CBUILD} ]] && confgcc="${confgcc} --build=${CBUILD}"

	# ppc altivec support
	confgcc="${confgcc} $(use_enable altivec)"

	# Fix linking problem with c++ apps which where linked
	# against a 3.2.2 libgcc
	[[ $(tc-arch) == "hppa" ]] && confgcc="${confgcc} --enable-sjlj-exceptions"

	# Native Language Support
	if use nls && ! use build ; then
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
	if ! use uclibc ; then
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
	# When building a stage1 cross-compiler (just C compiler), we 
	# have to disable shared gcc libs and threads or gcc goes boom
	if use nocxx && [[ ${CHOST} != ${CTARGET} ]] ; then
		confgcc="${confgcc} --disable-shared --disable-threads --without-headers"
	else
		confgcc="${confgcc} --enable-shared --enable-threads=posix"
	fi

	# etype specific configuration
	einfo "running ${ETYPE}-configure"
	${ETYPE}-configure || die

	# if not specified, assume we are building for a target that only 
	# requires C support
	GCC_LANG=${GCC_LANG:-c}
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
	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	# and now to do the actual configuration
	addwrite /dev/zero
	"${S}"/configure ${confgcc} $@ ${EXTRA_ECONF} \
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
	if use static && [[ ${GCC_LANG} == "c" ]] ; then
		append-ldflags -static
	fi

	STAGE1_CFLAGS=${STAGE1_CFLAGS:--O}

	if [[ ${CTARGET} == ${CHOST} ]] ; then
		# we only want to use the system's CFLAGS if not building a
		# cross-compiler.
		BOOT_CFLAGS=${BOOT_CFLAGS:-${CFLAGS}}
	else
		BOOT_CFLAGS=${BOOT_CFLAGS:--O2}
	fi

	# Fix for libtool-portage.patch
	local OLDS=${S}
	S=${WORKDIR}/build

	# Set make target to $1 if passed
	[[ -n $1 ]] && GCC_MAKE_TARGET="$1"
	# default target
	if [[ ${CTARGET} != ${CHOST} ]] ; then
		# 3 stage bootstrapping doesnt quite work when you cant run the
		# resulting binaries natively ^^;
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET:-all}
	elif { use x86 || use amd64 || use ppc64 ;} && [[ ${GCC_BRANCH_VER} != "3.3" ]] ; then
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET:-profiledbootstrap}
	else
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET:-bootstrap-lean}
	fi

	# the gcc docs state that parallel make isnt supported for the
	# profiledbootstrap target, as collisions in profile collecting may occur.
	if [[ ${GCC_MAKE_TARGET} == "profiledbootstrap" ]] ; then
		MAKE_COMMAND="make"
	else
		MAKE_COMMAND="emake"
	fi

	pushd ${WORKDIR}/build
	einfo "Running ${MAKE_COMMAND} LDFLAGS=\"${LDFLAGS}\" STAGE1_CFLAGS=\"${STAGE1_CFLAGS}\" LIBPATH=\"${LIBPATH}\" BOOT_CFLAGS=\"${BOOT_CFLAGS}\" ${GCC_MAKE_TARGET}"

	${MAKE_COMMAND} \
		LDFLAGS="${LDFLAGS}" \
		STAGE1_CFLAGS="${STAGE1_CFLAGS}" \
		LIBPATH="${LIBPATH}" \
		BOOT_CFLAGS="${BOOT_CFLAGS}" \
		${GCC_MAKE_TARGET} \
		|| die "${MAKE_COMMAND} failed with ${GCC_MAKE_TARGET}"
	popd
}

# This function will add ${GCC_CONFIG_VER} to the names of all shared libraries in the
# directory specified to avoid filename collisions between multiple slotted 
# non-versioned gcc targets. If no directory is specified, it is assumed that
# you want -all- shared objects to have ${GCC_CONFIG_VER} added. Example
#
#	add_version_to_shared ${D}/usr/$(get_libdir)
#
# Travis Tilley <lv@gentoo.org> (05 Sep 2004)
#
add_version_to_shared() {
	local sharedlib sharedlibdir
	[[ -z $1 ]] \
		&& sharedlibdir=${D} \
		|| sharedlibdir=$1

	for sharedlib in $(find ${sharedlibdir} -name *.so.*) ; do
		if [[ ! -L ${sharedlib} ]] ; then
			einfo "Renaming `basename "${sharedlib}"` to `basename "${sharedlib/.so*/}-${GCC_CONFIG_VER}.so.${sharedlib/*.so./}"`"
			mv "${sharedlib}" "${sharedlib/.so*/}-${GCC_CONFIG_VER}.so.${sharedlib/*.so./}" \
				|| die
			pushd `dirname "${sharedlib}"` > /dev/null || die
			ln -sf "`basename "${sharedlib/.so*/}-${GCC_CONFIG_VER}.so.${sharedlib/*.so./}"`" \
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

	# dont want to funk ourselves
	filter-flags '-mabi*' -m32 -m64

	# filter *common* flags that will make other gcc's angry
	if [[ ${GCC_BRANCH_VER} == "3.3" ]] ; then
		case $(tc-arch) in
			x86) filter-flags '-mtune=*';;
		esac
	fi

	export GCJFLAGS=${GCJFLAGS:-CFLAGS}
}

gcc_src_compile() {
	if [[ $(tc-arch) == "amd64" ]] && [[ ${LD_PRELOAD} == "/lib/libsandbox.so" ]] && use_multilib; then
		eerror "Sandbox in your installed portage does not support compilation."
		eerror "of a multilib gcc.  Please set FEATURES=-sandbox and try again."
		eerror "After you have a multilib gcc, re-emerge portage to have a working sandbox."
		die "No 32bit sandbox.  Retry with FEATURES=-sandbox."
	fi

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
	[[ ! -x /usr/bin/perl ]] \
		&& find "${WORKDIR}"/build -name '*.[17]' | xargs touch

	einfo "Compiling ${PN} ..."
	gcc_do_make ${GCC_MAKE_TARGET}

	# Do not create multiple specs files for PIE+SSP if boundschecking is in
	# USE, as we disable PIE+SSP when it is.
	if [[ ${ETYPE} == "gcc-compiler" ]] && [[ ${SPLIT_SPECS} == "true" ]] && ! want_boundschecking ; then
		split_out_specs_files || die "failed to split out specs"
	fi

	popd > /dev/null
}

gcc_src_test() {
	cd ${WORKDIR}/build
	make check || die "check failed :("
}

gcc-library_src_install() {
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

	if [[ ${GCC_LIB_COMPAT_ONLY} == "true" ]] ; then
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
		
		dodir /etc/env.d
		echo "LDPATH=\"${LIBPATH}/${GCC_LIB_USE_SUBDIR}/\"" >> ${D}/etc/env.d/99${PN}
	fi

	if [[ ${GCC_VAR_TYPE} == "non-versioned" ]] ; then
		# if we're not using versioned directories, we need to use versioned
		# filenames.
		add_version_to_shared
	fi
}


gcc-compiler_src_install() {
	local x=

	# Do allow symlinks in ${PREFIX}/lib/gcc-lib/${CHOST}/${GCC_CONFIG_VER}/include as
	# this can break the build.
	for x in ${WORKDIR}/build/gcc/include/* ; do
		[[ -L ${x} ]] && rm -f "${x}"
	done
	# Remove generated headers, as they can cause things to break
	# (ncurses, openssl, etc).
	for x in $(find ${WORKDIR}/build/gcc/include/ -name '*.h') ; do
		grep -q 'It has been auto-edited by fixincludes from' "${x}" \
			&& rm -f "${x}"
	done

	einfo "Installing GCC..."
	# Do the 'make install' from the build directory
	cd ${WORKDIR}/build
	S=${WORKDIR}/build \
	make DESTDIR="${D}" install || die

	if [[ ${CHOST} == ${CTARGET} ]] ; then
		[[ -r ${D}${BINPATH}/gcc ]] || die "gcc not found in ${D}"
	fi

	dodir /lib /usr/bin
	dodir /etc/env.d/gcc
	create_gcc_env_entry

	if want_split_specs ; then
		if use hardened ; then
			create_gcc_env_entry vanilla
		fi
		use !hardened && hardened_gcc_works && create_gcc_env_entry hardened
		if hardened_gcc_works || hardened_gcc_works pie ; then
			create_gcc_env_entry hardenednossp
		fi
		if hardened_gcc_works || hardened_gcc_works ssp ; then
			create_gcc_env_entry hardenednopie
		fi

		cp ${WORKDIR}/build/*.specs ${D}/${LIBPATH}
	fi

	# Move the libraries to the proper location
	gcc_movelibs &> /dev/null

	# Make sure we dont have stuff lying around that
	# can nuke multiple versions of gcc
	if ! use build ; then
		cd ${D}${LIBPATH}

		# Move Java headers to compiler-specific dir
		for x in ${D}${PREFIX}/include/gc*.h ${D}${PREFIX}/include/j*.h
		do
			[[ -f ${x} ]] && mv -f "${x}" ${D}${LIBPATH}/include/
		done
		for x in gcj gnu java javax org ; do
			if [[ -d ${D}${PREFIX}/include/${x} ]] ; then
				dodir /${LIBPATH}/include/${x}
				mv -f ${D}${PREFIX}/include/${x}/* ${D}${LIBPATH}/include/${x}/
				rm -rf ${D}${PREFIX}/include/${x}
			fi
		done

		if [[ -d ${D}${PREFIX}/lib/security ]] ; then
			dodir /${LIBPATH}/security
			mv -f ${D}${PREFIX}/lib/security/* ${D}${LIBPATH}/security
			rm -rf ${D}${PREFIX}/lib/security
		fi

		# Move libgcj.spec to compiler-specific directories
		[[ -f ${D}${PREFIX}/lib/libgcj.spec ]] && \
			mv -f ${D}${PREFIX}/lib/libgcj.spec ${D}${LIBPATH}/libgcj.spec

		# Rename jar because it could clash with Kaffe's jar if this gcc is
		# primary compiler (aka don't have the -<version> extension)
		cd ${D}${PREFIX}/${CTARGET}/gcc-bin/${GCC_CONFIG_VER}
		[[ -f jar ]] && mv -f jar gcj-jar

		# Move <cxxabi.h> to compiler-specific directories
		[ -f "${D}${STDCXX_INCDIR}/cxxabi.h" ] && \
			mv -f ${D}${STDCXX_INCDIR}/cxxabi.h ${D}${LIBPATH}/include/

		# These should be symlinks
		cd "${D}"${BINPATH}
		for x in gcc g++ c++ g77 gcj ; do
			# For some reason, g77 gets made instead of ${CTARGET}-g77... this makes it safe
			[[ -f ${x} ]] && mv ${x} ${CTARGET}-${x}

			if [[ ${CHOST} == ${CTARGET} ]] && [[ -f ${CTARGET}-${x} ]] ; then
				[[ ! -f ${x} ]] && mv ${CTARGET}-${x} ${x}
				ln -sf ${x} ${CTARGET}-${x}
			fi

			if [[ -f ${CTARGET}-${x}-${GCC_CONFIG_VER} ]] ; then
				rm -f ${CTARGET}-${x}-${GCC_CONFIG_VER}
				ln -sf ${CTARGET}-${x} ${CTARGET}-${x}-${GCC_CONFIG_VER}
			fi
		done

		# I do not know if this will break gcj stuff, so I'll only do it for
		#   objc for now; basically "ffi.h" is the correct file to include,
		#   but it gets installed in .../GCCVER/include and yet it does 
		#   "#include <ffitarget.h>" which (correctly, as it's an "extra" file)
		#   is installed in .../GCCVER/include/libffi; the following fixes
		#   ffi.'s include of ffitarget.h - Armando Di Cianno <fafhrd@gentoo.org>
		if use objc && ! use gcj ; then
			#dosed "s:<ffitarget.h>:<libffi/ffitarget.h>:g" /${LIBPATH}/include/ffi.h
			mv ${D}/${LIBPATH}/include/libffi/* ${D}/${LIBPATH}/include
			rm -Rf ${D}/${LIBPATH}/include/libffi
		fi
	fi

	cd ${S}
	if ! use build && [[ ${CHOST} == ${CTARGET} ]] ; then
		prepman ${DATAPATH}
		prepinfo ${DATAPATH}
	else
		rm -r "${D}"/usr/share/{man,info}
		rm -r "${D}"${DATAPATH}/{man,info}
	fi

	# Rather install the script, else portage with changing $FILESDIR
	# between binary and source package borks things ....
	if [[ ${CHOST} == ${CTARGET} ]] ; then
		insinto /lib/rcscripts/awk
		doins ${FILESDIR}/awk/fixlafiles.awk
		exeinto /sbin
		doexe ${FILESDIR}/fix_libtool_files.sh
	fi

	chown -R root:root "${D}"${LIBPATH}
}

# Move around the libs to the right location.
gcc_movelibs() {
	# This one comes with binutils
	rm -f ${D}${PREFIX}/lib/libiberty.a
	rm -f ${D}${PREFIX}/lib/*/libiberty.a
	rm -f ${D}${LIBPATH}/libiberty.a
	rm -f ${D}${LIBPATH}/*/libiberty.a

	#local FROMDIR=${D}/${LIBPATH}/../${GCC_RELEASE_VER}
	#[ -d "${FROMDIR}" ] && mv ${FROMDIR}/* ${LIBPATH}

	#FROMDIR=${D}/${PREFIX}/libexec/gcc/${CTARGET}/${GCC_RELEASE_VER}
	#[ -d "${FROMDIR}" ] && mv ${FROMDIR}/* ${FROMDIR}/../

	if [ -n "${MULTILIB_ABIS}" ]; then
		for abi in ${MULTILIB_ABIS}; do
			local OS_MULTIDIR=$(${XGCC} $(get_abi_CFLAGS ${abi}) --print-multi-os-directory)
			local MULTIDIR=$(${XGCC} $(get_abi_CFLAGS ${abi}) --print-multi-directory)
			local TODIR=${D}/${LIBPATH}/${MULTIDIR}
			local FROMDIR=

			[ -d "${TODIR}" ] || mkdir -p ${TODIR}

			FROMDIR=${D}/${LIBPATH}/${OS_MULTIDIR}
			if [ "${FROMDIR}" != "${TODIR}" -a -d "${FROMDIR}" ]; then
				mv ${FROMDIR}/{*.a,*.so*,*.la} ${TODIR}
				rmdir ${FROMDIR}
			fi

			FROMDIR=${D}/${LIBPATH}/../${MULTIDIR}
			if [ -d "${FROMDIR}" ]; then
				mv ${FROMDIR}/{*.a,*.so*,*.la} ${TODIR}
				rmdir ${FROMDIR}
			fi

			FROMDIR=${D}/${PREFIX}/lib/${OS_MULTIDIR}
			if [ -d "${FROMDIR}" ]; then
				mv ${FROMDIR}/{*.a,*.so*,*.la} ${TODIR}
				rmdir ${FROMDIR}
			fi

			FROMDIR=${D}/${PREFIX}/lib/${MULTIDIR}
			if [ -d "${FROMDIR}" ]; then
				# The only thing that ends up here is libiberty.a (which is deleted)
				# Lucky for us nothing mistakenly gets placed here that we need...
				# otherwise we'd have a potential conflict when OS_MULTIDIR=../lib and
				# MULTIDIR=. for different ABI.  If this happens, the fix is to patch
				# the gcc Makefiles to behave with LIBDIR properly.
				#mv ${FROMDIR}/{*.a,*.so*,*.la} ${TODIR}
				rmdir ${FROMDIR}
			fi
		done
	else
		# No multilib or older multilib...

		# we dont want these in freaky non-versioned paths that dont ever get used
		fix_freaky_non_versioned_library_paths_that_dont_ever_get_used 32
		fix_freaky_non_versioned_library_paths_that_dont_ever_get_used 64

		# Stupid REALLY old profiles are so freakin' dumb!  I can't wait till we deprecate 2004.3!
		fix_freaky_non_versioned_library_paths_that_dont_ever_get_used lib

		# and mips is just freaky in general ;p
		fix_freaky_non_versioned_library_paths_that_dont_ever_get_used o32
		# and finally, the non-bitdepth-or-ABI-specific freaky path

		if [ -d ${D}/${PREFIX}/lib32 -a -d ${D}/${LIBPATH}/32 ] ; then
			mv ${D}/${PREFIX}/lib32/* ${D}/${LIBPATH}/32/
		elif [ -d ${D}/${PREFIX}/lib32 -a ! -d ${D}/${LIBPATH}/32 ] ; then
			mv ${D}/${PREFIX}/lib32/* ${D}/${LIBPATH}/
		fi

		if [ -d ${D}/${PREFIX}/lib64 -a -d ${D}/${LIBPATH}/64 ] ; then
			mv ${D}/${PREFIX}/lib64/* ${D}/${LIBPATH}/64/
		elif [ -d ${D}/${PREFIX}/lib64 -a ! -d ${D}/${LIBPATH}/64 ] ; then
			mv ${D}/${PREFIX}/lib64/* ${D}/${LIBPATH}/
		fi

		# and sometimes crap ends up here too :|
		mv ${D}/${PREFIX}/lib/{*.a,*.so*,*.la} ${D}/${LIBPATH}/
		mv ${D}/${LIBPATH}/../{*.a,*.so*,*.la} ${D}/${LIBPATH}/

		rm -rf ${D}/${PREFIX}/lib64
		rm -rf ${D}/${PREFIX}/lib32
		rm -rf ${D}/${PREFIX}/lib/o32
		rm -rf ${D}/${PREFIX}/lib/32
		rm -rf ${D}/${PREFIX}/lib/64
		rm -rf ${D}/${LIBPATH}/../o32
		rm -rf ${D}/${LIBPATH}/../32
		rm -rf ${D}/${LIBPATH}/../64
	fi

	# make sure the libtool archives have libdir set to where they actually
	# -are-, and not where they -used- to be.
	fix_libtool_libdir_paths "$(find ${D}/${LIBPATH} -name *.la)"
}

#----<< src_* >>----

#---->> unorganised crap in need of refactoring follows

# This is only used by the backwards-compatible stuff above...
fix_freaky_non_versioned_library_paths_that_dont_ever_get_used() {
	# first the multilib case
	if [ -d ${D}/${LIBPATH}/../$1 -a -d ${D}/${LIBPATH}/$1 ] ; then
		mv ${D}/${LIBPATH}/../$1/* ${D}/${LIBPATH}/$1/
		rm -rf ${D}/${LIBPATH}/../$1
	fi
	if [ -d ${D}/${LIBPATH}/../lib$1 -a -d ${D}/${LIBPATH}/$1 ] ; then
		mv ${D}/${LIBPATH}/../lib$1/* ${D}/${LIBPATH}/$1/
		rm -rf ${D}/${LIBPATH}/../lib$1
	fi
	# and now to fix up the non-multilib case
	if [ -d ${D}/${LIBPATH}/../$1 -a ! -d ${D}/${LIBPATH}/$1 ] ; then
		mv ${D}/${LIBPATH}/../$1/* ${D}/${LIBPATH}/
		rm -rf ${D}/${LIBPATH}/../$1
	fi
	if [ -d ${D}/${LIBPATH}/../lib$1 -a ! -d ${D}/${LIBPATH}/$1 ] ; then
		mv ${D}/${LIBPATH}/../lib$1/* ${D}/${LIBPATH}/
		rm -rf ${D}/${LIBPATH}/../lib$1
	fi
}

gcc_do_filter_flags() {
	strip-flags

	# In general gcc does not like optimization, and add -O2 where
	# it is safe.  This is especially true for gcc 3.3 + 3.4
	replace-flags -O? -O2

	# -mcpu is deprecated on these archs, and possibly others
	if use amd64 || use x86 ; then
		setting="`get-flag mcpu`"
		[ ! -z "${setting}" ] && \
			replace-flags -mcpu="${setting}" -mtune="${setting}" && \
			ewarn "-mcpu is deprecated on your arch\a\a\a" && \
			epause 5
	fi

	strip-unsupported-flags

	# If we use multilib on mips, we shouldn't pass -mabi flag - it breaks
	# build of non-default-abi libraries.
	use mips && use_multilib && filter-flags "-mabi*"

	# Compile problems with these (bug #6641 among others)...
	#filter-flags "-fno-exceptions -fomit-frame-pointer -fforce-addr"

	export GCJFLAGS="${CFLAGS}"
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
		unpack gcc-${GCC_RELEASE_VER}.tar.bz2
		# We want branch updates to be against a release tarball
		if [ -n "${BRANCH_UPDATE}" ] ; then
			pushd ${S:-"$(gcc_get_s_dir)"} > /dev/null
			epatch ${DISTDIR}/gcc-${GCC_RELEASE_VER}-branch-update-${BRANCH_UPDATE}.patch.bz2
			popd > /dev/null
		fi
	fi

	if [ -n "${PATCH_VER}" ]
	then
		unpack ${PN}-${PATCH_GCC_VER:-${GCC_RELEASE_VER}}-patches-${PATCH_VER}.tar.bz2
	fi

	if [ -n "${PP_VER}" ]
	then
		# The gcc 3.4 propolice versions are meant to be unpacked to ${S}
		pushd ${S:-"$(gcc_get_s_dir)"} > /dev/null
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
		unpack "bounds-checking-${PN}-${HTB_GCC_VER:-${GCC_RELEASE_VER}}-${HTB_VER}.patch.bz2"
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
	epatch "${WORKDIR}/bounds-checking-${PN}-${HTB_GCC_VER:-${GCC_RELEASE_VER}}-${HTB_VER}.patch"
	release_version="${release_version}, HTB-${HTB_VER}"
}

# patch in ProPolice Stack Smashing protection
do_gcc_SSP_patches() {
	# PARISC has no love ... it's our stack :(
	[[ $(tc-arch) == "hppa" ]] && return 0

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
	# we only want to switch compilers if installing to /
	[[ ${ROOT} == "/" ]] || return 1

	# we always want to run gcc-config if we're bootstrapping, otherwise
	# we might get stuck with the c-only stage1 compiler
	use bootstrap && return 0
	use build && return 0

	# If we're cross-compiling, only run gcc-config the first time
	if [[ ${CHOST} != ${CTARGET} ]] ; then
		return $([[ ! -e ${ROOT}/etc/env.d/gcc/config-${CTARGET} ]])
	fi

	# multislot pretty much means we want to save all our compilers
	# ... lets not screw with gcc in that case
	use multislot && return 1

	# if the current config is invalid, we definitely want a new one
	env -i gcc-config -c >&/dev/null || return 0

	# if the previously selected config has the same major.minor (branch) as 
	# the version we are installing, then it will probably be uninstalled
	# for being in the same SLOT, make sure we run gcc-config.
	local curr_config_ver=$(env -i gcc-config -c | awk -F - '{ print $5 }')
	local curr_branch_ver=$(get_version_component_range 1-2 ${curr_config_ver})
	if [[ ${curr_branch_ver} == ${GCC_BRANCH_VER} ]] ; then
		return 0
	else
		# if we're installing a genuinely different compiler version,
		# we should probably tell the user -how- to switch to the new
		# gcc version, since we're not going to do it for him/her.  
		# We don't want to switch from say gcc-3.3 to gcc-3.4 right in 
		# the middle of an emerge operation (like an 'emerge -e world' 
		# which could install multiple gcc versions).
		einfo "The current gcc config appears valid, so it will not be"
		einfo "automatically switched for you.  If you would like to"
		einfo "switch to the newly installed gcc version, do the"
		einfo "following:"
		echo
		einfo "gcc-config ${CTARGET}-${GCC_CONFIG_VER}"
		einfo "source /etc/profile"
		echo
		ebeep
		return 1
	fi
}

do_gcc_config() {
	should_we_gcc_config || return 0

	# the grep -v is in there to filter out informational messages >_<
	local current_gcc_config=$(env -i gcc-config -c ${CTARGET} | grep -v ^\ )

	# figure out which specs-specific config is active. yes, this works
	# even if the current config is invalid.
	local current_specs=$(echo ${current_gcc_config} | awk -F - '{ print $6 }')
	local use_specs=""
	[[ -n ${current_specs} ]] && use_specs=-${current_specs}

	if [[ -n ${use_specs} ]] && \
	   [[ ! -e ${ROOT}/etc/env.d/gcc/${CTARGET}-${GCC_CONFIG_VER}${use_specs} ]]
	then
		ewarn "The currently selected specs-specific gcc config,"
		ewarn "${current_specs}, doesn't exist anymore. This is usually"
		ewarn "due to enabling/disabling hardened or switching to a version"
		ewarn "of gcc that doesnt create multiple specs files. The default"
		ewarn "config will be used, and the previous preference forgotten."
		ebeep
		epause
		use_specs=""
	fi

	gcc-config ${CTARGET}-${GCC_CONFIG_VER}${use_specs}
}

# This function allows us to gentoo-ize gcc's version number and bugzilla
# URL without needing to use patches.
#
# Travis Tilley <lv@gentoo.org> (02 Sep 2004)
#
gcc_version_patch() {
	[[ -z $1 ]] && die "no arguments to gcc_version_patch"

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
	local libdirs
	has_multilib_profile \
		&& libdirs="../$(get_abi_LIBDIR amd64) ../$(get_abi_LIBDIR x86)" \
		|| libdirs="../$(get_libdir) ../$(get_multilibdir)"
	einfo "updating multilib directories to be: ${libdirs}"
	sed -i -e "s:^MULTILIB_OSDIRNAMES.*:MULTILIB_OSDIRNAMES = ${libdirs}:" ${S}/gcc/config/i386/t-linux64
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

fix_libtool_libdir_paths() {
	local dirpath
	for archive in ${*} ; do
		dirpath=$(dirname ${archive} | sed -e "s:^${D}::")
		sed -i ${archive} -e "s:^libdir.*:libdir=\'${dirpath}\':"
	done
}

use_multilib() {
	case $(tc-arch) in
		amd64|mips|sparc)
			has_multilib_profile || use multilib
		;;
		*)
			false
		;;
	esac
}
