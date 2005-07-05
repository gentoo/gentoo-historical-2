# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/linuxtv-dvb-apps/linuxtv-dvb-apps-1.1.0.ebuild,v 1.2 2005/07/05 19:41:36 zzam Exp $

DESCRIPTION="Standalone DVB driver for Linux kernel 2.4.x"
HOMEPAGE="http://www.linuxtv.org/wiki/index.php/LinuxTV_dvb-apps"
SRC_URI="http://www.linuxtv.org/download/dvb/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~alpha ~ia64 ~amd64 ~ppc"
IUSE="usb"
DEPEND="media-tv/linuxtv-dvb
	usb? ( >=dev-libs/libusb-0.1.10a )"
#RDEPEND=""

src_compile() {
	cd ${S}/util
	make
	if use usb; then
		einfo "Building ttusb_dec_reset"
		# build the ttusb_dec_reset program
		cd ${S}/util/ttusb_dec_reset
		make
	else
		einfo "Not building ttusb_dec_reset"
	fi
}

src_install() {
	cd ${S}/util

	dobin av7110_loadkeys/av7110_loadkeys av7110_loadkeys/evtest
	dobin dvbdate/dvbdate
	dobin dvbnet/dvbnet
	dobin dvbtraffic/dvbtraffic
	mv scan/scan scan/dvbscan # conflict with exim file name
	dobin scan/dvbscan
	cd szap
	dobin szap czap tzap femon

	if use usb; then
		dobin ${S}/util/ttusb_dec_reset/ttusb_dec_reset
	fi

	# Install Documentation and test code:
	DOCDIR="/usr/share/doc/${PF}"

	mkdir ${S}/docs
	cp ${S}/util/av7110_loadkeys/README  ${S}/docs/README.av7110_loadkeys
	cp ${S}/util/scan/README ${S}/docs/README.scan
	cp ${S}/util/szap/README ${S}/docs/README.szap
	cp ${S}/README ${S}/docs/README
	cp ${S}/TODO ${S}/docs/TODO
	cp ${S}/libdvb2/README ${S}/docs/README.libdvb2
	if use usb; then
		cp ${S}/util/ttusb_dec_reset/README ${S}/docs/README.ttusb_dec_reset
	fi
	dodoc ${S}/docs/*

	insinto "${DOCDIR}/test/"
	doins ${S}/test/*

	insinto "${DOCDIR}/dvbnet/"
	doins ${S}/util/dvbnet/net_start.*

	insinto "${DOCDIR}/szap/"
	doins ${S}/util/szap/channels.*

	insinto "${DOCDIR}/scan/"
	cp -r ${S}/util/scan/dvb-[sct] ${D}/${DOCDIR}/scan/

}

pkg_postinst() {
	einfo "Please read the documentation in /usr/share/doc/${PF}."
	einfo "The channel lists and other examples also are in this directory."
	einfo
	einfo "scanning utility is now installed as dvbscan"
}