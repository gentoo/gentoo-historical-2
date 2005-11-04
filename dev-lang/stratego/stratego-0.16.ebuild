# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/stratego/stratego-0.16.ebuild,v 1.2 2005/11/04 13:54:17 karltk Exp $

inherit flag-o-matic

DESCRIPTION="Stratego term-rewriting language"
HOMEPAGE="http://www.stratego-language.org/"
SRC_URI="ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-${PV}/strategoxt-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
DEPEND=">=dev-libs/aterm-2.4.2
	>=dev-libs/sdf2-bundle-2.3.3"
S=${WORKDIR}/strategoxt-${PV}
IUSE=""

src_compile() {
	filter-flags -fomit-frame-pointer
	econf || die "econf failed"
	make || die
}

src_install() {
	make DESTDIR=${D} install || die

	insinto /etc/env.d
	doins ${FILESDIR}/42stratego
}
