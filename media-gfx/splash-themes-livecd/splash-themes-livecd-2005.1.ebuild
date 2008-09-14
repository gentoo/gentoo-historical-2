# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/splash-themes-livecd/splash-themes-livecd-2005.1.ebuild,v 1.6 2008/09/14 11:44:30 spock Exp $

MY_P="gentoo-livecd-${PV}"
MY_REV="0.9.2"
DESCRIPTION="Gentoo theme for gensplash consoles"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~wolf31o2/sources/${PN}/${MY_P}-${MY_REV}.tar.bz2"

SLOT=${PV}
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=">=media-gfx/splashutils-1.1.9.7"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e '/^\/bin\/umount -l "\/etc\/splash\/${SPLASH_THEME}"$/s/^\(.*\)$/\1 \&>\/dev\/null/' scripts/rc_exit-post
	sed -i -e 's-/sbin/functions.sh-/etc/init.d/functions.sh-' scripts/rc_init-pre
}

src_install() {
	dodir /etc/splash/livecd-${PV}
	cp -r "${S}"/* "${D}"/etc/splash/livecd-${PV}
}
