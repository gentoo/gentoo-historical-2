# Copyright 2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License
# $Header: /var/cvsroot/gentoo-x86/app-portage/deltup/deltup-0.4.0.ebuild,v 1.1 2003/08/15 13:25:55 lanius Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Patch system for Gentoo sources.  Retains MD5 codes"
HOMEPAGE="http://deltup.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~mips ~hppa ~arm"

DEPEND=">=dev-util/xdelta-1.1.3
	>=sys-apps/bzip2-1.0.0"

src_install () {
	make DESTDIR=${D} install || die
	dodoc README ChangeLog GENTOO
	doman deltup.1
}
