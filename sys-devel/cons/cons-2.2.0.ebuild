# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/cons/cons-2.2.0.ebuild,v 1.12 2005/05/24 16:01:05 mcummings Exp $

DESCRIPTION="Extensible perl-based build utility"
SRC_URI="http://www.dsmit.com/cons/stable/${P}.tgz"
HOMEPAGE="http://www.dsmit.com/cons/"

SLOT="2.2"
LICENSE="GPL-2"
KEYWORDS="x86 ppc ~sparc alpha"
IUSE=""

DEPEND="dev-lang/perl
	perl-core/Digest-MD5"

src_install() {
	dobin cons
	dodoc CHANGES COPYING COPYRIGHT INSTALL MANIFEST README RELEASE TODO
	dohtml *.html
	doman cons.1.gz
}
