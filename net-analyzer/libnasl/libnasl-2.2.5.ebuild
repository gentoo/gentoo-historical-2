# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/libnasl/libnasl-2.2.5.ebuild,v 1.3 2005/10/01 17:03:37 metalgod Exp $

inherit toolchain-funcs

DESCRIPTION="A remote security scanner for Linux (libnasl)"
HOMEPAGE="http://www.nessus.org/"
SRC_URI="ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

DEPEND="=net-analyzer/nessus-libraries-${PV}"

S="${WORKDIR}/${PN}"

src_compile() {
	export CC="$(tc-getCC)"
	econf || die "configuration failed"
	# emake fails for >= -j2. bug #16471.
	emake -C nasl cflags
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed libnasl"
}
