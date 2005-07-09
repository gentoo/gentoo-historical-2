# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libol/libol-0.3.16.ebuild,v 1.7 2005/07/09 04:58:40 corsair Exp $

inherit eutils

DESCRIPTION="Support library for syslog-ng"
HOMEPAGE="http://www.balabit.com/products/syslog_ng/"
SRC_URI="http://www.balabit.com/downloads/libol/0.3/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epunt_cxx
}

src_compile() {
	econf || die
	# why must people hard-code CFLAGS into configure?
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog
}
