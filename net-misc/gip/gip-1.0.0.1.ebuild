# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gip/gip-1.0.0.1.ebuild,v 1.3 2004/07/08 23:41:41 mr_bones_ Exp $

MY_PV=`echo ${PV} | sed -e 's/.\([0-9]\+\)$/-\1/' 2>/dev/null`
MY_P="${PN}-${MY_PV}"
DESCRIPTION="a nice GNOME GUI for making IP address based calculations"
HOMEPAGE="http://www.debain.org/?session=&site=2&project=19&cat=56"
SRC_URI="http://web222.mis02.de/releases/gip/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND="dev-cpp/gtkmm
	>=dev-libs/glib-2.2.3"
#RDEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	sed -i -e s/"*matches\["/"*matches\[1+"/g ${S}/src/lib_ipv4.c
}

src_compile() {
	./build.sh --prefix ${D}/usr || die "./build failed"
}

src_install() {
	dodoc AUTHORS COPYING INSTALL README
	./build.sh --install --prefix ${D}/usr || die "./build --install failed"
}
