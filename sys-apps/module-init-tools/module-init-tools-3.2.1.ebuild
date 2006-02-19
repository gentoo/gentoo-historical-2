# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/module-init-tools/module-init-tools-3.2.1.ebuild,v 1.11 2006/02/19 22:11:07 kumba Exp $

inherit flag-o-matic eutils toolchain-funcs fixheadtails

MYP="${P/_pre/-pre}"
S="${WORKDIR}/${MYP}"
MODUTILS_PV="2.4.27"
DESCRIPTION="Kernel module tools for the development kernel >=2.5.48"
HOMEPAGE="http://www.kernel.org/pub/linux/kernel/people/rusty/modules"
SRC_URI="mirror://kernel/linux/kernel/people/rusty/modules/${MYP}.tar.bz2
	mirror://kernel/linux/kernel/people/rusty/modules/old/${MYP}.tar.bz2
	mirror://kernel/linux/utils/kernel/modutils/v2.4/modutils-${MODUTILS_PV}.tar.bz2"
#	!no-old-linux? ( mirror://kernel/linux/utils/kernel/modutils/v2.4/modutils-${MODUTILS_PV}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE=""
#IUSE="no-old-linux"
# The test code runs `make clean && configure` and screws up src_compile()
RESTRICT="test"

DEPEND="sys-libs/zlib
	!virtual/modutils"
PROVIDE="virtual/modutils"

src_unpack() {
	unpack ${A}

	# Patches for old modutils
#	if ! use no-old-linux ; then
		cd "${WORKDIR}"/modutils-${MODUTILS_PV}
		epatch "${FILESDIR}"/modutils-2.4.27-alias.patch
		epatch "${FILESDIR}"/modutils-2.4.27-gcc.patch
		epatch "${FILESDIR}"/modutils-2.4.27-flex.patch
		epatch "${FILESDIR}"/modutils-2.4.27-no-nested-function.patch
#	fi

	ht_fix_file "${S}"/tests/test-depmod/10badcommand.sh
	# Test fails due since it needs to write to /lib/modules so disable it
	rm -f "${S}"/tests/test-depmod/01backcompat.sh

	# Fix bug 49926: This patch allows generate-modprobe.conf to
	# accept the --assume-kernel=x.x.x option for generating livecds.
	# This is a companion to a patch in baselayout-1.9.0 which allows
	# the same flag to modules-update.
	cd "${S}"; epatch "${FILESDIR}"/${PN}-3.1_generate-modprobe-assume-kernel.patch

	# Abort if we fail to run modprobe, bug #68689
	cd "${S}"; epatch "${FILESDIR}"/${PN}-3.2_pre7-abort-on-modprobe-failure.patch

	cd "${S}"
	# make sure we don't try to regen the manpages
	touch *.5

	rm -f missing
	automake --add-missing || die
}

src_compile() {
	# Configure script uses BUILDCFLAGS for cross-compiles but this
	# defaults to CFLAGS which can be bad mojo
	export BUILDCFLAGS=-pipe
	export BUILDCC="$(tc-getBUILD_CC)"

#	if ! use no-old-linux ; then
		einfo "Building modutils..."
		cd ${WORKDIR}/modutils-${MODUTILS_PV}
		econf \
			--disable-strip \
			--prefix=/ \
			--enable-insmod-static \
			--disable-zlib \
			|| die "econf failed"
		local mymake=""
		[ "${ARCH}" = "hppa" ] && mymake="ARCH=hppa"
		emake ${mymake} || die "emake modutils failed"
#	fi

	einfo "Building module-init-tools..."
	cd "${S}"
	econf \
		--prefix=/ \
		--enable-zlib \
		|| die "econf failed"

	# Our zlib.so is in /lib vs /usr/lib so it's safe to link with.
	# this also fixes text relocations that were showing up in this pkg
	emake LDADD="-lz" || die "emake module-init-tools failed"
}

src_install() {
#	if ! use no-old-linux ; then
		local mymake=""
		[ "${ARCH}" = "hppa" ] && mymake="ARCH=hppa"
		cd ${WORKDIR}/modutils-${MODUTILS_PV}
		einstall prefix="${D}" ${mymake}

		docinto modutils-${MODUTILS_PV}
		dodoc CREDITS ChangeLog NEWS README TODO

		cd "${S}"
		# This copies the old version of modutils to *.old so it still works
		# with kernels <= 2.4; new versions will execve() the .old version if
		# a 2.4 kernel is running...
		# This code was borrowed from the module-init-tools Makefile
		local runme=
		local f=
		for f in lsmod modprobe rmmod depmod insmod insmod.static modinfo
		do
			if [ -L ${D}/sbin/${f} ]
			then
				einfo "Moving symlink $f to ${f}.old"
				#runme = the target of the symlink with a .old tagged on.
				runme="`ls -l ${D}/sbin/${f} | sed 's/.* -> //'`.old"
				[ ! -e ${D}/sbin/${runme} ] || einfo "${D}/sbin/${runme} not found"
				dosym $runme /sbin/${f} || die
			elif [ -e ${D}/sbin/${f} ]
			then
				einfo "Moving executable $f to ${f}.old"
			fi
			mv -f ${D}/sbin/${f} ${D}/sbin/${f}.old
		done
		# Move the man pages as well.  We only do this for the man pages of the
		# tools that module-init-tools will replace.
		for f in ${D}/usr/share/man/man8/{lsmod,modprobe,rmmod,depmod,insmod}.8
		do
			mv -f ${f} ${f%\.*}.old.${f##*\.}
		done
		# Fix the ksyms links #35601
		for f in ksyms kallsyms ; do
			dosym insmod.old /sbin/${f}
			dosym insmod.static.old /sbin/${f}.static
		done
#	fi

	cd "${S}"
	make install DESTDIR="${D}" || die
	dosym modprobe.conf.5 /usr/share/man/man5/modprobe.d.5

	# Install compat symlink
	dosym ../bin/lsmod /sbin/lsmod
	#use no-old-linux || 
	dosym ../sbin/insmod.old /bin/lsmod.old
	# Install the modules.conf2modprobe.conf tool, so we can update
	# modprobe.conf.
	into /
	dosbin "${S}"/generate-modprobe.conf
	# Create the new modprobe.conf
	dodir /etc
	rm -f ${D}/etc/modprobe.conf
	if [ ! -f ${ROOT}/etc/modprobe.devfs ]
	then
		# Support file for the devfs hack .. needed else modprobe borks.
		# Baselayout-1.8.6.3 or there abouts will have a modules-update that
		# will correctly generate /etc/modprobe.devfs ....
		echo "### This file is automatically generated by modules-update" \
			> ${D}/etc/modprobe.devfs
	else
		# This is dynamic, so we do not want this in the package ...
		rm -f ${D}/etc/modprobe.devfs
	fi

	doman *.[1-8]
	docinto /
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}

pkg_postinst() {
	if [ "${ROOT}" = "/" ]
	then
		einfo "Updating config files..."
		if [ -x /sbin/modules-update ]
		then
			/sbin/modules-update
		elif [ -x /sbin/update-modules ]
		then
			/sbin/update-modules
		elif [ -x /usr/sbin/update-modules ]
		then
			/usr/sbin/update-modules
		fi
	fi
}
