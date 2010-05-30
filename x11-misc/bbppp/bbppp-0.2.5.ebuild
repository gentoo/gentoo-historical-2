# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbppp/bbppp-0.2.5.ebuild,v 1.1 2010/05/30 18:29:20 xarthisius Exp $

EAPI=2

inherit autotools eutils

DESCRIPTION="blackbox ppp frontend/monitor"
HOMEPAGE="http://bbtools.windsofstorm.net/sources/available.phtml#bbppp"
SRC_URI="mirror://sourceforge/bbtools/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}
	virtual/blackbox"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc3-multiline.patch \
		"${FILESDIR}"/${PN}-asneeded.patch
	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc README AUTHORS BUGS ChangeLog NEWS TODO data/README.bbppp || die
	rm "${D}"/usr/share/bbtools/README.bbppp
}

pkg_postinst() {
	# don't assume blackbox exists because virtual/blackbox is installed
	if [[ -x ${ROOT}/usr/bin/blackbox ]] ; then
		if ! grep bbppp "${ROOT}"/usr/bin/blackbox &>/dev/null ; then
			sed -e "s/.*blackbox/exec \/usr\/bin\/bbppp \&\n&/" blackbox | cat > blackbox
		fi
	fi
}
