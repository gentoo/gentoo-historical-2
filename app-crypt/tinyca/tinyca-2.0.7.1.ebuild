# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/tinyca/tinyca-2.0.7.1.ebuild,v 1.1 2005/12/10 18:11:53 vanquirius Exp $

MY_P="${PN}${PV/./-}"
DESCRIPTION="Simple Perl/Tk GUI to manage a small certification authority"
HOMEPAGE="http://tinyca.sm-zone.net/"
SRC_URI="http://tinyca.sm-zone.net/${MY_P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"
IUSE=""

RDEPEND=">=dev-libs/openssl-0.9.7e
	dev-perl/Locale-gettext
	>=perl-core/MIME-Base64-2.12
	dev-perl/gtk2-perl"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:./lib:/usr/share/tinyca/lib:g' \
		-e 's:./templates:/usr/share/tinyca/templates:g' \
		-e 's:./locale:/usr/share/locale:g' tinyca2
}

src_compile() {
	make -C po
}

src_install() {
	exeinto /usr/bin
	newexe tinyca2 tinyca
	insinto /usr/share/tinyca/lib
	doins lib/*.pm
	insinto /usr/share/tinyca/lib/GUI
	doins lib/GUI/*.pm
	insinto /usr/share/tinyca/templates
	doins templates/*
	insinto /usr/share/
	for LANG in de es cs; do
		dodir /usr/share/locale/${LANG}/LC_MESSAGES/
		insinto /usr/share/locale/${LANG}/LC_MESSAGES/
		doins locale/$LANG/LC_MESSAGES/tinyca2.mo
	done
}
