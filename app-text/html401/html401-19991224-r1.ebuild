# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/html401/html401-19991224-r1.ebuild,v 1.3 2003/02/13 09:38:48 vapier Exp $

inherit sgml-catalog

DESCRIPTION="DTDs for the HyperText Markup Language 4.01"
HOMEPAGE="http://www.w3.org/TR/${PN}/"
SRC_URI="${HOMEPAGE}html40.tgz"
S=${WORKDIR}
LICENSE="W3C"
SLOT="0"
KEYWORDS="x86"
DEPEND="app-text/sgml-common"

src_install() {
	insinto /usr/share/sgml/${PN}
	doins HTML4.cat HTML4.decl *.dtd *.ent
	insinto /etc/sgml
	dohtml *.html */*
}

sgml-catalog_cat_include "/etc/sgml/${PN}.cat" \
	"/usr/share/sgml/${PN}/HTML4.cat"
