# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellweather/gkrellweather-2.0.3.ebuild,v 1.7 2003/06/12 22:25:36 msterret Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GKrellM2 Plugin that monitors a METAR station and displays weather
info"
SRC_URI="http://kmlinux.fjfi.cvut.cz/~makovick/gkrellm/${P}.tgz"
HOMEPAGE="http://kmlinux.fjfi.cvut.cz/~makovick/gkrellm/index.html"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

DEPEND="=app-admin/gkrellm-2*
	=sys-apps/sed-4*
	>=net-misc/wget-1.5.3"

RDEPEND="${DEPEND}
	>=dev-lang/perl-5.6.1"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e "s:/usr/local/bin:/usr/share/gkrellm:g" \
		-e "s:GrabWeather:GrabWeather2:g" \
		gkrellweather.c

}

src_compile() {
	emake || die
}

src_install () {
	exeinto /usr/share/gkrellm
	newexe GrabWeather GrabWeather2

	insinto /usr/lib/gkrellm2/plugins
	doins gkrellweather.so
	dodoc README ChangeLog COPYING
}
