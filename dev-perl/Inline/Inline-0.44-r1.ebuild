# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Inline/Inline-0.44-r1.ebuild,v 1.13 2005/02/01 11:07:42 mcummings Exp $

inherit perl-module eutils

DESCRIPTION="Write Perl subroutines in other languages"
SRC_URI="http://www.cpan.org/authors/id/I/IN/INGY/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/doc/INGY/Inline-0.43/Inline.pod"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha hppa mips"
IUSE="gtk2"

DEPEND="${DEPEND}
	dev-perl/Digest-MD5
	dev-perl/File-Spec
	dev-perl/Parse-RecDescent
	dev-perl/Test-Harness"

src_unpack() {
	unpack ${P}.tar.gz

	cd ${S}
	#gtk-2 suggested patch
	if use gtk2
	then
		epatch ${FILESDIR}/gtk2-patch.diff
	fi

}

src_compile() {

	echo "y" | perl-module_src_compile
	perl-module_src_test
}


src_install () {

	perl-module_src_install
	dohtml DT.html
}
