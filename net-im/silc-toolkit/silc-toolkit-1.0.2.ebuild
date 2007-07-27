# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/silc-toolkit/silc-toolkit-1.0.2.ebuild,v 1.8 2007/07/27 17:04:23 jer Exp $

inherit eutils

DESCRIPTION="SDK for the SILC protocol"
HOMEPAGE="http://silcnet.org/"
SRC_URI="http://silcnet.org/download/toolkit/sources/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc sparc x86"
IUSE="debug ipv6"

RDEPEND=""
DEPEND="dev-util/pkgconfig"

src_unpack() {
	unpack ${A}

	# They have incorrect DESTDIR usage
	sed -i '/\$(srcdir)\/tutorial/s/\$(prefix)/\$(docdir)/' "${S}"/Makefile.{am,in}

	# Stop them from unsetting our CFLAGS
	sed -i '/^CFLAGS=$/d' "${S}"/configure
}

src_compile() {
	econf \
		--datadir=/usr/share/${PN} \
		--mandir=/usr/share/man \
		--includedir=/usr/include/${PN} \
		--with-etcdir=/etc/silc \
		--with-helpdir=/usr/share/${PN}/help \
		--with-simdir=/usr/$(get_libdir)/${PN} \
		--with-docdir=/usr/share/doc/${PF} \
		--with-logsdir=/var/log/${PN} \
		--enable-shared \
		--enable-static \
		$(use_enable debug) \
		$(use_enable ipv6)

	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"

	rm -rf \
		"${D}"/etc/${PN}/silcd.conf \
		"${D}"/usr/share/man \
		"${D}"/usr/share/doc/${PF}/examples \
		"${D}"/usr/share/silc-toolkit \
		"${D}"/var/log/silc-toolkit \
		"${D}"/etc/silc
}
