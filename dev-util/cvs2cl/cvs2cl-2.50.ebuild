# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cvs2cl/cvs2cl-2.50.ebuild,v 1.3 2004/05/18 23:58:50 jhuebel Exp $

#ECVS_SERVER="cvs -d :pserver:anonymous@cvs.red-bean.com:/usr/local/cvs login"
#ECVS_PASS="the key"
#ECVS_MODULE="cvs2cl"
#inherit cvs

DESCRIPTION="produces a GNU-style ChangeLog for CVS-controlled sources"
HOMEPAGE="http://www.red-bean.com/cvs2cl/"
SRC_URI="mirror://gentoo/${P}.pl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

DEPEND="dev-lang/perl"

S=${WORKDIR}

src_unpack() {
	cp ${DISTDIR}/${A} .
}

src_install() {
	newbin ${A} ${PN}.pl
}
