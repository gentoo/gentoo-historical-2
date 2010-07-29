# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cdebootstrap/cdebootstrap-0.5.6.ebuild,v 1.1 2010/07/29 17:21:35 darkside Exp $

EAPI=2

DESCRIPTION="Debian/Ubuntu bootstrap scripts written in C"
HOMEPAGE="http://packages.qa.debian.org/c/cdebootstrap.html"
SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${PV}.tar.gz
	mirror://debian/pool/main/d/debian-archive-keyring/debian-archive-keyring_2009.01.31.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="app-arch/dpkg
	dev-libs/libdebian-installer"
RDPEND="app-crypt/gnupg
	net-misc/wget"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc doc/* debian/changelog debian/NEWS || die

	# Install the keyrings
	cd "${S}"
	insinto /usr/share/keyrings
	doins debian-archive-keyring-2009.01.31/keyrings/*.gpg || die
}
