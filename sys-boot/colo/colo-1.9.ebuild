# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/colo/colo-1.9.ebuild,v 1.1 2004/05/15 09:34:46 kumba Exp $

inherit eutils

DESCRIPTION="CObalt Linux lOader - Modern bootloader for Cobalt MIPS machines"
HOMEPAGE="http://www.colonel-panic.org/cobalt-mips/"
SRC_URI="http://www.colonel-panic.org/cobalt-mips/colo/colo-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~mips"
IUSE=""
DEPEND=""
RESTRICT="nostrip"


pkg_setup() {
	# See if we're on a cobalt system (must use the cobalt-mips profile)
	if [ "${PROFILE_ARCH}" != "cobalt" ]; then
		echo -e ""
		eerror "This package is only intended for the Cobalt Microserver MIPS-based"
		eerror "systems.  It will not function on any other MIPS-based system or any"
		eerror "other architecture"
		echo -e ""
		die
	fi
}

# Not needed for this release, maybe others...
#src_unpack() {
#	unpack ${A}
#
#	# patch Docs
#	cd ${S}
#	epatch ${FILESDIR}/${P}-gentoo.patch
#}

src_compile() {
	# boot-loader
	cd ${S}
	make clean || die	# emake breaks the build
	make || die

	# flash-tool
	cd ${S}/tools/flash-tool
	make clean || die
	make || die
}

src_install() {
	# bins
	cd ${S}
	dodir /usr/lib/colo
	cp binaries/colo-chain.elf ${D}/usr/lib/colo
	cp binaries/colo-rom-image.bin ${D}/usr/lib/colo
	cp ${FILESDIR}/default.boot.example ${D}/usr/lib/colo/default.colo.example

	# docs
	dodoc CHANGES COPYING INSTALL README README.{restore,shell} TODO

	# flash-tool
	dosbin tools/flash-tool/flash-tool
}

pkg_postinst() {
	echo -e ""
	einfo "Binaries for this bootloader have been stored in"
	einfo "/usr/lib/cobalt-bootloader.  Documentation has been"
	einfo "installed in /usr/share/doc/${PF}.  The flash utility"
	einfo "has been installed as /usr/sbin/flash-tool.  An example"
	einfo "default.colo has been placed in /usr/lib/colo.  It is"
	einfo "a script file the bootloader uses to execute a series"
	einfo "of commands to load the machine.  If you desire the"
	einfo "machine to boot to the bootloader command prompt, copy"
	einfo "/usr/lib/colo/default.colo.example to /boot/default.colo,"
	einfo "otherwise the bootloader will attempt to automatically"
	einfo "boot /boot/vmlinux.gz.  It is recommended that you edit"
	einfo "the default.colo.example script to fit your needs and"
	einfo "place it in /boot as default.colo."
	echo -e ""
	ewarn "Note: It is HIGHLY recommended that you use the chain"
	ewarn "bootloader (colo-chain.elf) first before attempting to"
	ewarn "write the bootloader to the flash chip to verify that"
	ewarn "it will work for you.  It is also recommended that"
	ewarn "you read the documentation in /usr/share/doc/${PF}"
	ewarn "as it explains how to properly use this package."
	echo -e ""
	eerror "Warning: Make sure that IF you plan on flashing the"
	eerror "bootloader into the flash chip that you are using a"
	eerror "modern 2.4 Linux kernel (i.e., >2.4.18), otherwise"
	eerror "you run a risk of destroying the contents of the"
	eerror "flash chip and rendering the machine unusable."
	echo -e ""
	echo -e ""
}
