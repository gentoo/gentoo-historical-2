# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hibernate-script/hibernate-script-1.05.ebuild,v 1.2 2005/03/02 21:06:16 brix Exp $

# The following works with both pre-releases and releases
MY_P=${PN}-${PV/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Hibernate script supporting both suspend-to-ram and suspend-to-disk"

HOMEPAGE="http://softwaresuspend.berlios.de"
SRC_URI="http://download.berlios.de/softwaresuspend/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE=""

DEPEND="sys-apps/sed"
RDEPEND=""

src_unpack() {
	unpack ${A}

	# use /sys/power/state instead of swsusp2
	sed -i "s:^\(UseSwsusp2\):# \1:"                  ${S}/hibernate.conf
	sed -i "s:^\(Reboot\):# \1:"                      ${S}/hibernate.conf
	sed -i "s:^\(EnableEscape\):# \1:"                ${S}/hibernate.conf
	sed -i "s:^\(DefaultConsoleLevel\):# \1:"         ${S}/hibernate.conf
	sed -i "s:^# \(PowerdownMethod shutdown\):\1:"    ${S}/hibernate.conf

	# this 'hack' is needed in most cases
	sed -i "s:^\(SwitchToTextMode\):# \1:"            ${S}/hibernate.conf

	# sleep.conf for suspend to ram...
	cp ${S}/hibernate.conf ${S}/sleep.conf
	sed -i "s:^# \(UseSysfsPowerState\):\1:"          ${S}/sleep.conf

	# ... hibernate.conf for suspend to disk
	sed -i "s:^# \(UseSysfsPowerState\) mem:\1 disk:" ${S}/hibernate.conf
}

src_install() {
	BASE_DIR=${D} PREFIX=/usr MAN_DIR=${D}/usr/share/man ${S}/install.sh

	insinto /etc/hibernate
	doins ${S}/sleep.conf

	# hibernate-sleep will default to using sleep.conf
	dosym /usr/sbin/hibernate /usr/sbin/hibernate-sleep

	# other ebuilds can install scriplets to this dir
	keepdir /etc/hibernate/scriptlets.d/

	dodoc CHANGELOG README SCRIPTLET-API TODO
}
