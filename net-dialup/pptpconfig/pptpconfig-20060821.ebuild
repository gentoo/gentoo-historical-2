# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/pptpconfig/pptpconfig-20060821.ebuild,v 1.1 2006/09/23 14:32:16 mrness Exp $

inherit depend.php

DESCRIPTION="Configuration and management program for PPTP Client tunnels"
HOMEPAGE="http://pptpclient.sourceforge.net/"
SRC_URI="mirror://sourceforge/pptpclient/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-php4/php-gtk
	net-dialup/pptpclient
	sys-apps/iproute2"

pkg_setup() {
	require_php_with_use cli pcntl pcre posix session
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog DEVELOPERS NEWS README TODO
	dosed 's:/usr/lib/php-pcntl/bin/php:/usr/bin/php:' /usr/bin/pptpconfig.php
}
