# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/desklet-sysinfo/desklet-sysinfo-0.21.2.ebuild,v 1.1 2003/09/30 11:24:46 obz Exp $

DESKLET_NAME="SysInfo"

MY_P=${DESKLET_NAME}-${PV}
S=${WORKDIR}/${DESKLET_NAME}

DESCRIPTION="A system information providing Display/Sensor for gDesklets"
SRC_URI="http://gdesklets.gnomedesktop.org/files/${MY_P}.tar.bz2"
HOMEPAGE="http://gdesklets.gnomedesktop.org"
LICENSE="as-is"

SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND=">=gnome-extra/gdesklets-core-0.22"

DOCS="AUTHORS ChangeLog"

src_unpack( ) {

	# *grumble* if you compress an archive using gunzip,
	# why would you suffix it .tar.bz2 ? <obz@gentoo.org>
	cd ${WORKDIR}
	tar zxfv ${DISTDIR}/${MY_P}.tar.bz2

}

src_install( ) {

	SYS_PATH="/usr/share/gdesklets"
	INSTALL_BIN="Install_${DESKLET_NAME}_Sensor.bin"
	dodir ${SYS_PATH}/{Sensors,Displays}

	cd ${WORKDIR}
	# first we install the Sensor
	python ${INSTALL_BIN} --nomsg ${D}${SYS_PATH}/Sensors

	cd ${S}
	# and then the .displays
	insinto ${SYS_PATH}/Displays/${DESKLET_NAME}
	doins *.display

	# and finally the graphics
	cp -R gfx/ ${D}${SYS_PATH}/Displays/${DESKLET_NAME}

	dodoc ${DOCS}

}

