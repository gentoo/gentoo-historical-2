# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm-crystal/fvwm-crystal-2.20040723.ebuild,v 1.2 2005/01/15 19:34:40 lucass Exp $

MY_P="${P/-2./-}"
DESCRIPTION="Configurable and full featured theme for FVWM, with lots of transparency."
HOMEPAGE="http://fvwm-crystal.linux.net.pl/"
SRC_URI="http://fvwm-crystal.linux.net.pl/files/files/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="xmms"
RDEPEND=">=x11-wm/fvwm-2.5.10
	app-admin/sudo
	media-gfx/imagemagick
	media-sound/aumix
	x11-misc/fvwm-crystal-apps
	x11-misc/habak
	x11-misc/xdaliclock
	x11-terms/aterm
	xmms? ( media-plugins/xmms-shell
		>=media-sound/xmms-1.2.7
		media-plugins/xmms-find )"

S=${WORKDIR}/${MY_P}

src_compile() {
	einfo "There is nothing to compile."
}

src_install() {
	dodoc AUTHORS COPYING INSTALL NEWS README doc/*
	dobin bin/wal.py

	dodir /usr/share/${PN}
	cp -r addons fvwm ${D}/usr/share/${PN}

	# Original session file doesn't work on Gentoo
	exeinto /etc/X11/Sessions
	doexe ${FILESDIR}/fvwm-crystal

	insinto /usr/share/xsessions
	doins addons/gdm/fvwm-crystal.desktop

	# Bug in tarball
	fperms 644 /usr/share/${PN}/fvwm/bigicons/thunderbird.png
}

pkg_postinst() {
	einfo ""
	einfo "This is a new branch of fvwm-crystal theme. If you prefer"
	einfo "to stay with versions 1.x, put the following line in"
	einfo "/etc/portage/package.mask, and reemerge fvwm-crystal:"
	einfo " >=x11-themes/fvwm-crystal-2*"
	einfo ""
	einfo "In order to finish installation, copy configuration files"
	einfo "to your home directory:"
	einfo " $ mkdir ~/.fvwm/"
	einfo " $ cp -r /usr/share/${PN}/fvwm/* ~/.fvwm/"
	einfo " $ cp /usr/share/${PN}/fvwm/.fvwm2rc ~/.fvwm/"
	einfo " $ cp -r /usr/share/${PN}/addons/Xresources ~/.Xresources"
	einfo ""
	einfo "If you start X server by command startx, execute additionally:"
	einfo " $ cp -r /usr/share/${PN}/addons/Xsession ~/.xinitrc"
	einfo ""
	einfo "Authors of fvwm-crystal recommend also installing"
	einfo "the following applications:"
	einfo " app-admin/gkrellm"
	einfo " app-misc/rox"
	einfo " media-gfx/scrot"
	einfo " x11-misc/xlockmore"
	einfo " x11-misc/xpad"
	einfo " x11-misc/xscreensaver"
	einfo ""
}

