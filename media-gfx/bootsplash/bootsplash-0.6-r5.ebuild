# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/bootsplash/bootsplash-0.6-r5.ebuild,v 1.1 2004/01/26 19:01:05 spock Exp $

DESCRIPTION="Graphical backgrounds for frame buffer consoles"
HOMEPAGE="http://linux.tkdack.com/"
SRC_URI="http://dev.gentoo.org/~spock/portage/distfiles/bootsplash-${PV}-${PR}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

S="${WORKDIR}/${PF}"

DEPEND=">=media-libs/freetype-2
	media-libs/libmng"

src_compile() {
	# compile utils
	# the util builds but the rc scripts have not been modified
	# animated boot up require patches to the baselayout package
	cd ${S}/utils/fbmngplay
	emake fbmngplay || die

	cd ${S}/utils/fbtruetype
	emake || die

	cd ${S}/utils/splashutils
	emake || die
}

src_install() {
	# Splash utilities
	exeinto /sbin
	doexe ${S}/utils/fbmngplay/fbmngplay
	doexe ${S}/utils/fbtruetype/fbtruetype
	doexe ${S}/utils/fbtruetype/fbtruetype.static
	newexe ${S}/utils/splashutils/splash splash.bin
	doexe ${S}/misc/splash
	doexe ${S}/utils/splashutils/fbresolution
	doexe ${S}/utils/splashutils/getkey
	doexe ${S}/utils/splashutils/progress

	mkdir -p ${D}/etc/${PN}
	cp -pR ${S}/themes/* ${D}/etc/${PN}

	# link default config for boot images if not already set
	if [ ! -e /etc/bootsplash/default ]; then
		dosym  ./gentoo /etc/bootsplash/default
	fi

	insinto /etc/init.d
	doins ${S}/misc/bootsplash
	fperms 755 /etc/init.d/bootsplash

	insinto /etc/conf.d
	doins ${S}/misc/bootsplash.conf

	insinto /usr/share/${PN}
	doins ${S}/kernel/bootsplash-3.0.7-2.4.20-vanilla.diff.bz2
	doins ${S}/kernel/bootsplash-3.0.7-2.4.22-vanilla.diff.bz2
	doins ${S}/kernel/bootsplash-3.1.3-2.6.0-test9.diff.bz2
	doins ${S}/misc/grub.conf.sample

	cat >${D}/sbin/bootsplash_patch <<END
#!/bin/bash
LINUX=\$1 ebuild /var/db/pkg/media-gfx/${PF}/${PF}.ebuild config
END
	chmod 0754 ${D}/sbin/bootsplash_patch

#	dodoc README
#	dodoc COPYING
#	dodoc CREDITS

}

pkg_postinst() {
	# Has to be done here so that the initrd images are created properly
	for SIZE in 800x600 1024x768 1280x1024 1600x1200
	do
		/sbin/splash -s -f /etc/bootsplash/gentoo/config/bootsplash-${SIZE}.cfg > /usr/share/${PN}/initrd-${SIZE}
	done

	echo ""
	einfo Execute \"bootsplash_patch\" to have your kernel sources in
	einfo /usr/src/linux patched with the Framebuffer Bootsplash patches.
	einfo
	einfo You can also use:
	einfo "    bootsplash_patch /path/to/your/custom/kernel/"
	einfo to patch your custom kernel sources.
	echo ""
	ewarn If you have already patched the kernel then you only need to copy
	ewarn an initrd from /usr/share/${PN} to /boot
	echo ""
	einfo Run:
	einfo "    rc-update add bootsplash default"
	einfo to change the console images after startup
	echo ""
}

pkg_config() {

	if [ "${LINUX}" != "" ]; then
		KV=`cat ${LINUX}/include/linux/version.h | grep UTS_RELEASE | cut -d" " -f3 | sed -e 's/"//' -e 's/"//'`
		if [ "${KV}" == "" ]; then
			die "Could not get kernel version; make sure ${LINUX}include/linux/version.h is there!"
		fi
	else
		LINUX='/usr/src/linux'
		check_KV || die "Cannot find kernel in /usr/src/linux!"
	fi

	KB=`echo ${KV} | cut -d. -f-2`
	KV_MINOR=`echo ${KV} | cut -d. -f3`

	ewarn
	ewarn "Patching the kernel (branch: ${KB}) in ${LINUX} ..."
	ewarn

	cd ${ROOT}/${LINUX}

	if [ "${KB}" == "2.4" ]; then

		if [ -f drivers/video/fbcon-splash.c ]; then
			eerror
			eerror "It appears your kernel has already been patched."
			eerror
			exit 1
		fi

		if [ $KV_MINOR >= 22 ]; then
			bzip2 -dc ${ROOT}/usr/share/${PN}/bootsplash-3.0.7-2.4.22-vanilla.diff.bz2 | patch -p1 || die
		else
			bzip2 -dc ${ROOT}/usr/share/${PN}/bootsplash-3.0.7-2.4.20-vanilla.diff.bz2 | patch -p1 || die
		fi

	elif [ "${KB}" == "2.6" ]; then

		if [ -d drivers/video/bootsplash ]; then
			eerror
			eerror "It appears your kernel has already been patched."
			eerror
			exit 1
		fi

		bzip2 -dc ${ROOT}/usr/share/${PN}/bootsplash-3.1.3-2.6.0-test9.diff.bz2 | patch -p1 || die
	else
		die "Sorry, this kernel branch is not supported."
	fi

	ewarn
	ewarn " ... complete."
	einfo
	einfo "Your kernel has been patched, rebuild with the following options"
	einfo "enabled (do not build them as modules!):"
	einfo "		Block Devices ->"
	einfo "			[*] RAM disk support"
	einfo "			[*] Loopback device support"
	einfo "			[*] Initial RAM disk (initrd) support"
	einfo
	einfo "		Console Drivers ->"
	einfo "			[*] Video mode selection support"
	einfo "			Frame-buffer support ->"
	einfo "				[*] Support for frame buffer devices"
	einfo "				[*] VESA VGA graphics console"
	einfo "				[*] Use splash screen instead of boot logo"
	einfo
	einfo "Copy an initrd from /usr/share/${PN} to /boot"
	einfo
	einfo "Look at \"/usr/share/${PN}/grub.conf.sample\" for an example"
	einfo "grub.conf file with the appropriate changes to enable the"
	einfo "framebuffer boot screens"
	einfo
	einfo "Ensure you make the appropriate changes to your grub.conf"
	einfo
}
