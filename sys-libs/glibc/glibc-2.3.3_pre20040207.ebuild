# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/glibc/glibc-2.3.3_pre20040207.ebuild,v 1.16 2004/07/09 09:44:57 genone Exp $

IUSE="nls pic build nptl debug"

inherit eutils flag-o-matic gcc

filter-flags "-fomit-frame-pointer -malign-double"
filter-ldflags "-pie"

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
strip-flags

# Lock glibc at -O2 -- linuxthreads needs it and we want to be conservative here
export CFLAGS="${CFLAGS//-O?} -O2"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="${LDFLAGS//-Wl,--relax}"

BRANCH_UPDATE="20040207"

# Minimum kernel version for --enable-kernel
export MIN_KV="2.4.1"
# Minimum kernel version for enabling TLS and NPTL ...
# NOTE: do not change this if you do not know what
#       you are doing !
export MIN_NPTL_KV="2.6.0"

#MY_PV="${PV/_}"
MY_PV="2.3.2"
#S="${WORKDIR}/${P%_*}"
S="${WORKDIR}/${PN}-${MY_PV}"
DESCRIPTION="GNU libc6 (also called glibc2) C library"
SRC_URI="http://ftp.gnu.org/gnu/glibc/glibc-${MY_PV}.tar.bz2
	ftp://sources.redhat.com/pub/glibc/snapshots/glibc-${MY_PV}.tar.bz2
	http://ftp.gnu.org/gnu/glibc/glibc-linuxthreads-${MY_PV}.tar.bz2
	ftp://sources.redhat.com/pub/glibc/snapshots/glibc-linuxthreads-${MY_PV}.tar.bz2
	mirror://gentoo/${P/_*}-branch-update-${BRANCH_UPDATE}.patch.bz2
	hppa? ( mirror://gentoo/${PN}-${MY_PV}-hppa-patches-p1.tar.bz2 )"
HOMEPAGE="http://www.gnu.org/software/libc/libc.html"

KEYWORDS="~x86 ~mips ~sparc ~amd64 -hppa ~alpha ~ia64 ~ppc"
SLOT="2.2"
LICENSE="LGPL-2"

# We need new cleanup attribute support from gcc for NPTL among things ...
DEPEND=">=sys-devel/gcc-3.2.3-r1
	nptl? ( >=sys-devel/gcc-3.3.1-r1 )
	>=sys-devel/binutils-2.14.90.0.6-r1
	virtual/os-headers
	nls? ( sys-devel/gettext )"
RDEPEND="virtual/os-headers
	sys-apps/baselayout
	nls? ( sys-devel/gettext )"

PROVIDE="virtual/glibc virtual/libc"


# Try to get a kernel source tree with version equal or greater
# than $1.  We basically just try a few default locations.  The
# version need to be that which KV_to_int() returns ...
get_KHV() {
	local headers=

	[ -z "$1" ] && return 1

	# - First check if linux-headers are installed (or symlink
	#   to current kernel ...)
	# - Ok, do we have access to the current kernel's headers ?
	# - Last option ... maybe its a weird bootstrap with /lib
	#   binded to the chroot ...

	# We do not really support more than 2 arguments ...
	if [ -n "$2" ]
	then
		headers="$2"
	else
		# Things should be pretty stable kernel side now, so try
		# /usr/include first, then the current kernel's headers.
		headers="${ROOT}/usr/include \
		         /lib/modules/`uname -r`/build/include \
		         ${ROOT}/lib/modules/`uname -r`/build/include \
				 /usr/src/linux/include \
				 ${ROOT}/usr/src/linux/include"
	fi

	for x in ${headers}
	do
		local header="${x}/linux/version.h"

		if [ -f ${header} ]
		then

			local version="`grep 'LINUX_VERSION_CODE' ${header} | \
				sed -e 's:^.*LINUX_VERSION_CODE[[:space:]]*::'`"

			if [ "${version}" -ge "$1" ]
			then
				echo "${x}"

				return 0
			fi
		fi
	done

	return 1
}

use_nptl() {
	# Enable NPTL support if:
	# - We have 'nptl' in USE
	# - We have linux-2.5 or later kernel (should prob check for 2.4.20 ...)
	if use nptl && [ "`get_KV`" -ge "`KV_to_int ${MIN_NPTL_KV}`"  ]
	then
		# Enable NPTL support if:
		# - We have 'x86' in USE and:
		#   - a CHOST of "i486-pc-linux-gnu"
		#   - a CHOST of "i586-pc-linux-gnu"
		#   - a CHOST of "i686-pc-linux-gnu"
		# - Or we have 'alpha' in USE
		# - Or we have 'amd64' in USE
		# - Or we have 'mips' in USE
		# - Or we have 'ppc' in USE
		case ${ARCH} in
			"x86")
				if [ "${CHOST/-*}" = "i486" -o \
				     "${CHOST/-*}" = "i586" -o \
					 "${CHOST/-*}" = "i686" ]
				then
					return 0
				fi
				;;
			"alpha"|"amd64"|"ia64"|"mips"|"ppc"|"sparc")
				return 0
				;;
			*)
				return 1
				;;
		esac
	fi

	return 1
}

pkg_setup() {
	# Check if we are going to downgrade, we don't like that
	local old_version

	old_version="`best_version glibc`"
	old_version="${old_version/sys-libs\/glibc-/}"

	if [ "$old_version" ]; then
		if [ `python -c "import portage; print int(portage.vercmp(\"${PV}\",\"$old_version\"))"` -lt 0 ]; then
			if [ "${FORCE_DOWNGRADE}" ]; then
				ewarn "downgrading glibc, still not recommended, but we'll do as you wish"
			else
				eerror "Dowgrading glibc is not supported and we strongly recommend that"
				eerror "you don't do it as it WILL break all applications compiled against"
				eerror "the new version (most likely including python and portage)."
				eerror "If you are REALLY sure that you want to do it set "
				eerror "     FORCE_DOWNGRADE=1"
				eerror "when you try it again."
				die "glibc downgrade"
			fi
		fi
	fi

	# We need gcc 3.2 or later ...
	if [ "`gcc-major-version`" -ne "3" -o "`gcc-minor-version`" -lt "2" ]
	then
		echo
		eerror "As of glibc-2.3, gcc-3.2 or later is needed"
		eerror "for the build to succeed."
		die "GCC too old"
	fi

	echo

	if use_nptl
	then
		# The use_nptl should have already taken care of kernel version,
		# arch and CHOST, so now just check if we can find suitable kernel
		# source tree or headers ....
		einfon "Checking for sufficient version kernel headers ... "
		if ! get_KHV "`KV_to_int ${MIN_NPTL_KV}`" &> /dev/null
		then
			echo "no"
			echo
			eerror "Could not find a kernel source tree or headers with"
			eerror "version ${MIN_NPTL_KV} or later!  Please correct this"
			eerror "and try again."
			die "Insufficient kernel headers present!"
		else
			echo "yes"
		fi
	fi

	if [ "$(KV_to_int $(uname -r))" -gt "`KV_to_int '2.5.68'`" ]
	then
		local KERNEL_HEADERS="$(get_KHV "`KV_to_int ${MIN_NPTL_KV}`")"

		einfon "Checking kernel headers for broken sysctl.h ... "
		if ! gcc -I"${KERNEL_HEADERS}" \
		         -c ${FILESDIR}/test-sysctl_h.c -o ${T}/test1.o &> /dev/null
		then
			echo "yes"
			echo
			eerror "Your version of:"
			echo
			eerror "  ${KERNEL_HEADERS}/linux/sysctl.h"
			echo
			eerror "is broken (from a user space perspective).  Please apply"
			eerror "the following patch:"
			echo
			eerror "*******************************************************"
			cat ${FILESDIR}/fix-sysctl_h.patch
			eerror "*******************************************************"
			die "Broken linux/sysctl.h header included in kernel sources!"
		else
			echo "no"
		fi
	fi

	if use_nptl
	then
		einfon "Checking gcc for __thread support ... "
		if ! gcc -c ${FILESDIR}/test-__thread.c -o ${T}/test2.o &> /dev/null
		then
			echo "no"
			echo
			eerror "Could not find a gcc that supports the __thread directive!"
			eerror "please update to gcc-3.2.2-r1 or later, and try again."
			die "No __thread support in gcc!"
		else
			echo "yes"
		fi

	elif use nptl &> /dev/null
	then
		echo
		# Just tell the user not to expect too much ...
		ewarn "You have \"nptl\" in your USE, but your kernel version or"
		ewarn "architecture does not support it!"
	fi

	echo
}

src_unpack() {

	local LOCAL_P="${PN}-${MY_PV}"

	unpack glibc-${MY_PV}.tar.bz2

	# Extract pre-made man pages.  Otherwise we need perl, which is a no-no.
	mkdir -p ${S}/man; cd ${S}/man
	use_nptl || tar xjf ${FILESDIR}/glibc-manpages-${MY_PV}.tar.bz2

	cd ${S}
	# Extract our threads package ...
	if (! use_nptl) && [ -z "${BRANCH_UPDATE}" ]
	then
		unpack glibc-linuxthreads-${MY_PV}.tar.bz2
	fi

	if [ -n "${BRANCH_UPDATE}" ]
	then
		epatch ${DISTDIR}/${PN}-${PV/_*}-branch-update-${BRANCH_UPDATE}.patch.bz2
	fi

	if use_nptl
	then
		epatch ${FILESDIR}/2.3.2/${LOCAL_P}-redhat-nptl-fixes.patch
	else
		epatch ${FILESDIR}/2.3.2/${LOCAL_P}-redhat-linuxthreads-fixes.patch
	fi

	# To circumvent problems with propolice __guard and
	# __guard_setup__stack_smash_handler
	#
	#  http://www.gentoo.org/proj/en/hardened/etdyn-ssp.xml
	if [ "${ARCH}" != "hppa" -a "${ARCH}" != "hppa64" ]
	then
		cd ${S}; epatch ${FILESDIR}/2.3.2/${LOCAL_P}-propolice-guard-functions-v2.patch
	fi

	#
	# *** PaX related patches starts here ***
	#

	# With latest versions of glibc, a lot of apps failed on a PaX enabled
	# system with:
	#
	#  cannot enable executable stack as shared object requires: Permission denied
	#
	# This is due to PaX 'exec-protecting' the stack, and ld.so then trying
	# to make the stack executable due to some libraries not containing the
	# PT_GNU_STACK section.  Bug #32960.  <azarah@gentoo.org> (12 Nov 2003).
	cd ${S}; epatch ${FILESDIR}/2.3.3/${PN}-2.3.3-dl_execstack-PaX-support.patch

	# Program header support for PaX.
	cd ${S}; epatch ${FILESDIR}/2.3.3/${PN}-2.3.3_pre20040117-pt_pax.diff

	# suppress unresolvable relocation against symbol `main' in Scrt1.o
	# can be reproduced with compiling net-dns/bind-9.2.2-r3 using -pie
	epatch ${FILESDIR}/2.3.3/${PN}-2.3.3_pre20040117-got-fix.diff

	# Cosmetic change to SSP
	# Send a SEGV vs ABRT on self termniation.
	# KILL might be even better?
	if [ "${ARCH}" != "hppa" -a "${ARCH}" != "hppa64" ]
	then
		cd ${S}; epatch ${FILESDIR}/2.3.3/${PN}-2.3.3_pre20040117-signal-ssp.diff
	fi

	#
	# *** PaX related patches ends here ***
	#

	# Sanity check the forward and backward chunk pointers in the
	# unlink() macro used by Doug Lea's implementation of malloc(3).
	cd ${S}; epatch ${FILESDIR}/2.3.3/glibc-2.3.3-owl-malloc-unlink-sanity-check.diff

	# Fix an assert when running libc.so from commandline, bug #34733.
	cd ${S}; epatch ${FILESDIR}/2.3.2/${PN}-2.3.2-rtld-assert-fix.patch

	# This next patch fixes a test that will timeout due to ReiserFS' slow handling of sparse files
#	cd ${S}/io; epatch ${FILESDIR}/glibc-2.2.2-test-lfs-timeout.patch

	# This add back glibc 2.2 compadibility.  See bug #8766 and #9586 for more info,
	# and also:
	#
	#  http://lists.debian.org/debian-glibc/2002/debian-glibc-200210/msg00093.html
	#
	# We should think about remoing it in the future after things have settled.
	#
	# Thanks to Jan Gutter <jangutter@tuks.co.za> for reporting it.
	#
	# <azarah@gentoo.org> (26 Oct 2002).
	cd ${S}; epatch ${FILESDIR}/2.3.1/${PN}-2.3.1-ctype-compat-v3.patch

	# One more compat issue which breaks sun-jdk-1.3.1.  See bug #8766 for more
	# info, and also:
	#
	#   http://sources.redhat.com/ml/libc-alpha/2002-04/msg00143.html
	#
	# Thanks to Jan Gutter <jangutter@tuks.co.za> for reporting it.
	#
	# <azarah@gentoo.org> (30 Oct 2002).
	cd ${S}; epatch ${FILESDIR}/2.3.1/${PN}-2.3.1-libc_wait-compat.patch

	# One more compat issue ... libc_stack_end is missing from ld.so.
	# Got this one from diffing redhat glibc tarball .. would help if
	# they used patches and not modified tarball ...
	#
	# <azarah@gentoo.org> (7 Nov 2002).
#	cd ${S}; epatch ${FILESDIR}/2.3.1/${PN}-2.3.1-stack_end-compat.patch

	# The mathinline.h header omits the middle term of a ?: expression.  This
	# is a gcc extension, but since the ISO standard forbids it, it's a
	# GLIBC bug (bug #27142).  See also:
	#
	#   http://bugs.gentoo.org/show_bug.cgi?id=27142
	#
#	cd ${S}; epatch ${FILESDIR}/2.3.2/${LOCAL_P}-fix-omitted-operand-in-mathinline_h.patch

	# We do not want name_insert() in iconvconfig.c to be defined inside
	# write_output() as it causes issues with trampolines/PaX.
	cd ${S}; epatch ${FILESDIR}/2.3.2/${LOCAL_P}-iconvconfig-name_insert.patch

	# A few patches only for the MIPS platform.  Descriptions of what they
	# do can be found in the patch headers.
	# <tuxus@gentoo.org> thx <dragon@gentoo.org> (11 Jan 2003)
	# <kumba@gentoo.org> remove tst-rndseek-mips & ulps-mips patches
	if [ "${ARCH}" = "mips" ]
	then
		cd ${S}
		epatch ${FILESDIR}/2.3.1/${PN}-2.3.1-fpu-cw-mips.patch
		epatch ${FILESDIR}/2.3.1/${PN}-2.3.1-libgcc-compat-mips.patch
		epatch ${FILESDIR}/2.3.1/${PN}-2.3.1-librt-mips.patch
		epatch ${FILESDIR}/2.3.2/${LOCAL_P}-mips-add-n32-n64-sysdep-cancel.patch
		epatch ${FILESDIR}/2.3.2/${LOCAL_P}-mips-configure-for-n64-symver.patch
		epatch ${FILESDIR}/2.3.2/${LOCAL_P}-mips-pread-linux2.5.patch
	fi

	if [ "${ARCH}" = "alpha" ]
	then
		cd ${S}
		# Fix compatability with compaq compilers by ifdef'ing out some
		# 2.3.2 additions.
		# <taviso@gentoo.org> (14 Jun 2003).
		epatch ${FILESDIR}/2.3.2/${LOCAL_P}-decc-compaq.patch

		# Fix compilation with >=gcc-3.2.3 (01 Nov 2003 agriffis)
		epatch ${FILESDIR}/2.3.2/${LOCAL_P}-alpha-pwrite.patch
	fi

	if [ "${ARCH}" = "amd64" ]
	then
		cd ${S}; epatch ${FILESDIR}/2.3.2/${LOCAL_P}-amd64-nomultilib.patch
	fi

	if [ "${ARCH}" = "ia64" ]
	then
		# The basically problem is glibc doesn't store information about
		# what the kernel interface is so that it can't efficiently set up
		# parameters for system calls.  This patch from H.J. Lu fixes it:
		#
		#   http://sources.redhat.com/ml/libc-alpha/2003-09/msg00165.html
		#
		cd ${S}; epatch ${FILESDIR}/2.3.2/${LOCAL_P}-ia64-LOAD_ARGS-fixup.patch
	fi

	if [ "${ARCH}" = "hppa" ]
	then
		local x=

		cd ${WORKDIR}
		unpack ${LOCAL_P}-hppa-patches-p1.tar.bz2
		cd ${S}
		EPATCH_EXCLUDE="010* 020* 030* 040* 050* 055* 130* 190* 200* 230*"
		for x in ${EPATCH_EXCLUDE}
		do
			rm -f ${WORKDIR}/${LOCAL_P}-hppa-patches/${x}
		done
		for x in ${WORKDIR}/${LOCAL_P}-hppa-patches/*
		do
			epatch ${x}
		done
		epatch ${FILESDIR}/2.3.1/glibc23-07-hppa-atomicity.dpatch
	fi

	cd ${S}

	# Fix permissions on some of the scripts
	chmod u+x ${S}/scripts/*.sh
}

setup_flags() {
	# -freorder-blocks for all but ia64 s390 s390x
	use ppc || append-flags "-freorder-blocks"

	# Sparc/Sparc64 support
	if use sparc
	then

		# Both sparc and sparc64 can use -fcall-used-g6.  -g7 is bad, though.
		replace-flags "-fcall-used-g7" ""
		append-flags "-fcall-used-g6"

		# Sparc64 Only support...
		if [ "${PROFILE_ARCH}" = "sparc64" ]
		then

			# Get rid of -mcpu options, the CHOST will fix this up
			replace-flags "-mcpu=ultrasparc" ""
			replace-flags "-mcpu=v9" ""

			# Get rid of flags known to fail
			replace-flags "-mvis" ""

			# Setup the CHOST properly to insure "sparcv9"
			# This passes -mcpu=ultrasparc -Wa,-Av9a to the compiler
			[ "${CHOST}" == "sparc-unknown-linux-gnu" ] && \
				export CHOST="sparcv9-unknown-linux-gnu"
		fi
	fi
}

src_compile() {
	local myconf=
	local myconf_nptl=

	setup_flags

	# These should not be set, else the
	# zoneinfo do not always get installed ...
	unset LANGUAGE LANG LC_ALL

	use nls || myconf="${myconf} --disable-nls"

	if use_nptl
	then
		local kernelheaders="$(get_KHV "`KV_to_int ${MIN_NPTL_KV}`")"

		# NTPL and Thread Local Storage support.
		myconf="${myconf} --with-tls --with-__thread \
		                       --enable-add-ons=nptl \
		                       --enable-kernel=${MIN_NPTL_KV} \
		                       --with-headers=${kernelheaders}"
	else
		myconf="${myconf} --without-__thread \
		                  --enable-add-ons=linuxthreads"

		# If we build for the build system we use the kernel headers from the target
		# We also now set it without "build" as well, else it might use the
		# current kernel's headers, which might just fail (the linux-headers
		# package is usually well tested...)
#		( use build || use sparc ) \
#			&& myconf="${myconf} --with-headers=${ROOT}usr/include"
		myconf="${myconf} --with-headers=${ROOT}usr/include"

		# If kernel version and headers in ${ROOT}/usr/include are ok,
		# then enable --enable-kernel=${MIN_KV} ...
		if [ "`get_KV`" -ge "`KV_to_int ${MIN_KV}`" -a \
		     -n "$(get_KHV "`KV_to_int ${MIN_KV}`" "${ROOT}/usr/include")" ]
		then
			myconf="${myconf} --enable-kernel=${MIN_KV}"
		else
			myconf="${myconf} --enable-kernel=2.2.5"
		fi
	fi

	# some silly people set LD_RUN_PATH and that breaks things.
	# see bug 19043
	unset LD_RUN_PATH

	einfo "Configuring GLIBC..."
	rm -rf ${S}/buildhere
	mkdir -p ${S}/buildhere
	cd ${S}/buildhere
	../configure --build=${CHOST} \
		--host=${CHOST} \
		--with-gd=no \
		--without-cvs \
		--disable-profile \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--libexecdir=/usr/lib/misc \
		${myconf} || die

	einfo "Building GLIBC..."
	cd ${S}/buildhere
	make PARALLELMFLAGS="${MAKEOPTS}" || die
#	einfo "Doing GLIBC checks..."
#	make check
}

src_install() {
	local buildtarget="buildhere"

	setup_flags

	# These should not be set, else the
	# zoneinfo do not always get installed ...
	unset LANGUAGE LANG LC_ALL

	einfo "Installing GLIBC..."
	make PARALLELMFLAGS="${MAKEOPTS}" \
		install_root=${D} \
		install -C ${buildtarget} || die

	# If librt.so is a symlink, change it into linker script (Redhat)
	if [ -L "${D}/usr/lib/librt.so" -a "${LIBRT_LINKERSCRIPT}" = "yes" ]
	then
		local LIBRTSO="`cd ${D}/lib; echo librt.so.*`"
		local LIBPTHREADSO="`cd ${D}/lib; echo libpthread.so.*`"

		rm -f ${D}/usr/lib/librt.so
		cat > ${D}/usr/lib/librt.so <<EOF
/* GNU ld script
	librt.so.1 needs libpthread.so.0 to come before libc.so.6*
	in search scope.  */
EOF
		grep "OUTPUT_FORMAT" ${D}/usr/lib/libc.so >> ${D}/usr/lib/librt.so
		echo "GROUP ( /lib/${LIBPTHREADSO} /lib/${LIBRTSO} )" \
			>> ${D}/usr/lib/librt.so

		for x in ${D}/usr/lib/librt.so.[1-9]
		do
			[ -L "${x}" ] && rm -f ${x}
		done
	fi

	if ! use build
	then
		einfo "Installing Info pages..."
		make PARALLELMFLAGS="${MAKEOPTS}" \
			install_root=${D} \
			info -C ${buildtarget} || die

		einfo "Installing Locale data..."
		make PARALLELMFLAGS="${MAKEOPTS}" \
			install_root=${D} \
			localedata/install-locales -C ${buildtarget} || die

		# Compatibility hack: this locale has vanished from glibc,
		# but some other programs are still using it.
		keepdir /usr/lib/locale/ru_RU/LC_MESSAGES

		einfo "Installing man pages and docs..."
		# Install linuxthreads man pages
		use_nptl || {
			dodir /usr/share/man/man3
			doman ${S}/man/*.3thr
		}

		# Install nscd config file
		insinto /etc
		doins ${FILESDIR}/nscd.conf

		dodoc BUGS ChangeLog* CONFORMANCE COPYING* FAQ INTERFACE \
			NEWS NOTES PROJECTS README*
	else
		rm -rf ${D}/usr/share ${D}/usr/lib/gconv

		einfo "Installing Timezone data..."
		make PARALLELMFLAGS="${MAKEOPTS}" \
			install_root=${D} \
			timezone/install-others -C ${buildtarget} || die
	fi

	if use pic
	then
		find ${S}/${buildtarget}/ -name "soinit.os" -exec cp {} ${D}/lib/soinit.o \;
		find ${S}/${buildtarget}/ -name "sofini.os" -exec cp {} ${D}/lib/sofini.o \;
		find ${S}/${buildtarget}/ -name "*_pic.a" -exec cp {} ${D}/lib \;
		find ${S}/${buildtarget}/ -name "*.map" -exec cp {} ${D}/lib \;
		for i in ${D}/lib/*.map
		do
			mv ${i} ${i%.map}_pic.map
		done
	fi

	# Is this next line actually needed or does the makefile get it right?
	# It previously has 0755 perms which was killing things.
	fperms 4711 /usr/lib/misc/pt_chown

	# Currently libraries in  /usr/lib/gconv do not get loaded if not
	# in search path ...
#	insinto /etc/env.d
#	doins ${FILESDIR}/03glibc

	rm -f ${D}/etc/ld.so.cache

	# Prevent overwriting of the /etc/localtime symlink.  We'll handle the
	# creation of the "factory" symlink in pkg_postinst().
	rm -f ${D}/etc/localtime

	# Some things want this, notably ash.
	dosym /usr/lib/libbsd-compat.a /usr/lib/libbsd.a
}

pkg_postinst() {
	# Correct me if I am wrong here, but my /etc/localtime is a file
	# created by zic ....
	# I am thinking that it should only be recreated if no /etc/localtime
	# exists, or if it is an invalid symlink.
	#
	# For invalid symlink:
	#   -f && -e  will fail
	#   -L will succeed
	#
	if [ ! -e ${ROOT}/etc/localtime ]
	then
		echo "Please remember to set your timezone using the zic command."
		rm -f ${ROOT}/etc/localtime
		ln -s ../usr/share/zoneinfo/Factory ${ROOT}/etc/localtime
	fi

	if [ -x ${ROOT}/usr/sbin/iconvconfig ]
	then
		# Generate fastloading iconv module configuration file.
		${ROOT}/usr/sbin/iconvconfig --prefix=${ROOT}
	fi

	# Reload init ...
	if [ "${ROOT}" = "/" ]
	then
		/sbin/init U &> /dev/null
	fi
}

