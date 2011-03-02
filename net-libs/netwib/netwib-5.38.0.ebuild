# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/netwib/netwib-5.38.0.ebuild,v 1.5 2011/03/02 08:58:03 radhermit Exp $

# NOTE: netwib, netwox and netwag go together, bump all or bump none

EAPI="2"

inherit toolchain-funcs multilib

DESCRIPTION="Library of Ethernet, IP, UDP, TCP, ICMP, ARP and RARP protocols"
HOMEPAGE="http://ntwib.sourceforge.net/"
SRC_URI="mirror://sourceforge/ntwib/${P}-src.tgz
	doc? ( mirror://sourceforge/ntwib/${P}-doc_html.tgz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc x86"
IUSE="doc"

DEPEND="net-libs/libpcap
	>=net-libs/libnet-1.1.1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-src/src"

src_prepare() {
	sed -i \
		-e 's:/man$:/share/man:g' \
		-e "s:/lib:/$(get_libdir):" \
		-e "s:/usr/local:/usr:" \
		-e "s:=ar:=$(tc-getAR):" \
		-e "s:=ranlib:=$(tc-getRANLIB):" \
		-e "s:=gcc:=$(tc-getCC):" \
		-e "s:-O2:${CFLAGS}:" \
		config.dat
}

src_configure() {
	sh genemake || die "problem creating Makefile"
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc ../README.TXT
	if use doc; then
		mkdir "${D}"/usr/share/doc/${PF}/html
		mv "${WORKDIR}"/${P}-doc_html/{index.html,${PN}} \
			"${D}"/usr/share/doc/${PF}/html
	fi

	cd "${S}"/..
	dodoc doc/{changelog.txt,credits.txt,integration.txt} \
		doc/{problemreport.txt,problemusageunix.txt,todo.txt}
}
