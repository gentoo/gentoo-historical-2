# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/imcom/imcom-1.33.ebuild,v 1.3 2004/06/24 22:53:52 agriffis Exp $

MYVER=${PV}
S=${WORKDIR}/${PN}-${MYVER}
SRC_URI="http://imcom.floobin.cx/files/${P}.tar.gz"
#SRC_URI="http://nafai.dyndns.org/files/imcom-betas/${PN}-${MYVER}.tar.gz"
HOMEPAGE="http://imcom.floobin.cx"
DESCRIPTION="Python commandline Jabber Client"

DEPEND=">=dev-lang/python-2.2
	>=dev-python/pyxml-0.7"
RDEPEND="${DEPEND}"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE=""

src_compile() {
	./configure --prefix=/usr || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	dodoc CONTRIBUTORS LICENSE README* TODO WHATSNEW docs/CHANGELOG
	dohtml docs/*.html docs/*.png docs/*.jpg docs/*.css
	doman docs/imcom.1
	make prefix=${D}/usr install-bin
}
