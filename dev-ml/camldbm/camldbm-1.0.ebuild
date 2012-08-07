# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/camldbm/camldbm-1.0.ebuild,v 1.1 2012/08/07 19:31:34 aballier Exp $

EAPI=4

inherit base

DESCRIPTION="OCaml binding to the NDBM/GDBM Unix databases"
HOMEPAGE="http://forge.ocamlcore.org/projects/camldbm/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/728/${P}.tgz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="|| ( >=sys-libs/gdbm-1.9.1-r2[berkdb] <sys-libs/gdbm-1.9.1-r2 )
	dev-lang/ocaml
	!<dev-lang/ocaml-4[gdbm]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/hasgotfix.patch" "${FILESDIR}/include_fix.patch" )

src_install() {
	dodir "$(ocamlc -where)/stublibs" # required and makefile does not create it
	emake LIBDIR="${D}/$(ocamlc -where)" install
	dodoc README Changelog
}
