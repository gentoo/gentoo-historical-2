# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/zoo/zoo-2.10-r1.ebuild,v 1.1 2006/02/23 21:39:23 smithj Exp $

inherit eutils

DESCRIPTION="Manipulate archives of files in compressed form."
SRC_URI="ftp://ftp.kiarchive.ru/pub/unix/arcers/${P}pl1.tar.gz"
HOMEPAGE="ftp://ftp.kiarchive.ru/pub/unix/arcers"

SLOT="0"
LICENSE="zoo"
IUSE=""
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc x86"

S=${WORKDIR}

src_unpack() {
	unpack ${P}pl1.tar.gz
	epatch ${FILESDIR}/${P}-gcc33-issues-fix.patch
	epatch ${FILESDIR}/${PN}-security-fix.patch
}

src_compile() {
	emake linux || die
}

src_install() {
	dobin zoo fiz
	doman zoo.1 fiz.1
}
