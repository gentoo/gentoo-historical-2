# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/shtool/shtool-1.5.1-r2.ebuild,v 1.11 2004/06/25 02:46:48 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A compilation of small but very stable and portable shell scripts into a single shell tool"
SRC_URI="ftp://ftp.gnu.org/gnu/shtool/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/shtool/shtool.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ia64"

DEPEND=">=dev-lang/perl-5.6"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	einstall || die
	dodoc AUTHORS ChangeLog COPYING README THANKS VERSION
}
