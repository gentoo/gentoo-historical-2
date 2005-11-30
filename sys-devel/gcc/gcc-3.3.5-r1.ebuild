# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-3.3.5-r1.ebuild,v 1.1 2004/12/05 04:19:34 lv Exp $

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie+ssp extensions, Haj Ten Brugge runtime bounds checking"

KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~sh ~sparc ~x86"

# we need a proper glibc version for the Scrt1.o provided to the pie-ssp specs
# we also need at least glibc 2.3.3 20040420-r1 in order for gcc 3.4 not to nuke
# SSP in glibc.

# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND="virtual/libc
	>=sys-devel/gcc-config-1.3.6
	>=sys-libs/zlib-1.1.4
	!sys-devel/hardened-gcc
	!uclibc? ( >=sys-libs/glibc-2.3.2-r9 )
	>=sys-devel/binutils-2.14.90.0.6-r1
	>=sys-devel/bison-1.875
	amd64? ( multilib? ( >=app-emulation/emul-linux-x86-glibc-1.1 ) )
	sparc? ( hardened? ( >=sys-libs/glibc-2.3.3.20040420 ) )
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
	amd64? ( >=sys-devel/binutils-2.15.90.0.1.1-r1 )"
PDEPEND="sys-devel/gcc-config"

GENTOO_TOOLCHAIN_BASE_URI="http://dev.gentoo.org/~lv/GCC/"
#GCC_MANPAGE_VERSION="3.3.4"
#BRANCH_UPDATE="20041025"
PATCH_VER="1.0"
PIE_VER="8.7.7"
PIE_CORE="gcc-3.3.5-piepatches-v${PIE_VER}.tar.bz2"
PP_VER="3_3_2"
PP_FVER="${PP_VER//_/.}-3"
HTB_VER="1.00"
#HTB_GCC_VER=""

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

inherit eutils flag-o-matic libtool gnuconfig toolchain

gcc_do_filter_flags() {
	strip-flags

	# In general gcc does not like optimization, and add -O2 where
	# it is safe.  This is especially true for gcc 3.3 + 3.4
	replace-flags -O? -O2

	strip-unsupported-flags

	# If we use multilib on mips, we shouldn't pass -mabi flag - it breaks
	# build of non-default-abi libraries.
	use mips && use multilib && filter-flags "-mabi*"

	# Compile problems with these (bug #6641 among others)...
	#filter-flags "-fno-exceptions -fomit-frame-pointer -fforce-addr"

	export GCJFLAGS="${CFLAGS}"
}


chk_gcc_version() {
	mkdir -p "${WORKDIR}"

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
		if [ "${CHOST}" = "${CTARGET}" -a "${OLD_GCC_CHOST}" != "${CHOST}" ]
		then
			echo "${OLD_GCC_CHOST}" > "${WORKDIR}/.oldgccchost"
		fi
	fi

	# Did we check the version ?
	touch "${WORKDIR}/.chkgccversion"
}

src_unpack() {
	gcc_src_unpack

	if [ -n "${PATCH_VER}" ] && use uclibc ; then
		mv ${S}/gcc-3.3.2/libstdc++-v3/config/os/uclibc ${S}/libstdc++-v3/config/os/ || die
		mv ${S}/gcc-3.3.2/libstdc++-v3/config/locale/uclibc ${S}/libstdc++-v3/config/locale/ || die
		epatch ${FILESDIR}/3.3.3/gcc-uclibc-3.3-loop.patch
	fi

	# misc patches that havent made it into a patch tarball yet
	epatch ${FILESDIR}/gcc-spec-env.patch

	if [ "${ARCH}" = "ppc" -o "${ARCH}" = "ppc64" ] ; then
		epatch ${FILESDIR}/3.3.3/gcc333_pre20040408-stack-size.patch
	fi

	if [ "${ARCH}" = "arm" ] ; then
		epatch ${FILESDIR}/3.3.3/gcc333-debian-arm-getoff.patch
		epatch ${FILESDIR}/3.3.3/gcc333-debian-arm-ldm.patch
	fi

	# Anything useful and objc will require libffi. Seriously. Lets just force
	# libffi to install with USE="objc", even though it normally only installs
	# if you attempt to build gcj.
	if use objc && ! use gcj ; then
		epatch ${FILESDIR}/3.3.4/libffi-without-libgcj.patch
		#epatch ${FILESDIR}/3.4.3/libffi-nogcj-lib-path-fix.patch
	fi
}


src_install() {
	local x=

	# Do allow symlinks in ${PREFIX}/lib/gcc-lib/${CHOST}/${PV}/include as
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
	make DESTDIR="${D}" install || die

	if [ "${CHOST}" == "${CTARGET}" ] ; then
		[ -r ${D}${BINPATH}/gcc ] || die "gcc not found in ${D}"
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

	# This one comes with binutils
	rm -f ${D}${PREFIX}/lib/libiberty.a
	rm -f ${D}${LIBPATH}/libiberty.a
	[ -e ${D}/${PREFIX}/lib/32 ] && rm -rf ${D}/${PREFIX}/lib/32

	# we dont want these in freaky non-versioned paths that dont ever get used
	fix_freaky_non_versioned_library_paths_that_dont_ever_get_used 32
	fix_freaky_non_versioned_library_paths_that_dont_ever_get_used 64
	# and mips is just freaky in general ;p
	fix_freaky_non_versioned_library_paths_that_dont_ever_get_used o32
	# and finally, the non-bitdepth-or-ABI-specific freaky path
	if [ -d ${D}/${LIBPATH}/../lib ] ; then
		mv ${D}/${LIBPATH}/../lib/* ${D}/${LIBPATH}/
		rm -rf ${D}/${LIBPATH}/../lib
	fi
	# we also dont want libs in /usr/lib*
	if [ -d ${D}/${PREFIX}/lib32 -a -d ${D}/${LIBPATH}/32 ] ; then
		mv ${D}/${PREFIX}/lib32/* ${D}/${LIBPATH}/32/
		rm -rf ${D}/${PREFIX}/lib32/
	elif [ -d ${D}/${PREFIX}/lib32 -a ! -d ${D}/${LIBPATH}/32 ] ; then
		mv ${D}/${PREFIX}/lib32/* ${D}/${LIBPATH}/
		rm -rf ${D}/${PREFIX}/lib32/
	fi
	if [ -d ${D}/${PREFIX}/lib64 -a -d ${D}/${LIBPATH}/64 ] ; then
		mv ${D}/${PREFIX}/lib64/* ${D}/${LIBPATH}/64/
		rm -rf ${D}/${PREFIX}/lib64/
	elif [ -d ${D}/${PREFIX}/lib64 -a ! -d ${D}/${LIBPATH}/64 ] ; then
		mv ${D}/${PREFIX}/lib64/* ${D}/${LIBPATH}/
		rm -rf ${D}/${PREFIX}/lib64/
	fi
	if [ "$(get_multilibdir)" != "lib" ] ; then
		mv ${D}/${PREFIX}/lib/*so*  ${D}/${PREFIX}/lib/*\.la \
			 ${D}/${PREFIX}/lib/*\.a ${D}/${LIBPATH}
	else
		mv ${D}/${PREFIX}/lib/*so*  ${D}/${PREFIX}/lib/*\.la \
			 ${D}/${PREFIX}/lib/*\.a ${D}/${LIBPATH}/32/
	fi
	# and sometimes crap ends up here too :|
	mv ${D}/${LIBPATH}/../*.a ${D}/${LIBPATH}/../*.la ${D}/${LIBPATH}/../*so* \
		${D}/${LIBPATH}/

	# make sure the libtool archives have libdir set to where they actually
	# -are-, and not where they -used- to be.
	fix_libtool_libdir_paths "$(find ${D}/${LIBPATH} -name *.la)"

	# Make sure we dont have stuff lying around that
	# can nuke multiple versions of gcc
	if ! use build
	then
		cd ${D}${LIBPATH}

		# Move Java headers to compiler-specific dir
		for x in ${D}${PREFIX}/include/gc*.h ${D}${PREFIX}/include/j*.h
		do
			[ -f "${x}" ] && mv -f ${x} ${D}${LIBPATH}/include/
		done
		for x in gcj gnu java javax org
		do
			if [ -d "${D}${PREFIX}/include/${x}" ]
			then
				dodir /${LIBPATH}/include/${x}
				mv -f ${D}${PREFIX}/include/${x}/* ${D}${LIBPATH}/include/${x}/
				rm -rf ${D}${PREFIX}/include/${x}
			fi
		done

		if [ -d "${D}${PREFIX}/lib/security" ]
		then
			dodir /${LIBPATH}/security
			mv -f ${D}${PREFIX}/lib/security/* ${D}${LIBPATH}/security
			rm -rf ${D}${PREFIX}/lib/security
		fi

		# Move libgcj.spec to compiler-specific directories
		[ -f "${D}${PREFIX}/lib/libgcj.spec" ] && \
			mv -f ${D}${PREFIX}/lib/libgcj.spec ${D}${LIBPATH}/libgcj.spec

		# Rename jar because it could clash with Kaffe's jar if this gcc is
		# primary compiler (aka don't have the -<version> extension)
		cd ${D}${PREFIX}/${CTARGET}/gcc-bin/${MY_PV_FULL}
		[ -f jar ] && mv -f jar gcj-jar

		# Move <cxxabi.h> to compiler-specific directories
		[ -f "${D}${STDCXX_INCDIR}/cxxabi.h" ] && \
			mv -f ${D}${STDCXX_INCDIR}/cxxabi.h ${D}${LIBPATH}/include/

		# These should be symlinks
		cd ${D}${BINPATH}
		for x in gcc g++ c++ g77 gcj
		do
			if [ "${CHOST}" == "${CTARGET}" ] && [ -f "${CTARGET}-${x}" ]
			then
				[ ! -f "${x}" ] && mv "${CTARGET}-${x}" "${x}"
				ln -sf ${x} ${CTARGET}-${x}
			fi

			if [ -f "${CTARGET}-${x}-${PV}" ]
			then
				rm -f ${CTARGET}-${x}-${PV}
				ln -sf ${CTARGET}-${x} ${CTARGET}-${x}-${PV}
			fi
		done
	fi

	cd ${S}
	if ! use build && [ "${CHOST}" == "${CTARGET}" ] ; then
		prepman ${DATAPATH}
		prepinfo ${DATAPATH}
	else
		rm -rf ${D}/usr/share/{man,info}
		rm -rf ${D}${DATAPATH}/{man,info}
	fi

	# Rather install the script, else portage with changing $FILESDIR
	# between binary and source package borks things ....
	if [ "${CHOST}" == "${CTARGET}" ] ; then
		insinto /lib/rcscripts/awk
		doins ${FILESDIR}/awk/fixlafiles.awk
		exeinto /sbin
		doexe ${FILESDIR}/fix_libtool_files.sh
	fi
}

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

fix_libtool_libdir_paths() {
	local dirpath
	for archive in ${*} ; do
		dirpath=$(dirname ${archive} | sed -e "s:^${D}::")
		sed -i ${archive} -e "s:^libdir.*:libdir=\'${dirpath}\':"
	done
}


pkg_preinst() {

	if [ ! -f "${WORKDIR}/.chkgccversion" ]
	then
		mkdir -p ${WORKDIR}
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

	should_we_gcc_config && do_gcc_config

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
}
