# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/slv2/slv2-0.6.1.ebuild,v 1.1 2008/11/20 10:14:08 aballier Exp $

EAPI=2

inherit multilib toolchain-funcs

DESCRIPTION="A library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="http://wiki.drobilla.net/SLV2"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc jack"

RDEPEND=">=dev-libs/redland-1.0.6
	jack? ( >=media-sound/jack-audio-connection-kit-0.107.0 )
	media-libs/lv2core"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig"

src_configure() {
	tc-export CC CXX CPP AR RANLIB
	# any better idea?
	use jack || sed -i -e "s/jack/nojack/" wscript
	./waf configure \
		  --prefix=/usr \
		  --libdir=/usr/$(get_libdir)/ \
		  --htmldir=/usr/share/doc/${PF}/html \
		  $(use doc && echo "--build-docs") \
		  || die "failed to configure"
}

src_compile() {
	./waf || die "failed to build"
}

src_install() {
	./waf --destdir="${D}" install || die "install failed"
	dodoc AUTHORS README ChangeLog
}
