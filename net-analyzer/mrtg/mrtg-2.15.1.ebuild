# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/mrtg/mrtg-2.15.1.ebuild,v 1.7 2007/05/17 20:20:34 armin76 Exp $

DESCRIPTION="A tool to monitor the traffic load on network-links"
HOMEPAGE="http://oss.oetiker.ch/mrtg/"
SRC_URI="http://oss.oetiker.ch/mrtg/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ppc ppc64 sparc x86"
IUSE=""

DEPEND="virtual/libc
	dev-lang/perl
	>=media-libs/gd-1.8.4"

src_install () {
	keepdir /var/lib/mrtg

	make DESTDIR="${D}" install || die "make install failed"
	mv "${D}"/usr/share/doc/mrtg2  "${D}"/usr/share/doc/${PF}

	newinitd "${FILESDIR}"/mrtg.rc ${PN}
	newconfd "${FILESDIR}"/mrtg.confd ${PN}

}

pkg_postinst(){
	elog "You must configure mrtg before being able to run it. Try cfgmaker."
	elog "The following thread may be useful:"
	elog "http://forums.gentoo.org/viewtopic-t-105862.html"
}
