# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/popt/popt-1.10.7.ebuild,v 1.10 2007/05/12 03:28:41 kumba Exp $

inherit eutils

DESCRIPTION="Parse Options - Command line parser"
HOMEPAGE="http://www.rpm.org/"
SRC_URI="ftp://jbj.org/pub/rpm-4.4.x/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.10.4-regression.patch
	epatch "${FILESDIR}"/${PN}-1.10.4-lib64.patch
	epatch "${FILESDIR}"/${PN}-1.10.7-scrub-lame-gettext.patch
}

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
