# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pbuilder/pbuilder-0.99.ebuild,v 1.8 2005/01/27 14:05:09 lanius Exp $

DESCRIPTION="personal package builder for Debian packages"
HOMEPAGE="http://packages.qa.debian.org/p/pbuilder.html"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc"
SRC_URI="mirror://debian/pool/main/p/pbuilder/pbuilder_${PV}.tar.gz"

S=${WORKDIR}/${PN}

DEPEND=">=sys-apps/debianutils-1.13.1
	net-misc/wget
	dev-util/debootstrap
	app-arch/dpkg
	uml? (
		dev-util/rootstrap
		sys-apps/usermode-utilities
		)"

IUSE="uml"

src_install() {
	make DESTDIR=${D} install
	dodoc AUTHORS COPYING ChangeLog README THANKS

	if use uml && use x86; then
		doman pdebuild-user-mode-linux.1 pbuilder-user-mode-linux.1
	else
		cd ${D}
		rm -f etc/pbuilder/pbuilder-uml.conf
		rm -f usr/share/pbuilder/pbuilder-uml.conf
		rm -f usr/bin/pbuilder-user-mode-linux
		rm -f usr/bin/pdebuild-user-mode-linux
	fi
}
