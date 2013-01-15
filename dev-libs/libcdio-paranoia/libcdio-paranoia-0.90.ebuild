# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libcdio-paranoia/libcdio-paranoia-0.90.ebuild,v 1.2 2013/01/15 19:15:28 ssuominen Exp $

EAPI=5
MY_P=${PN}-10.2+${PV}
inherit autotools eutils

DESCRIPTION="an advanced CDDA reader with error correction"
HOMEPAGE="http://www.gnu.org/software/libcdio/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"

# COPYING-GPL from cdparanoia says "2 or later"
# COPYING-LGPL from cdparanoia says "2.1 or later"
LICENSE="GPL-2+ LGPL-2.1+ GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="+cxx static-libs test"

RDEPEND=">=${CATEGORY}/libcdio-${PV}
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-lang/perl )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-headers.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-maintainer-mode \
		--disable-example-progs \
		$(use_enable cxx) \
		--disable-cpp-progs \
		$(use_enable static-libs static) \
		--with-cd-paranoia-name=libcdio-paranoia
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README THANKS
	prune_libtool_files
}
