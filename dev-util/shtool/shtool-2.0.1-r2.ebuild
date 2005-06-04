# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/shtool/shtool-2.0.1-r2.ebuild,v 1.3 2005/06/04 09:08:50 kloeri Exp $

inherit eutils

DESCRIPTION="A compilation of small but very stable and portable shell scripts into a single shell tool"
SRC_URI="ftp://ftp.gnu.org/gnu/shtool/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/shtool/shtool.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ia64 ~ppc sparc x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.6"

src_unpack() {
	unpack ${A} && cd ${S}
	# security bug 93782
	epatch ${FILESDIR}/${PF}-fix-insecure-tmp-creation.diff
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog COPYING README THANKS VERSION NEWS RATIONAL
}
