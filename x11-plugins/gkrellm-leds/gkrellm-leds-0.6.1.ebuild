# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-leds/gkrellm-leds-0.6.1.ebuild,v 1.4 2002/12/09 04:41:56 manson Exp $

MY_P=${P/rellm-/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Gkrellm plugin for monitoring keyboard LEDs"
SRC_URI="http://www.stud.ifi.uio.no/~oyvinha/gkleds/${MY_P}.tar.gz"
HOMEPAGE="http://www.stud.ifi.uio.no/~oyvinha/gkleds/"

DEPEND="=app-admin/gkrellm-1.2*"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc "

src_compile() {
	make || die
}

src_install() {
	insinto /usr/lib/gkrellm/plugins
	doins gkleds.so

	dodoc COPYING Changelog License TODO INSTALL README
}
