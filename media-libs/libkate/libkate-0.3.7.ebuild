# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libkate/libkate-0.3.7.ebuild,v 1.2 2010/01/16 14:18:59 ssuominen Exp $

DESCRIPTION="Codec for karaoke and text encapsulation for Ogg"
HOMEPAGE="http://code.google.com/p/libkate/"
SRC_URI="http://libkate.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc wxwindows"

COMMON_DEPEND="media-libs/libogg
	media-libs/libpng"
DEPEND="${COMMON_DEPEND}
	wxwindows? ( dev-lang/python )
	dev-util/pkgconfig
	sys-devel/flex
	sys-devel/bison
	doc? ( app-doc/doxygen )"
RDEPEND="${COMMON_DEPEND}
	wxwindows? ( =dev-python/wxpython-2.8* media-libs/liboggz )"

src_compile() {
	use wxwindows || sed -i -e "s/HAVE_PYTHON=yes/HAVE_PYTHON=no/" configure
	econf $(use_enable doc) --docdir=/usr/share/doc/${PF}
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README
}
