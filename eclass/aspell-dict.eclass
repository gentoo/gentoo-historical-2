# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author: Seemant Kulleen <seemant@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/aspell-dict.eclass,v 1.7 2002/10/25 19:55:52 vapier Exp $

# The aspell-dict eclass is designed to streamline the construction of
# ebuilds for the new aspell dictionaries (from gnu.org) which support
# aspell-0.50

ECLASS=aspell-dict
INHERITED="${INHERITED} ${ECLASS}"

EXPORT_FUNCTIONS src_compile src_install

MY_P=${PN}-${PV%.*}-${PV#*.*.}
S=${WORKDIR}/${MY_P}
DESCRIPTION="${ASPELL_LANG} language dictionary for aspell"
HOMEPAGE="http://www.gnu.org/projects/aspell/index.html"
SRC_URI="ftp://ftp.gnu.org/gnu/aspell/${MY_P}.tar.bz2"

DEPEND=">=app-text/aspell-0.50"

SLOT="0"
KEYWORDS="x86 ppc sparc sparc64"

aspell-dict_src_compile() {
	./configure || die
	emake || die
}

aspell-dict_src_install() {

	make DESTDIR=${D} install || die

	dodoc Copyright README info
}
