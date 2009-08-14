# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/nasm/nasm-2.07.ebuild,v 1.2 2009/08/14 20:33:26 maekke Exp $

EAPI=2
inherit autotools eutils toolchain-funcs flag-o-matic

DESCRIPTION="groovy little assembler"
HOMEPAGE="http://nasm.sourceforge.net/"
SRC_URI="http://www.nasm.us/pub/nasm/releasebuilds/${PV/_}/${P/_}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* amd64 x86 ~x86-fbsd"
IUSE="doc"

DEPEND="dev-lang/perl
	doc? ( virtual/ghostscript sys-apps/texinfo )"
RDEPEND=""

S=${WORKDIR}/${P/_}

src_configure() {
	strip-flags
	econf
}

src_compile() {
	emake all || die "emake failed"
	emake rdf || die "emake failed"
	if use doc ; then
		emake doc || die "emake failed"
	fi
}

src_install() {
	dobin nasm ndisasm rdoff/{ldrdf,rdf2bin,rdf2ihx,rdfdump,rdflib,rdx} \
		|| die "dobin failed"
	dosym /usr/bin/rdf2bin /usr/bin/rdf2com
	doman nasm.1 ndisasm.1
	dodoc AUTHORS CHANGES ChangeLog README TODO
	if use doc ; then
		doinfo doc/info/*
		dohtml doc/html/*
		dodoc doc/nasmdoc.*
	fi
}
