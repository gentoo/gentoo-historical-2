# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvacm4/dvacm4-0.3.5.ebuild,v 1.4 2004/07/02 04:37:21 eradicator Exp $

DESCRIPTION="dvacm4 provides autoconf macros used by the dv* C++ utilities"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvacm4/"
SRC_URI="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvacm4/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="x86 ppc sparc ppc64 ia64 amd64"
IUSE=""

DEPEND="virtual/libc"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
