# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xmlformat/xmlformat-1.03.ebuild,v 1.2 2004/09/04 23:20:22 dholm Exp $

DESCRIPTION="Reformat XML documents to your custom style"
SRC_URI="http://www.kitebird.com/software/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.kitebird.com/software/xmlformat/"

SLOT="0"
LICENSE="xmlformat"
KEYWORDS="~x86 ~ppc"

DEPEND="ruby? ( virtual/ruby )
	!ruby? ( dev-lang/perl )"
IUSE="ruby doc"

src_install() {
	dobin xmlformat.pl

	if use ruby
	then
		dobin xmlformat.rb
		dosym /usr/bin/xmlformat.rb /usr/bin/xmlformat
	else
		dosym /usr/bin/xmlformat.pl /usr/bin/xmlformat
	fi

	dodoc BUGS ChangeLog LICENSE README TODO

	if use doc
	then
		# APIs
		cp -R docs/* ${D}/usr/share/doc/${PF}
	fi
}

src_test() {
	if use ruby
	then
		./runtest all || die "runtest for ruby failed."
	else
		./runtest -p all || die "runtest for perl failed."
	fi
}
