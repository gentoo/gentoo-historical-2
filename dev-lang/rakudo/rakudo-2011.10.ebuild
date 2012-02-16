# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/rakudo/rakudo-2011.10.ebuild,v 1.3 2012/02/16 08:16:56 patrick Exp $

EAPI=3

PARROT_VERSION="3.9.0"
NQP_VERSION="${PV}"

inherit eutils multilib

DESCRIPTION="A Perl 6 implementation built on the Parrot virtual machine"
HOMEPAGE="http://rakudo.org/"
SRC_URI="mirror://github/${PN}/${PN}/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-lang/parrot-${PARROT_VERSION}[unicode]
	>=dev-lang/nqp-${NQP_VERSION}"
DEPEND="${RDEPEND}
	dev-lang/perl"
#	>=dev-lang/perl-5.10"

src_prepare() {
	sed -i "s,\$(DOCDIR)/rakudo$,&-${PVR}," tools/build/Makefile.in || die
}

src_configure() {
	perl Configure.pl || die
}

src_test() {
	emake -j1 test || die
}

src_install() {
	emake DESTDIR="${ED}" install || die

	dodoc CREDITS README docs/ChangeLog docs/ROADMAP || die

	if use doc; then
		dohtml -A svg docs/architecture.html docs/architecture.svg || die
		dodoc docs/*.pod || die
		docinto announce
		dodoc docs/announce/* || die
	fi
}
