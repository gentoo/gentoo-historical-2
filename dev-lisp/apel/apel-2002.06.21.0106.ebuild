# Copyright 2002 moto kawasaki <kawasaki@kawasaki3.org>
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/apel/apel-2002.06.21.0106.ebuild,v 1.1 2002/06/26 01:27:31 george Exp $

Name=`echo ${P} | sed -e 's#\.##g'`
A="${Name}.tar.gz"
S="${WORKDIR}/${Name}"

DESCRIPTION="A Portable Emacs Library -- apel"
SRC_URI="ftp://ftp.m17n.org/pub/mule/apel/snapshots/${A}"
HOMEPAGE="http://www.m17n.org/apel/"

DEPEND="emacs"
RDEPEND="${DEPEND}"

SLOT="0"
LICENSE=""

src_compile() {
	cd ${S};

	make || die
}

src_install() {
	make PREFIX=${D}/usr install || die

	dodoc ChangeLog README* APEL* EMU-ELS
}
