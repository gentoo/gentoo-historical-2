# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/glibc/glibc-2.3.4.20040602.ebuild,v 1.1 2004/06/03 21:38:34 lv Exp $

IUSE="nls pic build nptl erandom hardened makecheck"

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
strip-unsupported-flags

# Lock glibc at -O2 -- linuxthreads needs it and we want to be conservative here
export CFLAGS="${CFLAGS//-O?} -O2"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="${LDFLAGS//-Wl,--relax}"

DESCRIPTION="GNU libc6 (also called glibc2) C library"
SRC_URI="http://dev.gentoo.org/~lv/glibc-2.3.4-20040602.tar.bz2"
HOMEPAGE="http://sources.redhat.com/glibc/"

#KEYWORDS="~x86 ~mips ~sparc ~amd64 -hppa ~ia64 ~ppc" # breaks on ~alpha
#KEYWORDS="-* ~amd64 ~ppc64 ~mips"
KEYWORDS="-*"

SLOT="2.2"
LICENSE="LGPL-2"

# We need new cleanup attribute support from gcc for NPTL among things ...
# We also need linux-headers-2.6.6 if using NPTL. Including kernel headers is
# incredibly unreliable, and this new linux-headers release from plasmaroo
# should work with userspace apps, at least on amd64 and ppc64.
DEPEND=">=sys-devel/gcc-3.2.3-r1
	nptl? ( >=sys-devel/gcc-3.3.1-r1 )
	>=sys-devel/binutils-2.14.90.0.6-r1
	virtual/os-headers
	nptl? ( =sys-kernel/linux-headers-2.6.6 )
	nls? ( sys-devel/gettext )"
RDEPEND="virtual/os-headers
	sys-apps/baselayout
	nls? ( sys-devel/gettext )"

PROVIDE="virtual/glibc"

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

	# temporary fix for a few gcc 3.4 related problems
	if [ "`gcc-major-version`" -ge "3" -a "`gcc-minor-version`" -ge "4" ]
	then
		append-flags -fno-unit-at-a-time
	fi

}

want_nptl() {
	(use amd64 || use ppc || use ppc64 || use sparc || use s390 || \
		use ia64 || use alpha) && return 0
	use x86 && if [ "${CHOST/-*}" = "i486" -o "${CHOST/-*}" = "i586" -o \
		"${CHOST/-*}" = "i686" ] ; then return 0 ; fi
	return 1
}

want_tls() {
	(use amd64 || use ia64 || use s390 || use alpha || use sparc || \
		use ppc || use ppc64 || use x86) && return 0
	return 1
}

do_makecheck() {
	ATIME=`mount | awk '{ print $3,$6 }' | grep ^\/\  | grep noatime`
	if [ "$ATIME" = "" ]
	then
		cd ${WORKDIR}/build
		make check || die
	else
		ewarn "remounting / without noatime option so that make check"
		ewarn "does not fail!"
		sleep 2
		mount / -o remount,atime
		cd ${WORKDIR}/build
		make check || die
		einfo "remounting / with noatime"
		mount / -o remount,noatime
	fi
}

install_locales() {
	unset LANGUAGE LANG LC_ALL
	cd ${WORKDIR}/build
	make PARALLELMFLAGS="${MAKEOPTS}" \
		install_root=${D} localedata/install-locales || die
	keepdir /usr/lib/locale/ru_RU/LC_MESSAGES
}

setup_locales() {
	if use nls
	then
		einfo "nls in USE, installing -ALL- locales..."
		install_locales
	fi

	if [ -e /etc/locales.build ]
	then
		einfo "Installing locales in /etc/locales.build..."
		echo 'SUPPORTED-LOCALES=\' > SUPPORTED.locales
		cat /etc/locales.build | grep -v -e ^$ -e ^\# | sed 's/$/\ \\/g' \
			>> SUPPORTED.locales
		cat SUPPORTED.locales > ${S}/localedata/SUPPORTED || die
		install_locales || die
	elif [ -e ${FILESDIR}/locales.build ]
	then
		einfo "Installing locales in ${FILESDIR}/locales.build..."
		echo 'SUPPORTED-LOCALES=\' > SUPPORTED.locales
		cat ${FILESDIR}/locales.build | grep -v -e ^$ -e ^\# | sed 's/$/\ \\/g' \
			>> SUPPORTED.locales
		cat SUPPORTED.locales > ${S}/localedata/SUPPORTED || die
		install_locales || die
	else
		einfo "Installing -ALL- locales..."
		install_locales || die
	fi
}

pkg_setup() {
	# We need gcc 3.2 or later ...
	if [ "`gcc-major-version`" -ne "3" -o "`gcc-minor-version`" -lt "2" ]
	then
		echo
		eerror "As of glibc-2.3, gcc-3.2 or later is needed"
		eerror "for the build to succeed."
		die "GCC too old"
	fi

	echo

	if want_nptl
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
	unpack ${A}
	# Extract pre-made man pages.  Otherwise we need perl, which is a no-no.
	mkdir -p ${S}/man; cd ${S}/man
	want_nptl || tar xjf ${FILESDIR}/glibc-manpages-2.3.2.tar.bz2

	cd ${S}

	# To circumvent problems with propolice __guard and
	# __guard_setup__stack_smash_handler
	#
	#  http://www.gentoo.org/proj/en/hardened/etdyn-ssp.xml
	if [ "${ARCH}" != "hppa" -a "${ARCH}" != "hppa64" ]
	then
		cd ${S}
		epatch ${FILESDIR}/2.3.3/glibc-2.3.2-propolice-guard-functions-v3.patch
		cp ${FILESDIR}/2.3.3/ssp.c ${S}/sysdeps/unix/sysv/linux || \
			die "failed to copy ssp.c to ${S}/sysdeps/unix/sysv/linux/"
	fi

	# patch this regardless of architecture, although it's ssp-related
	epatch ${FILESDIR}/2.3.3/glibc-2.3.3-frandom-detect.patch

	#
	# *** PaX related patches starts here ***
	#

	# localedef contains nested function trampolines, which trigger
	# segfaults under PaX -solar
	# Debian Bug (#231438, #198099)
	epatch ${FILESDIR}/2.3.3/glibc-2.3.3-localedef-fix-trampoline.patch


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

	# Suppress unresolvable relocation against symbol `main' in Scrt1.o
	# can be reproduced with compiling net-dns/bind-9.2.2-r3 using -pie
	epatch ${FILESDIR}/2.3.3/${PN}-2.3.3_pre20040117-got-fix.diff

	#
	# *** PaX related patches ends here ***
	#

	# We do not want name_insert() in iconvconfig.c to be defined inside
	# write_output() as it causes issues with trampolines/PaX.
	cd ${S}; epatch ${FILESDIR}/2.3.2/${PN}-2.3.2-iconvconfig-name_insert.patch

	# A few patches only for the MIPS platform.  Descriptions of what they
	# do can be found in the patch headers.
	# <tuxus@gentoo.org> thx <dragon@gentoo.org> (11 Jan 2003)
	# <kumba@gentoo.org> remove tst-rndseek-mips & ulps-mips patches
	if [ "${ARCH}" = "mips" ]
	then
		cd ${S}
		epatch ${FILESDIR}/2.3.1/${PN}-2.3.1-fpu-cw-mips.patch
		epatch ${FILESDIR}/2.3.1/${PN}-2.3.1-librt-mips.patch
		epatch ${FILESDIR}/2.3.2/${PN}-2.3.2-mips-add-n32-n64-sysdep-cancel.patch
		epatch ${FILESDIR}/2.3.2/${PN}-2.3.2-mips-configure-for-n64-symver.patch
		epatch ${FILESDIR}/2.3.2/${PN}-2.3.2-mips-pread-linux2.5.patch
		epatch ${FILESDIR}/2.3.3/${PN}-2.3.3_pre20040420-mips-dl-machine-calls.diff
		epatch ${FILESDIR}/2.3.3/${PN}-2.3.3_pre20040420-mips-incl-sgidefs.diff
	fi

	if [ "${ARCH}" = "alpha" ]
	then
		cd ${S}
		# Fix compatability with compaq compilers by ifdef'ing out some
		# 2.3.2 additions.
		# <taviso@gentoo.org> (14 Jun 2003).
		epatch ${FILESDIR}/2.3.2/${PN}-2.3.2-decc-compaq.patch

		# Fix compilation with >=gcc-3.2.3 (01 Nov 2003 agriffis)
#		epatch ${FILESDIR}/2.3.2/${LOCAL_P}-alpha-pwrite.patch
	fi

	if [ "${ARCH}" = "amd64" ]
	then
		cd ${S}; epatch ${FILESDIR}/2.3.2/${PN}-2.3.2-amd64-nomultilib.patch
	fi

	if [ "${ARCH}" = "ia64" ]
	then
		# The basically problem is glibc doesn't store information about
		# what the kernel interface is so that it can't efficiently set up
		# parameters for system calls.  This patch from H.J. Lu fixes it:
		#
		#   http://sources.redhat.com/ml/libc-alpha/2003-09/msg00165.html
		#
		#cd ${S}; epatch ${FILESDIR}/2.3.2/${LOCAL_P}-ia64-LOAD_ARGS-fixup.patch
		:
	fi

	cd ${S}

	# Fix permissions on some of the scripts
	chmod u+x ${S}/scripts/*.sh

	# disable -z relro
	use hardened || sed -e 's/^have-z-relro.*/have-z-relro = no/' -i ${S}/config.make.in
	# disables building nscd as pie
	use hardened || sed -e 's/^have-fpie.*/have-fpie = no/' -i ${S}/config.make.in
	# disable binutils -as-needed, useful, if glibc should not depend on libgcc_s.so
	sed -e 's/^have-as-needed.*/have-as-needed = no/' -i ${S}/config.make.in
	# disable execstack (the patch is used by rh for gcc < 3.3.3)
	#use hardened || epatch ${FILESDIR}/2.3.3/glibc-execstack-disable.patch
	#use hardened || sed -e 's/^ASFLAGS-config.*/ASFLAGS-config =/' -i ${S}/config.make.in
	# mandatory, if binutils supports relro and the kernel is pax/grsecurity enabled
	# solves almost all segfaults building the locale files on grsecurity enabled kernels
	use build && sed -e 's/^LDFLAGS-rtld += $(relro.*/LDFLAGS-rtld += -Wl,-z,norelro/' -i ${S}/Makeconfig
	use build || (use hardened && sed -e 's/^LDFLAGS-rtld += $(relro.*/LDFLAGS-rtld += -Wl,-z,norelro/' -i ${S}/Makeconfig)
}

src_compile() {
	setup_flags

	# These should not be set, else the
	# zoneinfo do not always get installed ...
	unset LANGUAGE LANG LC_ALL

	use nls || myconf="${myconf} --disable-nls"

	use erandom || myconf="${myconf} --disable-dev-erandom"

	use hardened && myconf="${myconf} --enable-bind-now"

	if (use nptl && want_nptl && want_tls)
	then
		myconf="${myconf} \
		--enable-add-ons=nptl \
		--with-tls --with-__thread \
		--enable-kernel=2.6.6"
	else
		myconf="${myconf} --enable-add-ons=linuxthreads --without-__thread"
	fi

	# we dont want to enable tls ourselves, as this can cause catalyst to fail
	# for some people on some archs.
	want_tls || myconf="${myconf} --without-tls"

	rm -rf ${WORKDIR}/build
	mkdir -p ${WORKDIR}/build
	cd ${WORKDIR}/build
	${S}/configure --disable-profile \
		--without-gd \
		--without-cvs \
		--with-headers=/usr/include \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--libexecdir=/usr/lib/misc \
		${myconf} || die

	make || die
}

src_install() {
	setup_flags

	# These should not be set, else the
	# zoneinfo do not always get installed ...
	unset LANGUAGE LANG LC_ALL

	cd ${WORKDIR}/build

	einfo "Installing GLIBC..."
	make PARALLELMFLAGS="${MAKEOPTS}" \
		install_root=${D} \
		install || die

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

	if [ -z "`use build`" ]
	then
		cd ${WORKDIR}/build

		# we make the CVS snapshot info pages with -i, as they're occasionally
		# broken and it really has zero functional effect on the glibc
		# install other than a lack of documentation :)
		einfo "Installing Info pages..."
		make PARALLELMFLAGS="${MAKEOPTS}" \
			install_root=${D} \
			info -i

		setup_locales

		einfo "Installing man pages and docs..."
		# Install linuxthreads man pages
		want_nptl || {
			dodir /usr/share/man/man3
			doman ${S}/man/*.3thr
		}

		# Install nscd config file
		insinto /etc
		doins ${FILESDIR}/nscd.conf

		cd ${S}
		dodoc BUGS ChangeLog* CONFORMANCE COPYING* FAQ INTERFACE \
			NEWS NOTES PROJECTS README*
	else
		rm -rf ${D}/usr/share ${D}/usr/lib/gconv

		einfo "Installing Timezone data..."
		make PARALLELMFLAGS="${MAKEOPTS}" \
			install_root=${D} \
			timezone/install-others -C ${WORKDIR}/build || die
	fi

	if [ "`use pic`" ]
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

	# This is our new config file for building locales
	insinto /etc
	doins ${FILESDIR}/locales.build

	use makecheck && do_makecheck
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

