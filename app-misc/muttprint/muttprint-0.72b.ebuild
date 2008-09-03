# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/muttprint/muttprint-0.72b.ebuild,v 1.3 2008/09/03 21:09:48 opfer Exp $

inherit eutils

DESCRIPTION="Script for pretty printing of your mails"
HOMEPAGE="http://muttprint.sf.net/"
SRC_URI="mirror://sourceforge/muttprint/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~alpha ~amd64 ~ia64 ~ppc ~ppc64"
IUSE=""

RDEPEND="virtual/latex-base
	dev-lang/perl
	dev-perl/TimeDate
	dev-perl/Text-Iconv
	dev-perl/File-Which
	app-text/psutils"

#src_unpack() {
#	unpack ${A} && cd ${S} || die
#	epatch ${FILESDIR}/${PN}-0.72a-platex.patch
#	make clean	# ia32 binaries included in distribution
#}

src_install() {
	make prefix="${D}"/usr docdir="${D}"/usr/share/doc docdirname=${P} install
}
