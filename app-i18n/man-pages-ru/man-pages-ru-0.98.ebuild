# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/man-pages-ru/man-pages-ru-0.98.ebuild,v 1.1 2005/09/02 04:28:58 vapier Exp $

DESCRIPTION="A collection of Russian translations of Linux manual pages"
HOMEPAGE="http://www.linuxshare.ru/projects/trans/mans.html"
SRC_URI="http://www.linuxshare.ru/projects/trans/manpages-ru-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/man"

S=${WORKDIR}/manpages-ru-${PV}

src_install() {
	insinto /usr/share/man/ru
	doins -r man* || die "doins"
	dodoc CREDITS FAQ NEWS
}
