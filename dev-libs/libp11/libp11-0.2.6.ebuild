# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libp11/libp11-0.2.6.ebuild,v 1.7 2009/09/27 20:06:56 nixnut Exp $

EAPI="2"

DESCRIPTION="Libp11 is a library implementing a small layer on top of PKCS#11 API to make using PKCS#11 implementations easier."
HOMEPAGE="http://www.opensc-project.org/libp11/"

if [[ "${PV}" = "9999" ]]; then
	inherit autotools subversion
	ESVN_REPO_URI="http://www.opensc-project.org/svn/${PN}/trunk"
else
	SRC_URI="http://www.opensc-project.org/files/${PN}/${P}.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="doc"

RDEPEND="dev-libs/openssl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

if [[ "${PV}" = "9999" ]]; then
	DEPEND="${DEPEND}
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt"

	src_prepare() {
		eautoreconf
	}
fi

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--htmldir="/usr/share/doc/${PF}/html" \
		$(use_enable doc) \
		$(use_enable doc api-doc)
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
}
