# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/nlcvt/nlcvt-19990309.ebuild,v 1.2 2003/02/13 09:42:25 vapier Exp $

DESCRIPTION="A perl script to convert between various line terminators"
HOMEPAGE="http://www.perl.com/language/ppt/src/nlcvt/"
SRC_URI="http://www.perl.com/language/ppt/src/nlcvt/nlcvt
	http://www.perl.com/language/ppt/src/nlcvt/nlcvt.html"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86"

DEPEND="sys-devel/perl"

src_install() {
	dobin ${DISTDIR}/nlcvt
	dohtml ${DISTDIR}/nlcvt.html
}
