# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gpsdrive/gpsdrive-2.03.ebuild,v 1.4 2003/11/11 15:43:40 hillster Exp $

S=${WORKDIR}/${P}
DESCRIPTION="displays GPS position on a map"
HOMEPAGE="http://gpsdrive.kraftvoll.at/"
SRC_URI="http://gpsdrive.kraftvoll.at/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc ~sparc ~alpha ~hppa ~mips ~arm"

IUSE="nls"
DEPEND="sys-devel/gettext
	>=x11-libs/gtk+-2.0
	>=dev-libs/libpcre-4.2"


src_unpack() {
	unpack ${A}
	cd ${S}
	#mv configure configure.orig
	#sed -e "s:^CFLAGS=\"-O2 -Wall\":CFLAGS=${CFLAGS}:" \
		#-e "s:^CXXFLAGS=\"\$CFLAGS\":CXXFLAGS=${CXXFLAGS}:" \
		##configure.orig > configure
	#chmod +x configure

}

src_compile() {
	econf `use_enable nls`
	emake || die

}

src_install() {
	make DESTDIR=${D} install || die
}
