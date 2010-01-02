# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/luaexpat/luaexpat-1.1.ebuild,v 1.1 2010/01/02 12:10:38 djc Exp $

EAPI=2

inherit multilib toolchain-funcs flag-o-matic eutils

DESCRIPTION="LuaExpat is a SAX XML parser based on the Expat library."
HOMEPAGE="http://www.keplerproject.org/luaexpat/"
SRC_URI="http://luaforge.net/frs/download.php/2469/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1[deprecated]
	dev-libs/expat"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	sed -i -e "s#^LUA_LIBDIR=.*#LUA_LIBDIR=$(pkg-config --variable INSTALL_CMOD lua)#" "${S}/config"
	sed -i -e "s#^LUA_DIR=.*#LUA_DIR=$(pkg-config --variable INSTALL_LMOD lua)#" "${S}/config"
	sed -i -e "s#^LUA_INC=.*#LUA_INC=$(pkg-config --variable INSTALL_INC lua)#" "${S}/config"
	sed -i -e "s#^EXPAT_INC=.*#EXPAT_INC=/usr/include#" "${S}/config"
	sed -i -e "s#^LUA_VERSION_NUM=.*#LUA_VERSION_NUM=501#" "${S}/config"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	append-flags -fPIC
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) -shared" \
		|| die
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README || die
	dohtml -r doc/* || die
}
