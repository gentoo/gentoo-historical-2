# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/linuxtv-dvb/linuxtv-dvb-1.1.1-r2.ebuild,v 1.3 2006/03/11 23:00:56 hansmi Exp $

inherit eutils linux-mod

DVB_TTPCI_FW="dvb-ttpci-01.fw-2622"
DESCRIPTION="Standalone DVB driver for Linux kernel 2.4.x"
HOMEPAGE="http://www.linuxtv.org"
SRC_URI="http://www.linuxtv.org/download/dvb/${P}.tar.bz2
	http://www.linuxtv.org/download/dvb/firmware/${DVB_TTPCI_FW}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ppc x86"
IUSE=""
DEPEND=""
RDEPEND=""

S=${WORKDIR}/${P}/build-2.4

pkg_setup() {
	linux-mod_pkg_setup
	if [[ ${KV_MAJOR}.${KV_MINOR} != 2.4 ]]; then
		einfo "This ebuild only provides drivers for Kernel 2.4"
		einfo "Kernel 2.6 has included drivers for DVB devices."
		einfo "please use these"
		die "Kernel 2.6 not supported"
	fi

	einfo "Please make sure that the following option is enabled"
	einfo "in your current kernel 'Multimedia devices'"
	einfo "and /usr/src/linux point's to your current kernel"
	einfo "or make will die."
	einfo
	MODULE_NAMES="dvb(dvb:${S})"
	BUILD_PARAMS="KDIR=${KERNEL_DIR}"
	BUILD_TARGETS="build"
}

src_unpack() {
	unpack ${A}
	cp ${DISTDIR}/${DVB_TTPCI_FW} ${S}/dvb-ttpci-01.fw
}

src_install() {
	#copy over the insmod.sh script
	#for loading all modules
	sed -e "s:insmod ./:modprobe :" -i insmod.sh
	sed -e "s:.${KV_OBJ}::" -i insmod.sh
	newsbin insmod.sh dvb-module-load

	# install the modules
	make install DESTDIR="${D}" DEST="/lib/modules/${KV_FULL}/dvb"

	# install the header files
	# linux26-headers installs those
	# FIXME: is it save to assume _all_ kernel 2.6 users got that?
	cd ${S}/../linux/include/linux/dvb
	insinto /usr/include/linux/dvb
	doins *.h

	#install the main docs
	cd ${S}
	dodoc MAKEDEV-DVB.sh NEWS README README.bt8xx TODO TROUBLESHOOTING

	#install the other docs
	cd ${S}/doc
	dodoc HOWTO-use-the-demux-api \
	README.valgrind HOWTO-use-the-frontend-api \
	convert.sh valgrind-2.1.0-dvb.patch
}

pkg_postinst() {
	linux-mod_pkg_postinst
	einfo "If you don't use devfs, execute MAKEDEV-DVB.sh to create"
	einfo "the device nodes. The file is in /usr/share/doc/${PF}/"
	einfo
	einfo "A file called dvb-module-load has been created to simplify loading all modules."
	einfo "Call it using 'dvb-module-load {load|debug|unload}'."
	einfo
	einfo "For information about firmware please see /usr/share/doc/${PF}/README."
	einfo
	einfo "Firmware-files can be found in media-tv/linuxtv-dvb-firmware"
	einfo
}
