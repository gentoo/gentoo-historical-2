# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dnotify/dnotify-0.18.0.ebuild,v 1.2 2005/08/21 02:26:43 vapier Exp $

DESCRIPTION="Execute a command when the contents of a directory change"
HOMEPAGE="http://oskarsapps.mine.nu/dnotify.html"
SRC_URI="http://oskarsapps.mine.nu/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc -sparc ~x86"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	econf $(use_enable nls) || die "failed to configure"
	emake || die "failed to make"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS TODO NEWS README
}
