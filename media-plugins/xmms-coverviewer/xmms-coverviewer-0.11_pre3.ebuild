# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-coverviewer/xmms-coverviewer-0.11_pre3.ebuild,v 1.1 2004/01/28 02:48:40 raker Exp $

IUSE=""

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="An XMMS plugin for viewing album covers"
HOMEPAGE="http://coverviewer.sourceforge.net/"
SRC_URI="mirror://sourceforge/coverviewer/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa"

DEPEND="=x11-libs/gtk+-1.2*
	media-libs/gdk-pixbuf
	media-sound/xmms"

src_compile() {

	econf

	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc AUTHORS INSTALL NEWS
}

pkg_postinst() {
	ewarn ""
	ewarn "Do not attempt to configure the plugin right away!"
	ewarn "Enable the plugin.  Sane default values will be applied."
	ewarn "After that, changing options is fine."
	ewarn "To use Internet-search, you'll need python"
	ewarn ""
}
