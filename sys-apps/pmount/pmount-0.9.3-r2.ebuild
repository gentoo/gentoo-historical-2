# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pmount/pmount-0.9.3-r2.ebuild,v 1.1 2005/08/28 15:36:56 cardoe Exp $

inherit eutils

DESCRIPTION="Policy based mounter that gives the ability to mount removable devices as a user"
SRC_URI="http://www.piware.de/projects/${P}.tar.gz"
HOMEPAGE="http://www.piware.de/projects.shtml"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE="crypt"

RDEPEND=">=sys-apps/dbus-0.33
	>=sys-apps/hal-0.5.1
	>=sys-fs/sysfsutils-1.0
	crypt? ( sys-fs/cryptsetup-luks )"

DEPEND=${RDEPEND}

DOCS="AUTHORS CHANGES"

pkg_setup() {
	enewgroup plugdev || die "Error creating plugdev group"
}

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -e 's:/sbin/cryptsetup:/bin/cryptsetup:' -i policy.h
}

src_install () {
	#this is where we mount stuff
	dodir /media

	# HAL informed mounter, used by Gnome/KDE
	dobin pmount-hal

	# Must be run SETUID
	exeinto /usr/bin
	exeopts -m 4710
	doexe pmount pumount
	fowners root:plugdev /usr/bin/pmount
	fowners root:plugdev /usr/bin/pumount

	dodoc AUTHORS CHANGES TODO
	doman pmount.1 pumount.1 pmount-hal.1

	insinto /etc
	doins pmount.allow
}

pkg_postinst() {
	einfo
	einfo "This package has been installed setuid.  The permissions are as such that"
	einfo "only users that belong to the plugdev group are allowed to run this."
	einfo
	einfo "Please add your user to the plugdev group to be able to mount USB drives"
}
