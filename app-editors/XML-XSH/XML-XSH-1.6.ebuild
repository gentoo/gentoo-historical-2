# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/XML-XSH/XML-XSH-1.6.ebuild,v 1.3 2004/05/31 22:12:03 vapier Exp $

inherit perl-module

DESCRIPTION="XML Editing Shell"
HOMEPAGE="http://xsh.sourceforge.net/"
SRC_URI="mirror://sourceforge/xsh/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=dev-perl/XML-LibXML-1.54
	dev-perl/Parse-RecDescent
	dev-perl/Text-Iconv
	dev-perl/XML-LibXSLT
	dev-perl/Term-ReadLine-Perl
	dev-perl/XML-XUpdate-LibXML"
