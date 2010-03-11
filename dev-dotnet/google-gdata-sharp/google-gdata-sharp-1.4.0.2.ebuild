# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/google-gdata-sharp/google-gdata-sharp-1.4.0.2.ebuild,v 1.1 2010/03/11 18:44:20 ford_prefect Exp $

EAPI=3

inherit base mono

MY_PN="libgoogle-data-mono"

DESCRIPTION="C# bindings for the Google GData API"
HOMEPAGE="http://code.google.com/p/google-gdata/"
SRC_URI="http://google-gdata.googlecode.com/files/${MY_PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/mono-2.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"
# The Makefile has prefix=/usr/local by default :|
MAKEOPTS="PREFIX=/usr ${MAKEOPTS}"

src_prepare() {
	epatch "${FILESDIR}"/pkgconfig-typo-fix.patch
}
