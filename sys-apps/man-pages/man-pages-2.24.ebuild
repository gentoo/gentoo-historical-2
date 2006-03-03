# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/man-pages/man-pages-2.24.ebuild,v 1.2 2006/03/03 02:09:31 vapier Exp $

inherit eutils

DESCRIPTION="A somewhat comprehensive collection of Linux man pages"
HOMEPAGE="http://www.win.tue.nl/~aeb/linux/man/"
SRC_URI="mirror://kernel/linux/docs/manpages/${P}.tar.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="nls"

RDEPEND="sys-apps/man"
PDEPEND="nls? (
	linguas_cs? ( app-i18n/man-pages-cs )
	linguas_da? ( app-i18n/man-pages-da )
	linguas_de? ( app-i18n/man-pages-de )
	linguas_es? ( app-i18n/man-pages-es )
	linguas_fr? ( app-i18n/man-pages-fr )
	linguas_it? ( app-i18n/man-pages-it )
	linguas_ja? ( app-i18n/man-pages-ja )
	linguas_nl? ( app-i18n/man-pages-nl )
	linguas_pl? ( app-i18n/man-pages-pl )
	linguas_ro? ( app-i18n/man-pages-ro )
	linguas_ru? ( app-i18n/man-pages-ru )
	linguas_zh_CN? ( app-i18n/man-pages-zh_CN )
	)"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.08-updates.patch
}

src_compile() { :; }

src_install() {
	make install prefix="${D}" || die
	dodoc man-pages-*.Announce README Changes* HOWTOHELP
}

pkg_postinst() {
	einfo "If you don't have a makewhatis cronjob, then you"
	einfo "should update the whatis database yourself:"
	einfo " # makewhatis -u"
}
