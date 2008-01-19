# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/fcitx/fcitx-3.1.1.ebuild,v 1.9 2008/01/19 01:13:34 matsuu Exp $

DESCRIPTION="Free Chinese Input Toy for X. Another Chinese XIM Input Method"
HOMEPAGE="http://www.fcitx.org/"
SRC_URI="http://www.fcitx.org/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE="truetype"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXt
	truetype? ( || ( x11-libs/libXft virtual/xft ) )"

DEPEND="${RDEPEND}"
src_compile() {
	myconf=
	if use truetype ; then
		myconf=" --with-xft "
	else
		myconf=" --disable-xft "
	fi
	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install()
{
	dobin src/fcitx
	insinto /usr/share/fcitx/data
	doins data/*.mb
	doins data/*.dat
	doins data/*.conf
	insinto /usr/share/fcitx/xpm
	doins xpm/*.xpm
	insinto /usr/share/fcitx/doc
	doins doc/*.txt
	doins doc/*.htm
}

pkg_postinst()
{
	elog "You should export the following variables to use fcitx"
	elog " export XMODIFIERS=\"@im=fcitx\""
	elog " export XIM=fcitx"
	elog " export XIM_PROGRAM=fcitx"
	elog ""
	elog "If you want to use WuBi or ErBi"
	elog " cp /usr/share/fcitx/data/wbx.mb ~/.fcitx"
	elog " cp /usr/share/fcitx/data/erbi.mb ~/.fcitx"
	elog " cp /usr/share/fcitx/data/tables.conf ~/.fcitx"
	elog ""
	elog "Note that fcitx only works in the zh_CN locale."
}
