# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/texi2html/texi2html-1.64-r1.ebuild,v 1.10 2004/11/11 18:16:19 corsair Exp $

inherit alternatives

DESCRIPTION="Perl script that converts Texinfo to HTML"
HOMEPAGE="http://www.mathematik.uni-kl.de/~obachman/Texi2html/"
SRC_URI="http://www.mathematik.uni-kl.de/~obachman/Texi2html/Distrib/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc sparc x86 ~ppc64"
IUSE=""

DEPEND="virtual/libc
	>=dev-lang/perl-5.6.1"

src_compile() {
	econf --program-suffix=-${PV} || die "Configuration Failed"
	emake || die "Parallel Make Failed"
}

src_install() {
	#yes, htmldir line is correct, no ${D}
	make DESTDIR=${D} \
		htmldir=/usr/share/doc/${PF}/html \
		install || die "Installation Failed"

	dodoc AUTHORS COPYING ChangeLog INSTALL INTRODUCTION NEWS \
		README TODO
}

pkg_postinst() {
	alternatives_auto_makesym "/usr/bin/texi2html" "/usr/bin/texi2html-*"
}
