# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gmetadom/gmetadom-0.2.2.ebuild,v 1.1 2005/01/03 07:27:40 matsuu Exp $

inherit flag-o-matic eutils

DESCRIPTION="A library providing bindings for multiple languages of multiple C DOM implementations"
HOMEPAGE="http://gmetadom.sourceforge.net/"
SRC_URI="mirror://sourceforge/gmetadom/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="ocaml"

RDEPEND=">=dev-libs/gdome2-0.8.0"
DEPEND="${RDEPEND}
	>=dev-libs/libxslt-1.0.0
	ocaml? ( >=dev-lang/ocaml-3.05
		>=dev-ml/findlib-0.8 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-0.2.1-gentoo.patch
}

src_compile() {
	local mymod="gdome_cpp_smart"

	# Unconditonal use of -fPIC (#55238).
	append-flags -fPIC
	use ocaml && mymod="${mymod} gdome_caml"

	econf --with-modules="${mymod}" || die
	#emake || die
	make || die
}

src_install() {
	local destdir=`ocamlfind printconf destdir`

	make \
		DESTDIR=${D} \
		OCAMLINSTALLDIR=${D}${destdir}/gdome2 \
		OCAMLFIND_LDCONF=dummy \
		install || die

	dodoc AUTHORS BUGS ChangeLog HISTORY LICENSE NEWS README
}
