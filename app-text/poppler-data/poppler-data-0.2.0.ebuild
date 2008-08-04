# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/poppler-data/poppler-data-0.2.0.ebuild,v 1.3 2008/08/04 23:45:53 gentoofan23 Exp $

DESCRIPTION="Data files for poppler to support uncommon encodings without xpdfrc"
HOMEPAGE="http://poppler.freedesktop.org/"
SRC_URI="http://poppler.freedesktop.org/${P}.tar.gz"

LICENSE="adobe-ps MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake prefix=/usr DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
