# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gcal/gcal-3.01-r3.ebuild,v 1.1 2009/02/26 21:41:23 ulm Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="The GNU Calendar - a replacement for cal"
HOMEPAGE="http://www.gnu.org/software/gcal/gcal.html"
SRC_URI="mirror://gnu/gcal/${P}.tar.gz
	mirror://gentoo/${P}-iso3166.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="ncurses nls"

DEPEND="nls? ( >=sys-devel/gettext-0.17 )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-mandir.diff
	epatch "${FILESDIR}"/${P}-gettext-charset.patch
	epatch "${WORKDIR}"/${P}-iso3166.patch
	find -name Makefile.in -print0 | \
		xargs -0 -n1 sed -i "s:\(^CC = \).*:\1$(tc-getCC):"
}

src_compile() {
	append-flags -D_GNU_SOURCE
	econf $(use_enable nls) $(use_enable ncurses)
	emake || die
}

src_install() {
	einstall || die
	rm -f "${D}"/usr/share/locale/locale.alias

	dodoc ATTENTION BUGS DISCLAIM HISTORY LIMITATIONS MANIFEST NEWS README \
				SYMBOLS THANKS TODO

	# Need to fix up paths for scripts in misc directory
	# that are automatically created by the makefile
	for miscfile in "${D}"/usr/share/gcal/misc/*/*
	do
		dosed "s:${D%/}::g" "${miscfile/${D}}"
	done

	# Rebuild the symlinks that makefile created into the image /usr/bin
	# directory during make install
	dosym /usr/share/gcal/misc/daily/daily /usr/bin/gcal-daily
	dosym /usr/share/gcal/misc/ddiff/ddiff /usr/bin/gcal-ddiff
	dosym /usr/share/gcal/misc/ddiff/ddiffdrv /usr/bin/gcal-ddiffdrv
	dosym /usr/share/gcal/misc/dst/dst /usr/bin/gcal-dst
	dosym /usr/share/gcal/misc/gcalltx/gcalltx /usr/bin/gcal-gcalltx
	dosym /usr/share/gcal/misc/gcalltx/gcalltx.pl /usr/bin/gcal-gcalltx.pl
	dosym /usr/share/gcal/misc/moon/moon /usr/bin/gcal-moon
	dosym /usr/share/gcal/misc/mrms/mrms /usr/bin/gcal-mrms
	dosym /usr/share/gcal/misc/srss/srss /usr/bin/gcal-srss
	dosym /usr/share/gcal/misc/wloc/wlocdrv /usr/bin/gcal-wlocdrv
}
