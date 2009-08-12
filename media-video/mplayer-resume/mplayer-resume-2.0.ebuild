# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mplayer-resume/mplayer-resume-2.0.ebuild,v 1.1 2009/08/12 03:19:52 beandog Exp $

EAPI="2"

inherit depend.php

DESCRIPTION="MPlayer wrapper script to save/resume playback position"
HOMEPAGE="http://www.spaceparanoids.org/trac/bend/wiki/mplayer-resume"
SRC_URI="http://spaceparanoids.org/downloads/mplayer-resume/${P}.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lirc"
DEPEND=""
RDEPEND="lirc? ( app-misc/lirc
		media-video/mplayer[lirc] )
	media-video/mplayer"

need_php_cli

pkg_setup() {
	require_php_with_use pcre cli
}

src_compile() {
	return;
}

src_install() {
	dobin mplayer-resume
	dodoc ChangeLog README
}

pkg_postinst() {
	elog "To get mplayer-resume to save playback position with LIRC,"
	elog "you will need to setup an entry in ~/.lircrc to run "
	elog "'get_time_pos' and then 'quit'.  More instructions are"
	elog "detailed in the README, but the position will not be saved"
	elog "until you set it up."
	elog ""
	elog "Playback position files are saved in ~/.mplayer/playback"
}
