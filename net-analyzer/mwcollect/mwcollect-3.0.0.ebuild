# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/mwcollect/mwcollect-3.0.0.ebuild,v 1.1.1.1 2005/11/30 10:12:29 chriswhite Exp $

inherit eutils

DESCRIPTION="mwcollect collects worms and other autonomous spreading malware"
HOMEPAGE="http://www.mwcollect.org/"
SRC_URI="http://download.mwcollect.org/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="debug"

DEPEND="dev-libs/libpcre
	net-misc/curl
	>=sys-libs/libcap-1"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
	-e "s:CXXFLAGS += -I./src/include:CXXFLAGS += ${CXXFLAGS} -I./src/include:" \
	Makefile || die "custom CFLAGS patching failed"

	sed -i \
	-e "s:\$(MODULE_OBJ) \$(LDFLAGS):\$(MODULE_OBJ) \$(LDFLAGS) -fPIC:" \
	Makefile.MODULE || die "pic patching failed"

	sed -i \
	-e "s:%loadModule(\":%loadModule(\"\/usr\/lib\/mwcollect\/:g" \
	conf/mwcollect.conf || die "module load directory failed"

	# sets CAP_SETUID for setresuid
	epatch "${FILESDIR}"/${P}-capacity.patch
}

src_compile() {
	if use debug
	then
		emake DEBUG="y" || die "Make failed"
	else
		emake || die "Make failed"
	fi
}

src_install() {
	dosbin bin/mwcollectd
	insinto /usr/$(get_libdir)/mwcollect
	doins bin/modules/*

	insinto /etc/mwcollect
	doins conf/* \
		|| die "config file installation failed"

	dodoc README* doc/core-design.txt
	mv doc/mwcollectd.1.man doc/mwcollectd.1
	doman doc/mwcollectd.1

	newinitd ${FILESDIR}/initd mwcollectd
	insinto /etc/conf.d
	newins ${FILESDIR}/confd mwcollectd
}
