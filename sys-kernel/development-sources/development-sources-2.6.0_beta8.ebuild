# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/development-sources/development-sources-2.6.0_beta8.ebuild,v 1.4 2003/10/22 18:17:28 johnm Exp $
#OKV=original kernel version, KV=patched kernel version.  They can be the same.

#Original Kernel Version before Patches
# eg: 2.6.0-test8
OKV=${PV/_beta/-test}
OKV=${OKV/-r*//}

#Kernel version after patches
# eg: 2.6.0-test8-bk1
KV=${PF/_beta/-test}
KV=${KV/-r/-bk}
KV=${KV//${PN}-}

#version of gentoo patchset
# eg: 2.6.0-test8-r1-patchset-1
# this gets added on right at the end before it links
# if you dont want to apply these patches, set GPV=0
GPV=0.1

S=${WORKDIR}/linux-${OKV}
ETYPE="sources"

IUSE="alsa"
DESCRIPTION="Full sources for the Development Branch of the Linux kernel"

[ ! ${GPV} == 0 ] && GPATCH_URI="mirror://gentoo/distfiles/genpatches-2.6-${GPV}.tar.bz2"
[ -z ${KV/*-bk*/} ] && PATCH_URI="http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-${KV}.bz2"

SRC_URI="mirror://kernel/linux/kernel/v2.6/linux-${OKV}.tar.bz2 ${PATCH_URI} ${GPATCH_URI}"
HOMEPAGE="http://www.kernel.org/ http://www.gentoo.org/"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* x86 ~amd64"

PROVIDE="virtual/linux-sources"
[ -n "$(use alsa)" ] && PROVIDE="${PROVIDE} virtual/alsa"

if [ $ETYPE = "sources" ] && [ -z "`use build`" ]
then
	#console-tools is needed to solve the loadkeys fiasco; binutils version needed to avoid Athlon/PIII/SSE assembler bugs.
	DEPEND=">=sys-devel/binutils-2.11.90.0.31"
	RDEPEND=">=sys-libs/ncurses-5.2 dev-lang/perl
		 sys-devel/make
		 sys-apps/module-init-tools"
fi

[ -z "$LINUX_HOSTCFLAGS" ] && LINUX_HOSTCFLAGS="-Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -I${S}/include"

src_unpack() {
	cd ${WORKDIR}
	unpack linux-${OKV}.tar.bz2

	# apply bk pulls	
	if [ -z ${KV/*-bk*/} ]
	then
		cd ${S}
		epatch ${DISTDIR}/patch-${KV}.bz2
		cd ${WORKDIR}
	fi

	# apply gentoo patches	
	if [ ! ${GPV} == 0 ]
	then
		cd ${S}
		epatch ${DISTDIR}/genpatches-2.6-${GPV}.tar.bz2
		KV="${KV}-patchset-${GPV}"
		cd ${WORKDIR}
	fi

	# move to appropriate src dir
	if [ ! ${KV} == ${OKV} ]
	then
		mv linux-${OKV} linux-${KV}
		S=${WORKDIR}/linux-${KV}
	fi

	cd ${S}
	unset ARCH
	#sometimes we have icky kernel symbols; this seems to get rid of them
	make mrproper || die

	#fix silly permissions in tarball
	cd ${WORKDIR}
	chown -R 0:0 *
	chmod -R a+r-w+X,u+w *
}

src_compile() {
	if [ "$ETYPE" = "headers" ]
	then
		yes "" | make oldconfig
		echo "Ignore any errors from the yes command above."
	fi
}

src_install() {
	if [ "$ETYPE" = "sources" ]
	then
		dodir /usr/src
		echo ">>> Copying sources..."
		mv ${WORKDIR}/* ${D}/usr/src
	else
		#linux-headers
		dodir /usr/include/linux
		cp -ax ${S}/include/linux/* ${D}/usr/include/linux
		rm -rf ${D}/usr/include/linux/modules
		dodir /usr/include/asm
		cp -ax ${S}/include/asm-i386/* ${D}/usr/include/asm
	fi
}

pkg_preinst() {
	if [ "$ETYPE" = "headers" ]
	then
		[ -L ${ROOT}usr/include/linux ] && rm ${ROOT}usr/include/linux
		[ -L ${ROOT}usr/include/asm ] && rm ${ROOT}usr/include/asm
		true
	fi
}

pkg_postinst() {
	[ "$ETYPE" = "headers" ] && return
	[ ! -e ${ROOT}usr/src/linux-beta ] && ln -sf linux-${KV} ${ROOT}/usr/src/linux-beta

	echo
	ewarn "Please note that ptyfs support has been removed from devfs"
	ewarn "and you have to compile it in now, or else you will get"
	ewarn "errors when trying to open a pty. The option is:"
	ewarn "File systems -> Pseudo filesystems -> /dev/pts filesystem."
	echo
	ewarn "Also, note that you must compile in support for"
	ewarn "input devices (Input device support->Input devices),"
	ewarn "the virtual terminal (Character Devices->Virtual terminal),"
	ewarn "vga_console (Graphics Support->Console...->VGA text console)"
	ewarn "and the vt_console (Character Devices->Support for console...)."
	ewarn "Otherwise, you will get the dreaded \"Uncompressing the Kernel\""
	ewarn "error."
	echo
	ewarn "PLEASE NOTE THIS IS NOT OFFICIALLY SUPPORTED BY GENTOO."
	sleep 5
}
