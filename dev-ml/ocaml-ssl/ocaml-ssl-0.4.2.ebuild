# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-ssl/ocaml-ssl-0.4.2.ebuild,v 1.6 2008/09/25 12:11:58 aballier Exp $

inherit findlib eutils

IUSE="doc"

DESCRIPTION="OCaml bindings for OpenSSL."
SRC_URI="mirror://sourceforge/savonet/${P}.tar.gz"
HOMEPAGE="http://savonet.sourceforge.net/wiki/OCamlLibs"

DEPEND="dev-libs/openssl"

RDEPEND="$DEPEND"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

src_compile() {
	econf || die "configure failed"
	emake -j1 || die "make failed"
}

src_install() {
	findlib_src_preinst
	emake install || die "make install failed"

	if use doc; then
		dohtml -r doc/html/*
	fi
	dodoc CHANGES README
}
