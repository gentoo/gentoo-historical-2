# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/popt/popt-1.14.ebuild,v 1.7 2009/10/03 19:00:41 klausman Exp $

inherit eutils

DESCRIPTION="Parse Options - Command line parser"
HOMEPAGE="http://rpm5.org/"
SRC_URI="http://rpm5.org/files/popt/${P}.tar.gz"

LICENSE="popt"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	econf \
		--without-included-gettext \
		$(use_enable nls) \
		|| die
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc CHANGES README
}
