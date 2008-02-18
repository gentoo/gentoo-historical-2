# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libeXosip/libeXosip-3.1.0.ebuild,v 1.1 2008/02/18 21:28:53 vapier Exp $

MY_PV=${PV%.?}-${PV##*.}
MY_PV=${PV}
MY_P=${PN}2-${MY_PV}
DESCRIPTION="library that hides the complexity of using the SIP protocol for multimedia session establishement"
HOMEPAGE="http://savannah.nongnu.org/projects/exosip/"
SRC_URI="http://download.savannah.nongnu.org/releases/exosip/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~x86 ~ppc"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

#		josua? ( >=net-libs/ortp-0.7.1 )"
DEPEND=">=net-libs/libosip-3.0.3"

S=${WORKDIR}/${MY_P}

src_compile() {
	# $(use_enable josua)
	econf --disable-josua || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README ChangeLog AUTHORS NEWS eXosip_addidentity.sh
}
