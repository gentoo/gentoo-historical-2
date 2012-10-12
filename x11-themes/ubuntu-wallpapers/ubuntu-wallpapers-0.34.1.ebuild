# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/ubuntu-wallpapers/ubuntu-wallpapers-0.34.1.ebuild,v 1.2 2012/10/12 18:37:04 ago Exp $

EAPI=4

DESCRIPTION="Ubuntu wallpapers."
HOMEPAGE="https://launchpad.net/ubuntu/+source/ubuntu-wallpapers"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${P/_/-}"

SLOT=0

src_compile() { :; }
src_test() { :; }

src_install() {
	insinto /usr/share/backgrounds
	doins *.jpg *.png

	insinto /usr/share/backgrounds/contest
	doins contest/*.xml

	for i in *.xml.in; do
		insinto /usr/share/gnome-background-properties
		newins ${i} ${i/.in/}
	done

	dodoc AUTHORS debian/changelog
}
