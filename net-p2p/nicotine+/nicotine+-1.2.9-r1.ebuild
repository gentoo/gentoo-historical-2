# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/nicotine+/nicotine+-1.2.9-r1.ebuild,v 1.1 2008/03/31 14:24:54 coldwind Exp $

inherit distutils eutils multilib toolchain-funcs

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="http://nicotine-plus.sourceforge.net"
SRC_URI="mirror://sourceforge/nicotine-plus/${P}.tar.bz2"
LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="geoip spell vorbis"

RDEPEND="virtual/python
	>=dev-python/pygtk-2
	vorbis? ( >=dev-python/pyvorbis-1.4-r1
			  >=dev-python/pyogg-1 )
	geoip? ( >=dev-python/geoip-python-0.2.0
			 >=dev-libs/geoip-1.2.1 )
	spell? ( dev-python/sexy-python )
	!net-p2p/nicotine"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-locale-handling.patch
}

src_compile() {
	distutils_src_compile

	cd "${S}"/trayicon/
	sed -i -e "s:/lib/:/$(get_libdir)/:" \
		Makefile.in || die "sed failed"
	./autogen.py
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	distutils_python_version
	distutils_src_install --install-lib \
		/usr/$(get_libdir)/python${PYVER}/site-packages

	cd "${S}"/trayicon/
	emake DESTDIR="${D}" install || die "emake install failed"
}
