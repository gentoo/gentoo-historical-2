# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mhonarc/mhonarc-2.6.10.ebuild,v 1.1 2004/08/21 20:43:39 kumba Exp $

inherit perl-module

IUSE=""

SRC_URI="http://www.mhonarc.org/tar/${P/mhonarc/MHonArc}.tar.bz2"
RESTRICT="nomirror"

DESCRIPTION="Perl Mail-to-HTML Converter"
HOMEPAGE="http://www.mhonarc.org/"
LICENSE="GPL-2"
CATEGORY="net-mail"

SLOT="0"
KEYWORDS="x86 ~ppc sparc ~alpha mips ~amd64"

S="${WORKDIR}/${P/mhonarc/MHonArc}"

src_install() {
	mv ${S}/Makefile ${S}/Makefile.orig
	sed -e "s:/usr:${D}/usr:g" -e "s:${D}/usr/bin/perl:/usr/bin/perl:g" \
		${S}/Makefile.orig > ${S}/Makefile
	perl-module_src_install
}
