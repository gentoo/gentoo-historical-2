# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/nesc/nesc-1.2.2.ebuild,v 1.1 2006/01/29 12:01:07 sanchan Exp $

inherit eutils flag-o-matic

DESCRIPTION="An extension to gcc that knows how to compile nesC applications"
HOMEPAGE="http://nescc.sourceforge.net/"
SRC_URI="mirror://sourceforge/nescc/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"
DEPEND=">=dev-lang/perl-5.8.5-r2
	>=dev-tinyos/tos-1.1.0
	>=virtual/jdk-1.4.2"

RDEPEND=">=dev-lang/perl-5.8.5-r2
	>=dev-tinyos/tos-1.1.0
	>=virtual/jre-1.4.2"

pkg_setup() {
	if [ -z "${TOSDIR}" ]
	then
		# best to make an assumption
		export TOSDIR=/usr/src/tinyos-1.x/tos
	fi

	if [ ! -d "${TOSDIR}" ]
	then
		eerror "In order to compile nesc you have to set the"
		eerror "\$TOSDIR environment properly."
		eerror ""
		eerror "You can achieve this by emerging >=dev-tinyos/tos-1.1.15"
		eerror "or by exporting TOSDIR=\"path to your tinyos dir\""
		die "Couldn't find a valid TinyOS home"
	else
		einfo "Building nesC for ${TOSDIR}"
	fi
}

src_compile() {
	append-ldflags $(bindnow-flags)
	econf --disable-dependency-tracking || die "econf failed"
	# language setting needed, otherwise gcc version
	# will sometimes not be detected right
	LANGUAGE=C emake || die "emake failed"
}

src_install() {
	LANGUAGE=C einstall || die "einstall failed"
	if use doc
	then
		dohtml -r -a html,jpg,pdf,txt doc/*
	fi
	newdoc README NEWS
	dodoc doc/README
	newdoc tools/java/net/tinyos/nesc/dump/README README.dump
	newdoc tools/java/net/tinyos/nesc/wiring/README README.wiring
}
