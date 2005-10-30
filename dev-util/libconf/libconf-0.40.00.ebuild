# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/libconf/libconf-0.40.00.ebuild,v 1.5 2005/10/30 03:26:42 weeve Exp $

IUSE=""

MY_P=perl-${PN/l/L}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Centralized abstraction layer for system configuration files"
HOMEPAGE="http://libconf.net/"
SRC_URI="http://libconf.net/download/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha ~amd64 ia64 ppc ppc64 sparc x86"

DEPEND="dev-lang/perl
dev-perl/DelimMatch
xml? ( dev-perl/Data-DumpXML )"

src_compile() {
	emake || die "make failed"
	make test || die "make test failed"
}

src_install() {
	einstall PREFIX=${D}/usr
	dodoc AUTHORS COPYING ChangeLog
}
