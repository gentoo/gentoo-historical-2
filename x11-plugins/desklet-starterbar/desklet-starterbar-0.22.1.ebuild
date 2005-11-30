# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/desklet-starterbar/desklet-starterbar-0.22.1.ebuild,v 1.1 2003/11/12 10:57:25 obz Exp $

DESKLET_NAME="StarterBar"

MY_PN=${PN/desklet-/}-desklet
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="An OSX like gnome panel for launchers"
SRC_URI="http://gdesklets.gnomedesktop.org/files/${MY_P}.tar.bz2"
HOMEPAGE="http://gdesklets.gnomedesktop.org/"
LICENSE="as-is"

SLOT="0"
IUSE=""
KEYWORDS="~x86 ~sparc ~ppc"

DEPEND=">=gnome-extra/gdesklets-core-0.23"

DOCS="INSTALL README"

src_install() {

	SYS_PATH="/usr/share/gdesklets"
	INSTALL_BIN="Install_${DESKLET_NAME}_Sensor.bin"
	dodir ${SYS_PATH}/{Sensors,Displays}

	# first we install the Sensor
	python ${INSTALL_BIN} --nomsg ${D}${SYS_PATH}/Sensors

	# and then the .displays
	insinto ${SYS_PATH}/Displays/${DESKLET_NAME}
	doins *.display

	# and finally the graphics
	cp -R gfx/ ${D}${SYS_PATH}/Displays/${DESKLET_NAME}

	dodoc ${DOCS}

	# the desklets unpack preserves permissions of the archive
	chown -R root:root ${D}${SYS_PATH}/Sensors/${DESKLET_NAME}

}

