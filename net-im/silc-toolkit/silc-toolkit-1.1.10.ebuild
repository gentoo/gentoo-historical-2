# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/silc-toolkit/silc-toolkit-1.1.10.ebuild,v 1.5 2010/04/23 19:45:05 armin76 Exp $

EAPI=2

inherit eutils

DESCRIPTION="SDK for the SILC protocol"
HOMEPAGE="http://silcnet.org/"
SRC_URI="http://silcnet.org/download/toolkit/sources/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 ~mips ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="debug ipv6"

RDEPEND=""
DEPEND="dev-util/pkgconfig"

src_prepare() {
	# They have incorrect DESTDIR usage
	sed -i \
		"s/^\(pkgconfigdir =\) \$(libdir)\/pkgconfig/\1	\/usr\/$(get_libdir)\/pkgconfig/"\
		"${S}"/lib/Makefile.{am,in}
}

src_configure() {
	econf \
		--datadir=/usr/share/${PN} \
		--datarootdir=/usr/share/${PN} \
		--includedir=/usr/include/${PN} \
		--sysconfdir=/etc/silc \
		--libdir=/usr/$(get_libdir)/${PN} \
		--docdir=/usr/share/doc/${PF} \
		--disable-optimizations \
		--with-simdir=/usr/$(get_libdir)/${PN}/modules \
		$(use_enable debug) \
		$(use_enable ipv6)
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failed"
}
