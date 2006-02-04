# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocamlweb/ocamlweb-1.37.ebuild,v 1.1 2006/02/04 17:05:19 mattam Exp $

DESCRIPTION="O'Caml literate programming tool"
HOMEPAGE="http://www.lri.fr/~filliatr/ocamlweb/"
SRC_URI="http://www.lri.fr/~filliatr/ftp/ocamlweb/${P}.tar.gz"

IUSE=""

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

DEPEND=">=dev-lang/ocaml-3.09
virtual/tetex"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	emake UPDATETEX="" prefix=${D}/usr MANDIR=${D}/usr/share/man install || die
	dodoc README COPYING CHANGES
}

tex_regen() {
	einfo "Regenerating TeX database..."
	/usr/bin/mktexlsr /usr/share/texmf /var/spool/texmf > /dev/null
	eend $?
}

pkg_postinst() {
	tex_regen
}

pkg_postrm() {
	tex_regen
}
