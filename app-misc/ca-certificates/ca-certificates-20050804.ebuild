# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ca-certificates/ca-certificates-20050804.ebuild,v 1.6 2007/02/03 01:37:20 vapier Exp $

inherit eutils

DESCRIPTION="Common CA Certificates PEM files"
HOMEPAGE="http://www.cacert.org/"
SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${PV}_all.deb"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-libs/openssl"

S=${WORKDIR}

src_unpack() {
	echo ">>> Unpacking ${A} to ${PWD}"
	cp "${DISTDIR}"/${A} .
	ar x ${A} || die "failure unpacking ${A}"
}

src_install() {
	cd "${D}"
	tar zxf "${S}"/data.tar.gz || die "installing data failed"

	(
	cd "${D}"/usr/share/ca-certificates
	find . -name '*.crt' | sort | cut -b3-
	) > etc/ca-certificates.conf

	mv "${D}"/usr/share/doc/{ca-certificates,${PF}} || die
	prepalldocs
}

pkg_postinst() {
	[[ ${ROOT} != "/" ]] && return 0
	update-ca-certificates
}
