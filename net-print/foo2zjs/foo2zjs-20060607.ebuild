# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/foo2zjs/foo2zjs-20060607.ebuild,v 1.3 2006/09/01 17:47:37 mr_bones_ Exp $

inherit eutils

DESCRIPTION="Support for printing to ZjStream-based printers"
HOMEPAGE="http://foo2zjs.rkkda.com/"
SRC_URI="
	http://gentooexperimental.org/~genstef/dist/${P}.tar.gz
	foo2zjs_devices_hp2600n? ( http://foo2zjs.rkkda.com/km2430.tar.gz http://foo2hp.rkkda.com/hpclj2600n.tar.gz )
	foo2zjs_devices_hp1600? ( http://foo2zjs.rkkda.com/km2430.tar.gz http://foo2hp.rkkda.com/hpclj2600n.tar.gz )
	foo2zjs_devices_km2430? ( http://foo2zjs.rkkda.com/km2430.tar.gz )
	foo2zjs_devices_km2300? ( http://foo2zjs.rkkda.com/km2430.tar.gz ftp://ftp.minolta-qms.com/pub/crc/out_going/win/m23dlicc.exe )
	foo2zjs_devices_km2200? ( ftp://ftp.minolta-qms.com/pub/crc/out_going/win2000/m22dlicc.exe )
	foo2zjs_devices_kmcpwl? ( ftp://ftp.minolta-qms.com/pub/crc/out_going/windows/cpplxp.exe )
	foo2zjs_devices_hp1020? ( http://foo2zjs.rkkda.com/sihp1020.tar.gz )
	foo2zjs_devices_hp1018? ( http://foo2zjs.rkkda.com/sihp1018.tar.gz )
	foo2zjs_devices_hp1005? ( http://foo2zjs.rkkda.com/sihp1005.tar.gz )
	foo2zjs_devices_hp1000? ( http://foo2zjs.rkkda.com/sihp1000.tar.gz )
	!foo2zjs_devices_hp2600n? ( !foo2zjs_devices_hp1600? (
	!foo2zjs_devices_km2430? ( !foo2zjs_devices_km2300? (
	!foo2zjs_devices_km2200? ( !foo2zjs_devices_kmcpwl? (
	!foo2zjs_devices_hp1020? ( !foo2zjs_devices_hp1018? (
	!foo2zjs_devices_hp1005? ( !foo2zjs_devices_hp1000? (
	http://foo2zjs.rkkda.com/km2430.tar.gz
	http://foo2hp.rkkda.com/hpclj2600n.tar.gz
	ftp://ftp.minolta-qms.com/pub/crc/out_going/win/m23dlicc.exe
	ftp://ftp.minolta-qms.com/pub/crc/out_going/win2000/m22dlicc.exe
	ftp://ftp.minolta-qms.com/pub/crc/out_going/windows/cpplxp.exe
	http://foo2zjs.rkkda.com/sihp1020.tar.gz
	http://foo2zjs.rkkda.com/sihp1018.tar.gz
	http://foo2zjs.rkkda.com/sihp1005.tar.gz
	http://foo2zjs.rkkda.com/sihp1000.tar.gz ) ) ) ) ) ) ) ) ) )
	"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
IUSE="cups foomaticdb udev usb
	foo2zjs_devices_hp2600n foo2zjs_devices_hp1600
	foo2zjs_devices_km2430 foo2zjs_devices_km2300
	foo2zjs_devices_km2200 foo2zjs_devices_kmcpwl
	foo2zjs_devices_hp1020 foo2zjs_devices_hp1018
	foo2zjs_devices_hp1005 foo2zjs_devices_hp1000"
DEPEND="app-arch/unzip"
RDEPEND="cups? ( net-print/cups )
	foomaticdb? ( net-print/foomatic-db-engine )
	net-print/foomatic-filters
	udev? ( sys-fs/udev )
	usb? ( || ( sys-fs/udev sys-apps/hotplug ) )"
KEYWORDS="~x86 ~amd64 ~ppc"
S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${P}.tar.gz

	# link getweb files in ${S} to get unpacked
	for i in ${A}
	do
		ln -s ${DISTDIR}/${i} ${S}
	done

	cd ${S}
	epatch ${FILESDIR}/foo2zjs-Makefile-20060523.diff
	epatch ${FILESDIR}/foo2zjs-udevfwld-20060607.diff
}

src_compile() {
	emake getweb || die "Failed building getweb script"

	# remove wget as we got the firmware with portage
	sed -i -e "s/.*wget.*//" \
		-e "s/error \"Couldn't dow.*//" getweb
	# unpack files
	use foo2zjs_devices_hp2600n && ./getweb 2600n
	use foo2zjs_devices_hp1600 && ./getweb 1600
	use foo2zjs_devices_km2430 && ./getweb 2430
	use foo2zjs_devices_km2300 && ./getweb 2300
	use foo2zjs_devices_km2200 && ./getweb 2200
	use foo2zjs_devices_kmcpwl && ./getweb cpwl

	use foo2zjs_devices_hp1020 && ./getweb 1020
	use foo2zjs_devices_hp1018 && ./getweb 1018
	use foo2zjs_devices_hp1005 && ./getweb 1005
	use foo2zjs_devices_hp1000 && ./getweb 1000
	use foo2zjs_devices_hp2600n || use foo2zjs_devices_hp1600 || use \
		foo2zjs_devices_km2430 || use foo2zjs_devices_km2430 || use \
		foo2zjs_devices_km2300 || use foo2zjs_devices_km2200 || use \
		foo2zjs_devices_kmcpwl || use foo2zjs_devices_hp1020 || use \
		foo2zjs_devices_hp1018 || use foo2zjs_devices_hp1005 || use \
		foo2zjs_devices_hp1000 || ./getweb all

	emake || die "emake failed"
}

src_install() {
	use foomaticdb && dodir /usr/share/foomatic/db/source

	use cups && dodir /usr/share/cups/model

	emake DESTDIR=${D} install \
		|| die "make install failed"

	if use udev; then
		emake DESTDIR=${D} install-udev \
			|| die "make install-udev failed"
	elif use usb; then
		emake DESTDIR=${D} install-hotplug \
			|| die "make install-hotplug failed"
	fi
}

pkg_postinst() {
	rm -f ${ROOT}/etc/udev/rules.d/58-foo2zjs.rules
}
