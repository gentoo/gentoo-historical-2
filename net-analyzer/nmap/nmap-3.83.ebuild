# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nmap/nmap-3.83.ebuild,v 1.9 2005/10/02 02:30:38 kloeri Exp $

inherit eutils flag-o-matic

DESCRIPTION="A utility for network exploration or security auditing"
HOMEPAGE="http://www.insecure.org/presentations/Defcon13/NmapRelease"
SRC_URI="http://www.insecure.org/presentations/Defcon13/NmapRelease/${P}.DC13.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ~ppc-macos ppc64 s390 sh sparc x86"
IUSE="gtk ssl"

DEPEND="virtual/libc
	dev-libs/libpcre
	gtk? ( =x11-libs/gtk+-1.2* )
	ssl? ( dev-libs/openssl )"

S="${WORKDIR}/${P}.DC13"

src_compile() {
	use ppc-macos && filter-flags -fstrict-aliasing -O2
	econf \
		$(use_with gtk nmapfe) \
		$(use_with ssl openssl) || die
	emake -j1 || die
}

src_install() {
	einstall -j1 nmapdatadir=${D}/usr/share/nmap install || die
	dodoc CHANGELOG HACKING INSTALL docs/README docs/*.txt
	dohtml docs/*.html
}
