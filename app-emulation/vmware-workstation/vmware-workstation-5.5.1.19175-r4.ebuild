# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vmware-workstation/vmware-workstation-5.5.1.19175-r4.ebuild,v 1.9 2006/09/27 18:31:37 wolf31o2 Exp $

# Alter ebuild so that the metadata cache is invalidated.

inherit vmware eutils

MY_P="VMware-workstation-5.5.1-19175"

DESCRIPTION="Emulate a complete PC on your PC without the usual performance overhead of most emulators"
HOMEPAGE="http://www.vmware.com/products/desktop/ws_features.html"
SRC_URI="mirror://vmware/software/wkst/${MY_P}.tar.gz
	http://ftp.cvut.cz/vmware/${ANY_ANY}.tar.gz
	http://ftp.cvut.cz/vmware/obselete/${ANY_ANY}.tar.gz
	http://knihovny.cvut.cz/ftp/pub/vmware/${ANY_ANY}.tar.gz
	http://knihovny.cvut.cz/ftp/pub/vmware/obselete/${ANY_ANY}.tar.gz"

LICENSE="vmware"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="strip"

# vmware-workstation should not use virtual/libc as this is a 
# precompiled binary package thats linked to glibc.
RDEPEND="sys-libs/glibc
	amd64? (
		app-emulation/emul-linux-x86-gtklibs )
	x86? (
		x11-libs/libXrandr
		x11-libs/libXcursor
		x11-libs/libXinerama
		x11-libs/libXi
		virtual/xft )
	!app-emulation/vmware-player
	!app-emulation/vmware-server
	~app-emulation/vmware-modules-1.0.0.13
	!<app-emulation/vmware-modules-1.0.0.13
	!>=app-emulation/vmware-modules-1.0.0.14
	>=dev-lang/perl-5
	sys-apps/pciutils"

S=${WORKDIR}/vmware-distrib

RUN_UPDATE="no"

dir=/opt/vmware/workstation
Ddir=${D}/${dir}

QA_TEXTREL_x86="${dir:1}/lib/lib/libgdk-x11-2.0.so.0/libgdk-x11-2.0.so.0"
QA_EXECSTACK_x86="${dir:1}/bin/vmnet-bridge
	${dir:1}/bin/vmnet-dhcpd
	${dir:1}/bin/vmnet-natd
	${dir:1}/bin/vmnet-netifup
	${dir:1}/bin/vmnet-sniffer
	${dir:1}/bin/vmware-loop
	${dir:1}/bin/vmware-ping
	${dir:1}/bin/vmware-vdiskmanager
	${dir:1}/lib/bin/vmware
	${dir:1}/lib/bin/vmware-vmx
	${dir:1}/lib/bin/vmrun
	${dir:1}/lib/bin/vmplayer
	${dir:1}/lib/bin-debug/vmware-vmx
	${dir:1}/lib/lib/libpixops.so.2.0.1/libpixops.so.2.0.1"

QA_TEXTREL_amd64="${dir:1}/lib/lib/libgdk-x11-2.0.so.0/libgdk-x11-2.0.so.0"
QA_EXECSTACK_amd64="${dir:1}/bin/vmnet-bridge
	${dir:1}/bin/vmnet-dhcpd
	${dir:1}/bin/vmnet-natd
	${dir:1}/bin/vmnet-netifup
	${dir:1}/bin/vmnet-sniffer
	${dir:1}/bin/vmware-loop
	${dir:1}/bin/vmware-ping
	${dir:1}/bin/vmware-vdiskmanager
	${dir:1}/lib/bin/vmware
	${dir:1}/lib/bin/vmware-vmx
	${dir:1}/lib/bin/vmrun
	${dir:1}/lib/bin/vmplayer
	${dir:1}/lib/bin-debug/vmware-vmx
	${dir:1}/lib/lib/libpixops.so.2.0.1/libpixops.so.2.0.1"

src_install() {
	vmware_src_install

	doicon lib/share/pixmaps/vmware-player.png
	make_desktop_entry vmware "VMWare Workstation" ${PN}.png System
	make_desktop_entry vmplayer "VMWare Player" vmware-player.png System
}
