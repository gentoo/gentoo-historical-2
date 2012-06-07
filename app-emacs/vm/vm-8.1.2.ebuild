# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/vm/vm-8.1.2.ebuild,v 1.3 2012/06/07 20:58:10 ranger Exp $

EAPI=4

inherit elisp eutils

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="The VM mail reader for Emacs"
HOMEPAGE="http://www.nongnu.org/viewmail/"
SRC_URI="http://launchpad.net/vm/${PV%.*}.x/${MY_PV}/+download/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc ~x86"
IUSE="bbdb ssl"

DEPEND="bbdb? ( app-emacs/bbdb )"
RDEPEND="!app-emacs/u-vm-color
	${DEPEND}
	ssl? ( net-misc/stunnel )"

S="${WORKDIR}/${MY_P}"
SITEFILE="50${PN}-gentoo-8.0.el"

src_prepare() {
	if ! use bbdb; then
		elog "Excluding vm-pcrisis.el since the \"bbdb\" USE flag is not set."
		epatch "${FILESDIR}/${PN}-8.0-no-pcrisis.patch"
	fi
}

src_configure() {
	econf \
		--with-emacs="emacs" \
		--with-pixmapdir="${SITEETC}/${PN}" \
		$(use bbdb && echo "--with-other-dirs=${SITELISP}/bbdb")
}

src_compile() {
	emake -j1
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	dodoc CHANGES NEWS README TODO example.vm
}
