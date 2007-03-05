# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-ssl/ocaml-ssl-0.4.1.ebuild,v 1.1 2007/03/05 18:34:49 aballier Exp $

inherit findlib eutils

IUSE="doc"

DESCRIPTION="OCaml bindings for OpenSSL."
SRC_URI="mirror://sourceforge/savonet/${P}.tar.gz"
HOMEPAGE="http://savonet.sourcforge.net/wiki/OCamlLibs"

DEPEND="dev-libs/openssl"

RDEPEND="$DEPEND"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"

src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	findlib_src_preinst
	emake install || die

	if use doc; then
		dohtml -r doc/html/*
	fi
	dodoc CHANGES README
}
