# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-find/xmms-find-0.4.7.ebuild,v 1.3 2003/07/12 18:40:45 aliz Exp $

IUSE=""

MY_P=${PN/-/}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="An xmms plugin to allow searching, enqueuing and playing of files"
HOMEPAGE="http://xmmsfind.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmmsfind/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="media-sound/xmms"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	plugin_install_dir="${D}$(xmms-config --general-plugin-dir)"
	make \
		PLUGIN_INSTALL_DIR=${plugin_install_dir} \
		REMOTE_INSTALL_DIR=${D}usr/bin install || die "install failed"

	dodoc BUGS COPYING INSTALL README TODO VERSION
}
