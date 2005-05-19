# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/wxactivex/wxactivex-1.0.ebuild,v 1.1 2005/05/19 01:42:36 pythonhead Exp $

inherit eutils

DESCRIPTION="wxActiveX is a wxWidgets ActiveX extension for the xmingw cross-compiler"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.zip"
HOMEPAGE="http://sourceforge.net/projects/${PN}"

SLOT="0"
KEYWORDS="~x86"
IUSE=""
LICENSE="BSD"
DEPEND=">=dev-libs/wx-xmingw-2.4.2"
S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-1.0-gentoo.patch
}

src_compile() {
	export PATH="/opt/xmingw/bin:/opt/xmingw/i386-mingw32msvc/bin:/opt/xmingw/wxWidgets/bin:$PATH"
	export CC="i386-mingw32msvc-gcc"
	export CXX="i386-mingw32msvc-g++"

	unset CFLAGS
	unset CPPFLAGS
	unset CXXFLAGS
	unset LDFLAGS

	export CFLAGS="-I/opt/xmingw/i386-mingw32msvc/include"
	export CXXFLAGS="-I/opt/xmingw/i386-mingw32msvc/include"


	emake CC=${CXX} || die "make failed"
}

src_install() {
	cd ${WORKDIR}
	make prefix=${D}/opt/xmingw/wxActiveX install || die "install failed"
}

