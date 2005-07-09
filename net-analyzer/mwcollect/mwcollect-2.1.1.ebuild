# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/mwcollect/mwcollect-2.1.1.ebuild,v 1.1 2005/07/09 09:09:13 chriswhite Exp $

DESCRIPTION="mwcollect collects worms and other autonomous spreading malware"
HOMEPAGE="http://www.mwcollect.org/"
MY_PV="2.1.1"
MY_P=${PN}${MY_PV}
S="${WORKDIR}/${MY_P}"
SRC_URI="http://download.mwcollect.org/${MY_P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="dev-libs/libpcre
	net-misc/curl"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
	-e "s:CXXFLAGS = .*:CXXFLAGS = ${CXXFLAGS} -D LINUX -D_GNU_SOURCE -g -Wall:" \
	Makefile.LINUX || die "CFLAGS patching failed"
}

src_compile() {
	emake -f Makefile.LINUX || die "emake failed"
}

src_install() {
	dosbin bin/mwcollectd
	insinto /usr/$(get_libdir)/mwcollect
	doins bin/modules/*

	sed -e "s#\./bin/modules#/usr/$(get_libdir)/mwcollect#g" \
		mwcollectd.conf.dist > mwcollectd.conf.gentoo \
		|| die "sed failed"

	insinto /etc/mwcollect
	doins mwcollectd.conf.gentoo \
		|| die "newins mwcollectd.conf failed"

	dodoc README*

	newinitd ${FILESDIR}/initd mwcollectd
	insinto /etc/conf.d
	newins ${FILESDIR}/confd mwcollectd
}
