# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Curses/Curses-1.13.ebuild,v 1.8 2006/07/04 07:08:23 ian Exp $

inherit perl-module eutils

MY_PV=${PV/8/8b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Curses interface modules for Perl"
HOMEPAGE="http://search.cpan.org/~giraffed/${MY_P}/"
SRC_URI="mirror://cpan/authors/id/G/GI/GIRAFFED/${MY_P}.tgz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND=">=sys-libs/ncurses-5"
RDEPEND="${DEPEND}"

myconf="${myconf} GEN PANELS MENUS"

#This patch may or may not be backwards compatible with perl-5.6.1
#Add gaurd as necessary...
src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/Curses-1.08-p5.8-fixes.diff
	cd ${S}
	einfo "Copying hints/c-linux.ncurses.h to c-config.h"
	cp ${S}/hints/c-linux.ncurses.h ${S}/c-config.h
}