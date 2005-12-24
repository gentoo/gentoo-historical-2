# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/quantlib/quantlib-0.3.10.ebuild,v 1.4 2005/12/24 14:23:27 hansmi Exp $

IUSE=""

MY_P=${P/q/Q}
MY_P=${MY_P/l/L}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A comprehensive software framework for quantitative finance"
HOMEPAGE="http://www.quantlib.org"
SRC_URI="mirror://sourceforge/quantlib/${MY_P}.tar.gz"

DEPEND="sys-devel/libtool
	dev-libs/boost"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ppc ~sparc x86"

src_install(){
	einstall || die "einstall failed"
	dodoc *.txt
}
