# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gip/gip-1.0.0.1.ebuild,v 1.1.1.1 2005/11/30 09:54:54 chriswhite Exp $

inherit versionator

MY_P="${PN}-$(replace_version_separator 3 '-')"
DESCRIPTION="A nice GNOME GUI for making IP address based calculations"
HOMEPAGE="http://www.debain.org/software/gip/"
SRC_URI="http://web222.mis02.de/releases/gip/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND="=dev-cpp/gtkmm-2.2*
	>=dev-libs/glib-2.2.3
	=dev-libs/libsigc++-1.2*"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	sed -i -e s/"*matches\["/"*matches\[1+"/g ${S}/src/lib_ipv4.c
}

src_compile() {
	./build.sh --prefix ${D}/usr || die "./build failed"
}

src_install() {
	dodoc AUTHORS INSTALL README
	./build.sh --install --prefix ${D}/usr || die "./build --install failed"
}
