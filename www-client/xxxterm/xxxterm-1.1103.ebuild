# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/xxxterm/xxxterm-1.1103.ebuild,v 1.2 2012/04/29 18:02:39 ago Exp $

EAPI="4"

GIT_ECLASS=
if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS=git-2
fi

inherit eutils fdo-mime toolchain-funcs ${GIT_ECLASS}

DESCRIPTION="A minimalist web browser with sophisticated security features designed-in"
HOMEPAGE="http://opensource.conformal.com/wiki/xxxterm"

MY_P="${PN}-${PV/0/.}"

KEYWORDS=""
if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://opensource.conformal.com/xxxterm.git
		https://opensource.conformal.com/git/xxxterm.git"
	EGIT_SOURCEDIR="${WORKDIR}/${MY_P}"
else
	SRC_URI="http://opensource.conformal.com/snapshots/${PN}/${MY_P}.tgz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE=""

DEPEND="x11-libs/gtk+:2
	net-libs/webkit-gtk:2
	net-libs/libsoup
	net-libs/gnutls
	dev-libs/libbsd"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/linux"

src_prepare() {
	sed -i \
		-e 's/-O2//' \
		-e 's/-ggdb3//' \
		Makefile || die 'sed Makefile failed.'
	sed -i \
		-e 's#https://www\.cyphertite\.com#http://www.gentoo.org/#' \
		-e "s#/usr/local#/usr#" \
		../xxxterm.c || die 'sed ../xxxterm.c failed.'
	sed -i \
		"s#Icon=#Icon=/usr/share/${PN}/#" \
		../xxxterm.desktop || die 'sed ../xxxterm.desktop failed.'
}

src_compile() {
	CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDADD="${LDFLAGS}" emake
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX=/usr install

	insinto "/usr/share/${PN}"
	doins ../*.png ../style.css
	insinto /usr/share/applications
	doins ../xxxterm.desktop
	insinto "/usr/share/doc/${PF}/examples"
	doins ../xxxterm.conf ../playflash.sh ../favorites
	doman ../xxxterm.1
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
