# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-find/xmms-find-0.4.7.ebuild,v 1.7 2004/04/27 19:56:31 pvdabeel Exp $

IUSE=""

MY_P=${PN/-/}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="An xmms plugin to allow searching, enqueuing and playing of files"
HOMEPAGE="http://xmmsfind.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmmsfind/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

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
