# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellweather/gkrellweather-2.0.7.ebuild,v 1.3 2007/04/26 19:01:58 armin76 Exp $

inherit gkrellm-plugin

IUSE=""
DESCRIPTION="GKrellM2 Plugin that monitors a METAR station and displays weather
info"
SRC_URI="http://kmlinux.fjfi.cvut.cz/~makovick/gkrellm/${P}.tgz"
HOMEPAGE="http://kmlinux.fjfi.cvut.cz/~makovick/gkrellm/index.html"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc x86"

RDEPEND=">=dev-lang/perl-5.6.1
	>=net-misc/wget-1.5.3"
DEPEND=">=sys-apps/sed-4.0.5"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e "s:GrabWeather:GrabWeather2:g" \
		-e "s:/usr/share/gkrellm:/usr/bin:g" \
		gkrellweather.c
}

src_compile() {
	emake PREFIX=/usr || die
}

src_install () {
	gkrellm-plugin_src_install

	exeinto /usr/bin
	newexe GrabWeather GrabWeather2
}
